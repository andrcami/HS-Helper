import '../../core/game_state.dart';
import '../../core/recommendation.dart';
import '../../data/cache_manager.dart';

class BgsEngine {
  const BgsEngine({required this.cache});

  final CacheManager cache;

  static const _tavernUpgradeCost = [0, 5, 7, 8, 9, 10];

  List<BgsRecommendation> recommend(BgsState state) {
    if (!state.isShopPhase) return [];

    final recs = <BgsRecommendation>[];
    final canAffordUpgrade = state.tavernTier < 6 &&
        state.gold >= _tavernUpgradeCost[state.tavernTier];
    final shouldUpgrade = _shouldUpgradeTavern(state);

    for (final minion in state.shop) {
      if (state.gold < 3) break; // can't buy

      final tier = cache.tier(minion.cardId);
      final tierScore = tier != null
          ? (6 - tier.tier) / 5.0 // tier 1 → 1.0, tier 6 → 0.0
          : 0.5;

      // Triple bonus: 2 of same already on board
      final boardCount = state.board.where((m) => m.cardId == minion.cardId).length;
      final tripleMultiplier = boardCount >= 2 ? 1.5 : 1.0;

      final score = (tierScore * tripleMultiplier).clamp(0.0, 1.0);

      final parts = <String>[];
      if (tier != null) parts.add('T${tier.tier} minion');
      if (boardCount >= 2) parts.add('completes triple');
      if (minion.isGolden) parts.add('golden');

      recs.add(BgsRecommendation(
        minion: minion,
        score: score,
        reason: parts.isEmpty ? 'Shop minion' : parts.join(', '),
        shouldFreeze: _shouldFreeze(state),
        shouldUpgradeTavern: shouldUpgrade && canAffordUpgrade,
      ));
    }

    recs.sort((a, b) => b.score.compareTo(a.score));
    return recs.take(3).toList();
  }

  bool _shouldUpgradeTavern(BgsState state) {
    if (state.tavernTier >= 6) return false;
    final cost = _tavernUpgradeCost[state.tavernTier];
    if (state.gold < cost) return false;
    // Upgrade if top shop minions are all tier 3 or lower score
    final topShopScore = state.shop
        .map((m) => cache.tier(m.cardId)?.tier ?? 4)
        .fold(6, (a, b) => a < b ? a : b);
    return topShopScore >= 4; // shop weak — better to upgrade
  }

  bool _shouldFreeze(BgsState state) {
    // Freeze if 3+ high-value minions unsold
    final highValue = state.shop
        .where((m) => (cache.tier(m.cardId)?.tier ?? 6) <= 2)
        .length;
    return highValue >= 3;
  }
}
