import 'sim_models.dart';

/// Resolves keyword-driven combat on a SimBoard. Pure functions — operate on a
/// cloned board and return the result, so the engine can try many actions.
class Combat {
  /// A minion attacks a target minion. Mutates [board] in place.
  /// Handles divine shield, poisonous, lifesteal, windfury, freeze, reborn.
  static void minionAttacksMinion(
    SimBoard board,
    SimMinion attacker,
    SimMinion target,
  ) {
    if (!attacker.canAttack || !attacker.alive || !target.alive) return;

    _dealCombatDamage(board, from: attacker, to: target);
    _dealCombatDamage(board, from: target, to: attacker); // retaliation

    // Windfury minions can attack twice; mark single attack used otherwise.
    if (!attacker.has(Keyword.windfury)) {
      attacker.canAttack = false;
    }

    _cleanup(board);
  }

  /// A minion attacks the enemy hero. Returns damage dealt to face.
  static int minionAttacksHero(SimBoard board, SimMinion attacker) {
    if (!attacker.canAttack || !attacker.alive) return 0;
    final dmg = attacker.attack;
    if (attacker.isPlayerOwned) {
      board.opponentHp = _applyHeroDamage(board.opponentHp, dmg,
          armorRef: () => board.opponentArmor,
          setArmor: (v) => board.opponentArmor = v);
    } else {
      board.playerHp = _applyHeroDamage(board.playerHp, dmg,
          armorRef: () => board.playerArmor,
          setArmor: (v) => board.playerArmor = v);
    }
    if (attacker.has(Keyword.lifesteal)) {
      _heal(board, attacker.isPlayerOwned, dmg);
    }
    if (!attacker.has(Keyword.windfury)) attacker.canAttack = false;
    return dmg;
  }

  static void _dealCombatDamage(
    SimBoard board, {
    required SimMinion from,
    required SimMinion to,
  }) {
    if (from.attack <= 0) return;
    if (to.has(Keyword.divineShield)) {
      // Shield pops, no damage.
      to.keywords.remove(Keyword.divineShield);
      return;
    }
    // Poisonous: any damage destroys (unless 0). Else normal damage.
    if (from.has(Keyword.poisonous) && from.attack > 0) {
      to.health = 0;
    } else {
      to.health -= from.attack;
    }
    if (from.has(Keyword.lifesteal)) {
      _heal(board, from.isPlayerOwned, from.attack);
    }
  }

  static void _cleanup(SimBoard board) {
    // Reborn: a dying minion returns once with 1 health.
    for (final side in [board.playerMinions, board.opponentMinions]) {
      for (var i = 0; i < side.length; i++) {
        final m = side[i];
        if (!m.alive && m.has(Keyword.reborn)) {
          m.keywords.remove(Keyword.reborn);
          m.health = 1;
        }
      }
    }
    board.removeDead();
  }

  static int _applyHeroDamage(
    int hp,
    int dmg, {
    required int Function() armorRef,
    required void Function(int) setArmor,
  }) {
    var remaining = dmg;
    final armor = armorRef();
    if (armor > 0) {
      final absorbed = armor >= remaining ? remaining : armor;
      setArmor(armor - absorbed);
      remaining -= absorbed;
    }
    return hp - remaining;
  }

  static void _heal(SimBoard board, bool player, int amount) {
    if (player) {
      board.playerHp = (board.playerHp + amount).clamp(0, 30);
    } else {
      board.opponentHp = (board.opponentHp + amount).clamp(0, 30);
    }
  }
}
