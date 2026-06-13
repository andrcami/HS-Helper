import 'game_state.dart';

/// The kind of turn action being recommended.
enum ActionType { playCard, heroPower, attack, endTurn }

/// A ranked next-step recommendation. Covers all turn actions, not just cards.
class Recommendation {
  const Recommendation({
    required this.type,
    required this.score,
    required this.reason,
    required this.title,
    this.card,
    this.subtitle = '',
    this.isLethal = false,
    this.planSteps = const [],
  });

  final ActionType type;
  final double score;
  final String reason;

  /// Primary label, e.g. card name, "Hero Power", "Attack face", "End turn".
  final String title;

  /// Optional detail line, e.g. "Wisp (1/1) → enemy hero".
  final String subtitle;

  /// Present only for playCard actions.
  final CardInHand? card;

  final bool isLethal;

  /// For attack recommendations from the planner: the full planned attack line
  /// (each "Attacker → Target"). Empty for single-step / non-attack actions.
  final List<String> planSteps;

  // Convenience constructors.
  factory Recommendation.playCard(
    CardInHand card, {
    required double score,
    required String reason,
    bool isLethal = false,
  }) =>
      Recommendation(
        type: ActionType.playCard,
        score: score,
        reason: reason,
        title: card.name,
        subtitle: '${card.cost} mana',
        card: card,
        isLethal: isLethal,
      );

  factory Recommendation.heroPower({
    required double score,
    required String reason,
  }) =>
      Recommendation(
        type: ActionType.heroPower,
        score: score,
        reason: reason,
        title: 'Hero Power',
        subtitle: '2 mana',
      );

  factory Recommendation.attack({
    required double score,
    required String reason,
    required String attackerLabel,
    required String targetLabel,
    bool isLethal = false,
    List<String> planSteps = const [],
  }) =>
      Recommendation(
        type: ActionType.attack,
        score: score,
        reason: reason,
        title: 'Attack: $targetLabel',
        subtitle: '$attackerLabel → $targetLabel',
        isLethal: isLethal,
        planSteps: planSteps,
      );

  factory Recommendation.endTurn({required String reason}) => Recommendation(
        type: ActionType.endTurn,
        score: 0.0,
        reason: reason,
        title: 'End Turn',
      );
}

/// BGS shop-phase action types.
enum BgsActionType { buy, sell, roll, upgradeTavern, freeze, heroPower, endTurn }

/// A ranked BGS shop recommendation. Covers all shop actions, not just buying.
class BgsRecommendation {
  const BgsRecommendation({
    required this.type,
    required this.score,
    required this.reason,
    required this.title,
    this.minion,
    this.subtitle = '',
  });

  final BgsActionType type;
  final double score;
  final String reason;
  final String title;
  final String subtitle;

  /// Present for buy/sell (the minion in question).
  final BgsMinion? minion;

  factory BgsRecommendation.buy(
    BgsMinion m, {
    required double score,
    required String reason,
  }) =>
      BgsRecommendation(
        type: BgsActionType.buy,
        score: score,
        reason: reason,
        title: 'Buy ${m.name}',
        subtitle: 'T${m.tier} · ${m.attack}/${m.health}'
            '${m.isGolden ? ' · golden' : ''}',
        minion: m,
      );

  factory BgsRecommendation.sell(
    BgsMinion m, {
    required double score,
    required String reason,
  }) =>
      BgsRecommendation(
        type: BgsActionType.sell,
        score: score,
        reason: reason,
        title: 'Sell ${m.name}',
        subtitle: '${m.attack}/${m.health}',
        minion: m,
      );

  factory BgsRecommendation.roll({required double score, required String reason}) =>
      BgsRecommendation(
        type: BgsActionType.roll,
        score: score,
        reason: reason,
        title: 'Roll (refresh shop)',
        subtitle: '1 gold',
      );

  factory BgsRecommendation.upgrade(
          {required double score, required String reason, required int cost}) =>
      BgsRecommendation(
        type: BgsActionType.upgradeTavern,
        score: score,
        reason: reason,
        title: 'Upgrade Tavern',
        subtitle: '$cost gold',
      );

  factory BgsRecommendation.freeze({required double score, required String reason}) =>
      BgsRecommendation(
        type: BgsActionType.freeze,
        score: score,
        reason: reason,
        title: 'Freeze shop',
      );
}
