import '../../core/game_state.dart';
import '../../core/recommendation.dart';
import '../../core/sim/board_eval.dart';
import '../../core/sim/keyword_parser.dart';
import '../../core/sim/attack_planner.dart';
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

    // 1. Attack plan — search the best full-turn attack line (order matters).
    //    Covers lethal (a line that drops the opponent to 0).
    final attackRec = _plannedAttack(state);
    if (attackRec != null) recs.add(attackRec);

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

  // ---- Attacks (planner-driven multi-attack line) ----------------------------

  /// Searches the best full-turn attack SEQUENCE (order matters: clear a blocker
  /// before it trades back, pop taunt before face, etc). Returns one attack
  /// recommendation = the FIRST step of the best line, carrying the whole plan.
  Recommendation? _plannedAttack(ConstructedState state) {
    final base = KeywordParser(cache).fromState(state);
    // No ready attackers → nothing to plan.
    final anyReady = base.playerMinions
        .any((m) => m.alive && m.attack > 0 && m.canAttack);
    if (!anyReady) return null;

    final plan = AttackPlanner.plan(base);
    if (plan.isEmpty) return null;

    final first = plan.first!;
    final steps =
        plan.steps.map((s) => '${s.attackerLabel} → ${s.targetLabel}').toList();

    if (plan.isLethal) {
      return Recommendation.attack(
        score: 1.0,
        reason: 'LETHAL — ${plan.steps.length}-attack line',
        attackerLabel: first.attackerLabel,
        targetLabel: first.targetLabel,
        isLethal: true,
        planSteps: steps,
      );
    }

    final reason = plan.steps.length > 1
        ? 'Best line (${plan.steps.length} attacks)'
        : (first.toFace ? 'Go face' : 'Trade');
    return Recommendation.attack(
      score: _swingToScore(plan.finalScore - BoardEval.score(base)),
      reason: reason,
      attackerLabel: first.attackerLabel,
      targetLabel: first.targetLabel,
      planSteps: steps,
    );
  }

  double _swingToScore(double swing) {
    // Map board swing (roughly -10..+15) to 0.05..0.95.
    return (swing / 12.0 + 0.5).clamp(0.05, 0.95);
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
