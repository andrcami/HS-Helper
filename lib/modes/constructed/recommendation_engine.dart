import '../../core/game_state.dart';
import '../../core/recommendation.dart';
import '../../data/cache_manager.dart';

/// Produces ranked next-step recommendations for a constructed turn — covering
/// playing cards, hero power, attacks, and ending the turn.
class ConstructedEngine {
  const ConstructedEngine({required this.cache, this.personalGames = 0});

  final CacheManager cache;
  final int personalGames;

  double get _personalWeight => (personalGames / 200.0).clamp(0.0, 0.3);

  List<Recommendation> recommend(ConstructedState state) {
    // Only advise on your own turn.
    if (!state.isPlayerTurn) return const [];

    final recs = <Recommendation>[];

    // 1. Lethal check across all attackers (board + weapon/hero).
    final lethal = _lethalCheck(state);
    if (lethal != null) recs.add(lethal);

    // 2. Play cards.
    for (final card in state.hand) {
      if (card.cost > state.mana) continue;
      recs.add(Recommendation.playCard(
        card,
        score: _cardScore(card, state),
        reason: _cardReason(card, state),
        isLethal: false,
      ));
    }

    // 3. Attacks (each ready minion → best target).
    recs.addAll(_attackActions(state));

    // 4. Hero power (if available + affordable).
    if (state.heroPowerAvailable && state.mana >= 2) {
      recs.add(Recommendation.heroPower(
        score: 0.45,
        reason: 'Use leftover mana for value/tempo',
      ));
    }

    recs.sort((a, b) => b.score.compareTo(a.score));
    final top = recs.take(4).toList();

    // 5. End turn — always offer as the floor option when little else is strong.
    final bestNonEnd = top.isEmpty ? 0.0 : top.first.score;
    if (bestNonEnd < 0.35 || top.isEmpty) {
      top.add(Recommendation.endTurn(
        reason: top.isEmpty
            ? 'No plays available'
            : 'Nothing impactful left — pass',
      ));
    }

    return top;
  }

  // ---- Lethal ----------------------------------------------------------------

  Recommendation? _lethalCheck(ConstructedState state) {
    final oppHp = state.board.opponentHp;
    if (oppHp <= 0) return null;
    // Opponent taunts block face damage — no simple lethal.
    final hasTaunt = state.board.opponentMinions.any((m) => m.hasTaunt);
    if (hasTaunt) return null;

    // Sum of attack from ready minions + weapon.
    final readyAttack = state.board.playerMinions
        .fold<int>(0, (sum, m) => sum + m.attack);
    final total = readyAttack + state.weaponAttack;

    if (total >= oppHp) {
      return Recommendation.attack(
        score: 1.0,
        reason: 'LETHAL — $total damage vs $oppHp HP',
        attackerLabel: 'All attackers',
        targetLabel: 'enemy hero',
        isLethal: true,
      );
    }
    return null;
  }

  // ---- Attacks ---------------------------------------------------------------

  List<Recommendation> _attackActions(ConstructedState state) {
    final out = <Recommendation>[];
    final oppMinions = state.board.opponentMinions;
    final taunts = oppMinions.where((m) => m.hasTaunt).toList();

    for (final m in state.board.playerMinions) {
      if (m.attack <= 0) continue;

      if (taunts.isNotEmpty) {
        // Must hit a taunt. Prefer a favorable/even trade.
        final target = _bestTrade(m, taunts);
        out.add(Recommendation.attack(
          score: _tradeScore(m, target),
          reason: _tradeReason(m, target),
          attackerLabel: '${m.name} (${m.attack}/${m.health})',
          targetLabel: '${target.name} (${target.attack}/${target.health})',
        ));
      } else {
        // Free to go face or trade. Recommend face pressure by default; a strong
        // favorable trade scores higher when one exists.
        final trade = oppMinions.isEmpty ? null : _bestTrade(m, oppMinions);
        if (trade != null && _isFavorable(m, trade)) {
          out.add(Recommendation.attack(
            score: _tradeScore(m, trade),
            reason: _tradeReason(m, trade),
            attackerLabel: '${m.name} (${m.attack}/${m.health})',
            targetLabel: '${trade.name} (${trade.attack}/${trade.health})',
          ));
        } else {
          out.add(Recommendation.attack(
            score: 0.55,
            reason: '${m.attack} damage to face',
            attackerLabel: '${m.name} (${m.attack}/${m.health})',
            targetLabel: 'enemy hero',
          ));
        }
      }
    }
    return out;
  }

  MinionOnBoard _bestTrade(MinionOnBoard attacker, List<MinionOnBoard> targets) {
    // Prefer killing the highest-attack enemy we can kill without dying; else
    // the one we kill outright; else the biggest threat.
    targets.sort((a, b) {
      final aKill = attacker.attack >= a.health ? 1 : 0;
      final bKill = attacker.attack >= b.health ? 1 : 0;
      if (aKill != bKill) return bKill - aKill;
      return b.attack - a.attack;
    });
    return targets.first;
  }

  bool _isFavorable(MinionOnBoard attacker, MinionOnBoard target) {
    final kills = attacker.attack >= target.health;
    final survives = target.attack < attacker.health;
    return kills && survives;
  }

  double _tradeScore(MinionOnBoard attacker, MinionOnBoard target) {
    final kills = attacker.attack >= target.health;
    final survives = target.attack < attacker.health;
    if (kills && survives) return 0.8; // clean kill
    if (kills) return 0.65; // trade up/even
    return 0.4; // chip only
  }

  String _tradeReason(MinionOnBoard attacker, MinionOnBoard target) {
    final kills = attacker.attack >= target.health;
    final survives = target.attack < attacker.health;
    if (kills && survives) return 'Clean kill, minion survives';
    if (kills) return 'Trade into ${target.name}';
    return 'Chip ${attacker.attack} into ${target.name}';
  }

  // ---- Card scoring (unchanged heuristic) ------------------------------------

  double _cardScore(CardInHand card, ConstructedState state) {
    final wr = cache.winrate(card.cardId);
    if (wr != null) {
      final base = wr.winrate;
      final blended = base * (1 - _personalWeight) + base * _personalWeight;
      return (blended * _manaEfficiency(card, state) * _boardPressure(card, state))
          .clamp(0.0, 1.0);
    }
    final rarityBonus = switch (card.rarity) {
      Rarity.legendary => 0.10,
      Rarity.epic => 0.05,
      Rarity.rare => 0.02,
      Rarity.common => 0.0,
    };
    final tempo = 0.5 + 0.4 * _manaEfficiency(card, state) + rarityBonus;
    return (tempo * _boardPressure(card, state)).clamp(0.0, 1.0);
  }

  double _manaEfficiency(CardInHand card, ConstructedState state) {
    if (state.mana <= 0) return 0.5;
    return (card.cost / state.mana).clamp(0.3, 1.0);
  }

  double _boardPressure(CardInHand card, ConstructedState state) {
    if (state.board.opponentMinions.length > 2 &&
        card.mechanics.contains('TAUNT')) {
      return 1.2;
    }
    return 1.0;
  }

  String _cardReason(CardInHand card, ConstructedState state) {
    final wr = cache.winrate(card.cardId);
    final parts = <String>[];
    if (wr != null) parts.add('${(wr.winrate * 100).toStringAsFixed(1)}% WR');
    parts.add('${card.cost} mana');
    if (card.cost > 0 && card.cost == state.mana) parts.add('fills curve');
    if (card.mechanics.contains('TAUNT') &&
        state.board.opponentMinions.length > 2) {
      parts.add('taunt vs board');
    }
    return parts.join(' · ');
  }
}
