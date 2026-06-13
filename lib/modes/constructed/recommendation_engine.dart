import '../../core/game_state.dart';
import '../../core/recommendation.dart';
import '../../core/sim/board_eval.dart';
import '../../core/sim/keyword_parser.dart';
import '../../core/sim/attack_planner.dart';
import '../../core/sim/card_effects.dart';
import '../../data/cache_manager.dart';

/// Produces ranked next-step recommendations for a constructed turn — covering
/// playing cards, hero power, attacks, and ending the turn.
class ConstructedEngine {
  const ConstructedEngine({required this.cache, this.personalGames = 0});

  final CacheManager cache;
  final int personalGames;

  double get _personalWeight => (personalGames / 200.0).clamp(0.0, 0.3);

  List<Recommendation> recommend(ConstructedState state) {
    // Opening-hand mulligan — keep/toss advice per card.
    if (state.isMulligan) return _mulligan(state);

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

  // ---- Mulligan (opening hand keep/toss) -------------------------------------

  /// Scores each opening-hand card for keep vs toss. Core idea: early-game
  /// curve wins games — keep cheap cards, toss expensive ones. On the coin you
  /// can keep one slot higher. Removal / cheap minions / card draw bias toward
  /// keep; winrate nudges when known.
  List<Recommendation> _mulligan(ConstructedState state) {
    // The coin lets you keep one mana-slot higher (extra mana turn 1).
    final keepCeiling = state.hasCoin ? 4 : 3;

    final recs = <Recommendation>[];
    for (final card in state.hand) {
      // The Coin itself: always implicitly kept, don't advise on it.
      if (card.cardId == 'GAME_005') continue;

      final h = _hints(card);
      double keepScore;
      final reasons = <String>[];

      // Base on cost curve.
      if (card.cost <= 1) {
        keepScore = 0.85;
        reasons.add('cheap (${card.cost})');
      } else if (card.cost <= keepCeiling) {
        keepScore = 0.7 - (card.cost - 1) * 0.08;
        reasons.add('on-curve (${card.cost})');
      } else {
        keepScore = 0.3 - (card.cost - keepCeiling) * 0.05;
        reasons.add('expensive (${card.cost})');
      }

      // Effect adjustments.
      if (h.isRemoval || h.damage > 0) {
        keepScore += 0.12;
        reasons.add('removal');
      }
      if (h.drawCount > 0) {
        keepScore += 0.08;
        reasons.add('draws');
      }
      if (card.type == CardType.minion && card.cost >= 2 && card.cost <= keepCeiling) {
        keepScore += 0.05; // early board body
      }
      // Big expensive battlecry/value cards: extra toss bias early.
      if (card.cost > keepCeiling && (h.buffsBoard || card.type == CardType.spell)) {
        keepScore -= 0.05;
      }

      // Winrate nudge when known.
      final wr = cache.winrate(card.cardId);
      if (wr != null) {
        keepScore += (wr.winrate - 0.5) * 0.3;
        reasons.add('${(wr.winrate * 100).toStringAsFixed(0)}% WR');
      }

      keepScore = keepScore.clamp(0.0, 1.0);
      final keep = keepScore >= 0.5;
      recs.add(Recommendation.mulligan(
        card,
        score: keep ? keepScore : (1 - keepScore),
        reason: reasons.join(' · '),
        keep: keep,
      ));
    }

    // Keeps first (highest score), then tosses. Show all opening-hand cards.
    recs.sort((a, b) {
      final ak = a.type == ActionType.mulliganKeep ? 1 : 0;
      final bk = b.type == ActionType.mulliganKeep ? 1 : 0;
      if (ak != bk) return bk - ak;
      return b.score.compareTo(a.score);
    });
    return recs;
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

  // ---- Card scoring (effect + context aware) ---------------------------------

  CardEffectHints _hints(CardInHand card) {
    final meta = cache.card(card.cardId);
    return CardEffectHints.parse(meta?.text ?? '', meta?.mechanics ?? const []);
  }

  double _cardScore(CardInHand card, ConstructedState state) {
    // Base: winrate if known, else tempo by mana fill + rarity.
    double base;
    final wr = cache.winrate(card.cardId);
    if (wr != null) {
      final b = wr.winrate;
      base = b * (1 - _personalWeight) + b * _personalWeight;
    } else {
      final rarityBonus = switch (card.rarity) {
        Rarity.legendary => 0.10,
        Rarity.epic => 0.05,
        Rarity.rare => 0.02,
        Rarity.common => 0.0,
      };
      base = 0.5 + 0.3 * _manaEfficiency(card, state) + rarityBonus;
    }

    // Context multiplier from the card's likely effect vs the board.
    final ctx = _contextMultiplier(card, state);
    return (base * ctx).clamp(0.0, 1.0);
  }

  /// >1 when the card's effect is well-matched to the current board, <1 when
  /// it's a dead/weak play (e.g. AOE into empty board, buff with no minions).
  double _contextMultiplier(CardInHand card, ConstructedState state) {
    final h = _hints(card);
    if (!h.hasAnyEffect) return _boardPressure(card, state);

    final oppMinions = state.board.opponentMinions;
    final myMinions = state.board.playerMinions;
    double m = 1.0;

    // Removal / single-target damage: great if it kills something.
    if (h.isRemoval || (h.damage > 0 && !h.isAoe)) {
      final killable = oppMinions.where((e) => e.health <= h.damage || h.isRemoval);
      if (killable.isNotEmpty) {
        // Bigger reward for removing a bigger threat.
        final biggest = oppMinions.fold<int>(
            0, (mx, e) => e.attack > mx ? e.attack : mx);
        m *= 1.25 + (biggest * 0.04);
      } else if (h.damage > 0) {
        m *= 0.85; // no target — only reach value
      }
    }

    // AOE: scales with enemy board width; penalize if it clears my own wider board.
    if (h.isAoe && h.damage > 0) {
      final enemyHit = oppMinions.where((e) => e.health <= h.damage).length;
      if (enemyHit >= 2) {
        m *= 1.3 + 0.15 * (enemyHit - 2);
      } else if (oppMinions.isEmpty) {
        m *= 0.4; // dead AOE
      }
      if (h.hitsAllMinions) {
        final mineHit = myMinions.where((e) => e.health <= h.damage).length;
        if (mineHit > enemyHit) m *= 0.7; // hurts me more
      }
    }

    // Buff: wants friendly minions on board.
    if ((h.buffAttack > 0 || h.buffHealth > 0) && h.buffsBoard) {
      m *= myMinions.isEmpty ? 0.45 : (1.15 + 0.08 * myMinions.length);
    }

    // Heal: valuable when I've taken damage.
    if (h.heal > 0 || h.armor > 0) {
      final missing = 30 - state.board.playerHp;
      m *= missing >= h.heal ? 1.15 : (missing <= 2 ? 0.7 : 1.0);
    }

    // Card draw: mild steady value.
    if (h.drawCount > 0) m *= 1.05;

    // Taunt minion when behind on board.
    if (h.givesTaunt && oppMinions.length > myMinions.length) m *= 1.15;

    return m.clamp(0.3, 2.0);
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
    final h = _hints(card);
    final wr = cache.winrate(card.cardId);
    final parts = <String>[];

    // Lead with the effect-context insight when there is one.
    final oppMinions = state.board.opponentMinions;
    final myMinions = state.board.playerMinions;
    if (h.isAoe && h.damage > 0 && oppMinions.where((e) => e.health <= h.damage).length >= 2) {
      parts.add('AOE clears ${oppMinions.where((e) => e.health <= h.damage).length}');
    } else if ((h.isRemoval || h.damage > 0) &&
        oppMinions.any((e) => e.health <= h.damage || h.isRemoval)) {
      parts.add('removes a threat');
    } else if ((h.buffAttack > 0 || h.buffHealth > 0) && h.buffsBoard && myMinions.isNotEmpty) {
      parts.add('buffs your board');
    } else if (h.heal > 0 && state.board.playerHp < 30) {
      parts.add('heals ${h.heal}');
    } else if (h.drawCount > 0) {
      parts.add('draws ${h.drawCount}');
    }

    if (wr != null) parts.add('${(wr.winrate * 100).toStringAsFixed(0)}% WR');
    parts.add('${card.cost} mana');
    if (card.cost > 0 && card.cost == state.mana) parts.add('fills curve');
    return parts.join(' · ');
  }
}
