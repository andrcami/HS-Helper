import '../../core/game_state.dart';
import '../../core/recommendation.dart';
import '../../data/cache_manager.dart';

/// Battlegrounds shop-phase advisor. Recommends buy / sell / roll / upgrade /
/// freeze based on tier data (Firestone avg-placement → 1-6), tribal synergy,
/// triples, board strength, and a standard economy curve.
class BgsEngine {
  const BgsEngine({required this.cache});
  final CacheManager cache;

  // Gold cost to upgrade FROM the given tavern tier (index = current tier).
  static const _upgradeCost = [0, 5, 7, 8, 9, 11];

  List<BgsRecommendation> recommend(BgsState state) {
    if (!state.isShopPhase) return const [];

    final recs = <BgsRecommendation>[];

    // --- Buys -----------------------------------------------------------------
    for (final m in state.shop) {
      if (state.gold < 3) break;
      recs.add(BgsRecommendation.buy(
        m,
        score: _buyScore(m, state),
        reason: _buyReason(m, state),
      ));
    }

    // --- Tavern upgrade -------------------------------------------------------
    if (state.tavernTier < 6) {
      final cost = _upgradeCost[state.tavernTier];
      if (state.gold >= cost) {
        recs.add(BgsRecommendation.upgrade(
          score: _upgradeScore(state, cost),
          reason: _upgradeReason(state),
          cost: cost,
        ));
      }
    }

    // --- Sells (weak board minions when board is full / outclassed) ----------
    if (state.board.length >= 6) {
      final weakest = _weakest(state.board);
      if (weakest != null) {
        recs.add(BgsRecommendation.sell(
          weakest,
          score: 0.4,
          reason: 'Board full — make room for an upgrade',
        ));
      }
    }

    // --- Roll -----------------------------------------------------------------
    recs.add(BgsRecommendation.roll(
      score: _rollScore(state, recs),
      reason: _rollReason(state),
    ));

    // --- Freeze ---------------------------------------------------------------
    if (_shouldFreeze(state)) {
      recs.add(BgsRecommendation.freeze(
        score: 0.6,
        reason: 'Strong minions you can\'t afford yet — hold them',
      ));
    }

    recs.sort((a, b) => b.score.compareTo(a.score));
    return recs.take(4).toList();
  }

  // ---- Buy scoring -----------------------------------------------------------

  double _buyScore(BgsMinion m, BgsState state) {
    // Base tier value: tier 1 → ~0.4, tier 6 → ~1.0 (higher tier = stronger).
    final tierData = cache.tier(m.cardId);
    final tierRank = tierData?.tier ?? m.tier;
    double s = 0.35 + (6 - tierRank) * 0.0; // placeholder
    // Firestone tier here is "strength bucket" (1 best). Convert to value.
    s = (7 - tierRank) / 6.0; // tier1→1.0 ... tier6→0.17

    // Triple: 2 copies already on board + this = golden.
    final copies = state.board.where((b) => b.cardId == m.cardId).length;
    if (copies >= 2) s = (s * 1.6).clamp(0.0, 1.0);

    // Tribal synergy: rewards matching the tribe I'm already building.
    s *= _tribalMultiplier(m, state);

    // Golden already = big board presence.
    if (m.isGolden) s *= 1.2;

    // Raw stat tiebreak for same-tier minions.
    s += (m.attack + m.health) * 0.005;

    return s.clamp(0.0, 1.0);
  }

  double _tribalMultiplier(BgsMinion m, BgsState state) {
    if (m.types.isEmpty) return 1.0;
    final boardTribes = <String, int>{};
    for (final b in state.board) {
      for (final t in b.types) {
        boardTribes[t] = (boardTribes[t] ?? 0) + 1;
      }
    }
    final matches =
        m.types.fold<int>(0, (sum, t) => sum + (boardTribes[t] ?? 0));
    if (matches >= 3) return 1.3;
    if (matches >= 1) return 1.12;
    return 1.0;
  }

  String _buyReason(BgsMinion m, BgsState state) {
    final parts = <String>[];
    final copies = state.board.where((b) => b.cardId == m.cardId).length;
    if (copies >= 2) parts.add('completes TRIPLE');
    if (m.isGolden) parts.add('golden');
    final tier = cache.tier(m.cardId)?.tier ?? m.tier;
    parts.add('T$tier');
    if (m.types.isNotEmpty && _tribalMultiplier(m, state) > 1.0) {
      parts.add('${m.types.first} synergy');
    }
    return parts.join(' · ');
  }

  // ---- Tavern upgrade --------------------------------------------------------

  /// Standard curve: upgrade aggressively when healthy + early, hold when low
  /// HP or contested. Higher score = upgrade now.
  double _upgradeScore(BgsState state, int cost) {
    double s = 0.5;
    // Early game (turns ~1-5): leveling is usually correct.
    if (state.turn <= 5) s += 0.2;
    // Healthy → can afford to greed for tier.
    if (state.playerHp >= 30) s += 0.15;
    // Low HP → must stabilize board instead.
    if (state.playerHp <= 12) s -= 0.3;
    // Lots of spare gold beyond the cost → leftover would be wasted.
    final spare = state.gold - cost;
    if (spare >= 3) s += 0.1;
    // Weak shop → nothing worth buying anyway, level instead.
    final bestShopTier = state.shop
        .map((m) => cache.tier(m.cardId)?.tier ?? m.tier)
        .fold(6, (a, b) => a < b ? a : b);
    if (bestShopTier >= 4) s += 0.15;
    return s.clamp(0.0, 1.0);
  }

  String _upgradeReason(BgsState state) {
    if (state.playerHp <= 12) return 'Risky at ${state.playerHp} HP — but unlocks tier';
    if (state.turn <= 5) return 'Level early while healthy';
    return 'Push for stronger minions';
  }

  // ---- Roll ------------------------------------------------------------------

  double _rollScore(BgsState state, List<BgsRecommendation> existing) {
    // Roll value is the inverse of how good the current buys are: if a strong
    // buy exists, rolling is worse; if shop is junk + gold to spare, roll.
    final bestBuy = existing
        .where((r) => r.type == BgsActionType.buy)
        .fold<double>(0, (mx, r) => r.score > mx ? r.score : mx);
    double s = 0.45 - bestBuy * 0.5;
    if (state.gold <= 1) s = 0.0; // can't afford
    // Keep at least buy-money in mind: rolling at exactly enough gold to buy is
    // usually worse than buying.
    if (state.gold < 4 && bestBuy > 0.5) s -= 0.1;
    return s.clamp(0.0, 0.6);
  }

  String _rollReason(BgsState state) =>
      'Refresh for a better minion / tribe';

  // ---- Freeze / sell helpers -------------------------------------------------

  bool _shouldFreeze(BgsState state) {
    // Freeze if there are 2+ minions stronger than this tier that we can't buy
    // all of this turn (hold them for next turn's gold).
    final strong = state.shop
        .where((m) => (cache.tier(m.cardId)?.tier ?? m.tier) <= 2)
        .length;
    final affordable = state.gold ~/ 3;
    return strong >= 2 && strong > affordable;
  }

  BgsMinion? _weakest(List<BgsMinion> board) {
    if (board.isEmpty) return null;
    final sorted = [...board]
      ..sort((a, b) => (a.attack + a.health).compareTo(b.attack + b.health));
    return sorted.first;
  }
}
