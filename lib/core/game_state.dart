import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_state.freezed.dart';
part 'game_state.g.dart';

enum GameMode { constructed, battlegrounds }
enum ConstructedFormat { standard, wild }
enum Zone { hand, board, graveyard, deck }
enum CardType { minion, spell, weapon, hero, heropower }
enum Rarity { common, rare, epic, legendary }

@freezed
class CardInHand with _$CardInHand {
  const factory CardInHand({
    required String cardId,
    required String name,
    required int cost,
    required CardType type,
    required Rarity rarity,
    @Default(0) int attack,
    @Default(0) int health,
    String? text,
    @Default([]) List<String> mechanics,
  }) = _CardInHand;

  factory CardInHand.fromJson(Map<String, dynamic> json) =>
      _$CardInHandFromJson(json);
}

@freezed
class MinionOnBoard with _$MinionOnBoard {
  const factory MinionOnBoard({
    required String cardId,
    required String name,
    required int attack,
    required int health,
    required bool isPlayerOwned,
    @Default(false) bool hasTaunt,
    @Default(false) bool hasDivineShield,
    @Default(false) bool hasWindfury,
  }) = _MinionOnBoard;

  factory MinionOnBoard.fromJson(Map<String, dynamic> json) =>
      _$MinionOnBoardFromJson(json);
}

@freezed
class Board with _$Board {
  const factory Board({
    @Default([]) List<MinionOnBoard> playerMinions,
    @Default([]) List<MinionOnBoard> opponentMinions,
    @Default(0) int opponentHp,
    @Default(30) int playerHp,
  }) = _Board;

  factory Board.fromJson(Map<String, dynamic> json) => _$BoardFromJson(json);
}

@freezed
class ConstructedState with _$ConstructedState {
  const factory ConstructedState({
    required String playerClass,
    required ConstructedFormat format,
    required List<CardInHand> hand,
    required Board board,
    required int mana,
    required int maxMana,
    required int turn,
    @Default(false) bool isPlayerTurn,
    @Default(false) bool heroPowerAvailable,
    @Default(0) int weaponAttack, // player's equipped weapon attack (0 = none)
  }) = _ConstructedState;

  factory ConstructedState.fromJson(Map<String, dynamic> json) =>
      _$ConstructedStateFromJson(json);
}

@freezed
class BgsMinion with _$BgsMinion {
  const factory BgsMinion({
    required String cardId,
    required String name,
    required int attack,
    required int health,
    required int tier,
    @Default(false) bool isGolden,
    @Default([]) List<String> types,
  }) = _BgsMinion;

  factory BgsMinion.fromJson(Map<String, dynamic> json) =>
      _$BgsMinionFromJson(json);
}

@freezed
class BgsState with _$BgsState {
  const factory BgsState({
    required int tavernTier,
    required int gold,
    required int maxGold,
    required List<BgsMinion> shop,
    required List<BgsMinion> board,
    required int turn,
    @Default(false) bool isShopPhase,
    @Default(40) int playerHp,
  }) = _BgsState;

  factory BgsState.fromJson(Map<String, dynamic> json) =>
      _$BgsStateFromJson(json);
}

@freezed
class GameState with _$GameState {
  const factory GameState.constructed(ConstructedState state) = ConstructedGameState;
  const factory GameState.battlegrounds(BgsState state) = BattlegroundsGameState;
  const factory GameState.idle() = IdleGameState;

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);
}
