import 'sim_models.dart';
import 'combat.dart';
import 'board_eval.dart';

/// One attack in a planned sequence (indices into the board at plan start are
/// not stable across the sim, so we carry human labels + a kind).
class AttackStep {
  const AttackStep({
    required this.attackerLabel,
    required this.targetLabel,
    required this.toFace,
  });
  final String attackerLabel;
  final String targetLabel;
  final bool toFace;
}

class AttackPlan {
  const AttackPlan({required this.steps, required this.finalScore, required this.isLethal});
  final List<AttackStep> steps;
  final double finalScore;
  final bool isLethal;

  bool get isEmpty => steps.isEmpty;
  AttackStep? get first => steps.isEmpty ? null : steps.first;
}

/// Searches attack-only sequences for the highest-value full-turn line.
/// Order matters (kill a blocker first so it can't trade back; clear taunt then
/// go face). Greedy-best-first with full enumeration — fine for <=7 attackers.
class AttackPlanner {
  /// Node cap to keep worst cases bounded (wide boards). Sequences explored
  /// beyond this are pruned; we still return the best line found so far.
  static const _maxNodes = 4000;

  static AttackPlan plan(SimBoard board) {
    var nodeBudget = _maxNodes;

    AttackPlan best = AttackPlan(
      steps: const [],
      finalScore: BoardEval.score(board),
      isLethal: board.opponentHp <= 0,
    );

    void search(SimBoard b, List<AttackStep> acc) {
      if (nodeBudget-- <= 0) return;

      // Lethal: opponent dead — this line wins, stop here.
      if (b.opponentHp <= 0) {
        best = AttackPlan(steps: List.of(acc), finalScore: 1e9, isLethal: true);
        return;
      }

      final score = BoardEval.score(b);
      if (score > best.finalScore && !best.isLethal) {
        best = AttackPlan(steps: List.of(acc), finalScore: score, isLethal: false);
      }

      final taunts = b.opponentMinions
          .where((m) => m.alive && m.has(Keyword.taunt) && !m.has(Keyword.stealth))
          .toList();

      for (var i = 0; i < b.playerMinions.length; i++) {
        final atk = b.playerMinions[i];
        if (!atk.alive || atk.attack <= 0 || !atk.canAttack) continue;

        // Targets: taunts force the set; else all attackable minions + face.
        final minionTargets = <int>[];
        for (var j = 0; j < b.opponentMinions.length; j++) {
          final t = b.opponentMinions[j];
          if (!t.alive || t.has(Keyword.stealth)) continue;
          if (taunts.isNotEmpty && !t.has(Keyword.taunt)) continue;
          minionTargets.add(j);
        }

        for (final j in minionTargets) {
          final sim = b.clone();
          final tLabel =
              '${sim.opponentMinions[j].name} (${sim.opponentMinions[j].attack}/${sim.opponentMinions[j].health})';
          final aLabel = '${atk.name} (${atk.attack}/${atk.health})';
          Combat.minionAttacksMinion(sim, sim.playerMinions[i], sim.opponentMinions[j]);
          search(sim, [
            ...acc,
            AttackStep(attackerLabel: aLabel, targetLabel: tLabel, toFace: false),
          ]);
        }

        // Face (only if no taunts and this minion may hit face).
        if (taunts.isEmpty && atk.canAttackFace) {
          final sim = b.clone();
          final aLabel = '${atk.name} (${atk.attack}/${atk.health})';
          Combat.minionAttacksHero(sim, sim.playerMinions[i]);
          search(sim, [
            ...acc,
            AttackStep(attackerLabel: aLabel, targetLabel: 'enemy hero', toFace: true),
          ]);
        }
      }
    }

    search(board, const []);
    return best;
  }
}
