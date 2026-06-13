import 'sim_models.dart';

/// Heuristic value of a board from the local player's perspective.
/// Higher = better for me. Used to compare the outcomes of candidate actions.
class BoardEval {
  /// Per-keyword bonus added to a minion's material value.
  static double _keywordValue(SimMinion m) {
    double v = 0;
    if (m.has(Keyword.taunt)) v += 1.0;
    if (m.has(Keyword.divineShield)) v += 1.5;
    if (m.has(Keyword.lifesteal)) v += 0.8;
    if (m.has(Keyword.poisonous)) v += 1.5;
    if (m.has(Keyword.windfury)) v += m.attack * 0.5;
    if (m.has(Keyword.reborn)) v += 1.2;
    if (m.has(Keyword.deathrattle)) v += 0.5; // unknown effect — small hedge
    if (m.has(Keyword.stealth)) v += 0.3;
    return v;
  }

  /// Material value of one minion: stats + keyword bonuses.
  static double minionValue(SimMinion m) {
    if (!m.alive) return 0;
    // attack + health with a mild premium on health (sticky board).
    return m.attack + m.health * 1.1 + _keywordValue(m);
  }

  static double sideValue(List<SimMinion> minions) =>
      minions.fold<double>(0, (sum, m) => sum + minionValue(m));

  /// Total board score from my perspective. Positive = I'm ahead.
  static double score(SimBoard b) {
    final myBoard = sideValue(b.playerMinions);
    final oppBoard = sideValue(b.opponentMinions);

    // Face/health matters: pushing opponent toward 0 is good; losing my own HP
    // is bad. Weight enemy HP loss higher when they're low (closing the game).
    final oppHpPenalty = b.opponentHp * 0.6;
    final myHpBonus = (b.playerHp + b.playerArmor) * 0.4;

    // Winning/losing terminal states dominate.
    if (b.opponentHp <= 0) return 100000;
    if (b.playerHp <= 0) return -100000;

    return (myBoard - oppBoard) + myHpBonus - oppHpPenalty;
  }

  /// Convenience: net swing of an action = score(after) - score(before).
  static double swing(SimBoard before, SimBoard after) =>
      score(after) - score(before);
}
