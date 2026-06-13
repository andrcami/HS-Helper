import '../../core/game_state.dart';
import '../../core/recommendation.dart';
import '../../core/sim/sim_models.dart';
import '../../core/sim/combat.dart';
import '../../core/sim/board_eval.dart';
import '../../core/sim/keyword_parser.dart';
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

  // ---- Attacks (simulation-driven) -------------------------------------------

  /// For each of my ready attackers, simulate every legal attack (face + each
  /// enemy minion, respecting taunts) and keep the highest board-value swing.
  /// The keyword combat sim handles divine shield, poison, lifesteal, windfury,
  /// reborn, taunt — so trades reflect real keyword interactions.
  List<Recommendation> _attackActions(ConstructedState state) {
    final out = <Recommendation>[];
    final parser = KeywordParser(cache);
    final base = parser.fromState(state);

    // Indices of legal opponent targets (taunts force the target set).
    final taunts = base.taunts(false);
    final tauntIdx = <int>[
      for (var j = 0; j < base.opponentMinions.length; j++)
        if (base.opponentMinions[j].has(Keyword.taunt) &&
            base.opponentMinions[j].alive)
          j
    ];
    final targetIdx = tauntIdx.isNotEmpty
        ? tauntIdx
        : [for (var j = 0; j < base.opponentMinions.length; j++) j];

    for (var i = 0; i < base.playerMinions.length; i++) {
      final attacker = base.playerMinions[i];
      if (attacker.attack <= 0 || !attacker.canAttack) continue;

      Recommendation? best;
      double bestSwing = -1e9;

      // Candidate: attack each legal minion target (matched by index in clone).
      for (final tIdx in targetIdx) {
        final target = base.opponentMinions[tIdx];
        final sim = base.clone();
        Combat.minionAttacksMinion(
            sim, sim.playerMinions[i], sim.opponentMinions[tIdx]);
        final swing = BoardEval.swing(base, sim);
        if (swing > bestSwing) {
          bestSwing = swing;
          best = Recommendation.attack(
            score: _swingToScore(swing),
            reason: _tradeReason(attacker, target),
            attackerLabel:
                '${attacker.name} (${attacker.attack}/${attacker.health})',
            targetLabel: '${target.name} (${target.attack}/${target.health})',
          );
        }
      }

      // Candidate: go face (only legal if no taunts).
      if (taunts.isEmpty) {
        final sim = base.clone();
        Combat.minionAttacksHero(sim, sim.playerMinions[i]);
        final swing = BoardEval.swing(base, sim);
        if (swing > bestSwing) {
          bestSwing = swing;
          best = Recommendation.attack(
            score: _swingToScore(swing),
            reason: '${attacker.attack} damage to face',
            attackerLabel:
                '${attacker.name} (${attacker.attack}/${attacker.health})',
            targetLabel: 'enemy hero',
          );
        }
      }

      if (best != null) out.add(best);
    }
    return out;
  }

  double _swingToScore(double swing) {
    // Map board swing (roughly -10..+15) to 0..0.95.
    final s = (swing / 12.0 + 0.5).clamp(0.05, 0.95);
    return s;
  }

  String _tradeReason(SimMinion attacker, SimMinion target) {
    final kills = attacker.attack >= target.health ||
        attacker.has(Keyword.poisonous);
    final survives = target.attack < attacker.health &&
        !target.has(Keyword.poisonous);
    final ds = target.has(Keyword.divineShield);
    if (ds) return 'Pops Divine Shield on ${target.name}';
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
