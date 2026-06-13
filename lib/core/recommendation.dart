import 'package:freezed_annotation/freezed_annotation.dart';
import 'game_state.dart';

part 'recommendation.freezed.dart';

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
  }) =>
      Recommendation(
        type: ActionType.attack,
        score: score,
        reason: reason,
        title: 'Attack: $targetLabel',
        subtitle: '$attackerLabel → $targetLabel',
        isLethal: isLethal,
      );

  factory Recommendation.endTurn({required String reason}) => Recommendation(
        type: ActionType.endTurn,
        score: 0.0,
        reason: reason,
        title: 'End Turn',
      );
}

@freezed
class BgsRecommendation with _$BgsRecommendation {
  const factory BgsRecommendation({
    required BgsMinion minion,
    required double score,
    required String reason,
    @Default(false) bool shouldFreeze,
    @Default(false) bool shouldUpgradeTavern,
  }) = _BgsRecommendation;
}
