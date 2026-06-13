// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CardInHandImpl _$$CardInHandImplFromJson(Map<String, dynamic> json) =>
    _$CardInHandImpl(
      cardId: json['cardId'] as String,
      name: json['name'] as String,
      cost: (json['cost'] as num).toInt(),
      type: $enumDecode(_$CardTypeEnumMap, json['type']),
      rarity: $enumDecode(_$RarityEnumMap, json['rarity']),
      attack: (json['attack'] as num?)?.toInt() ?? 0,
      health: (json['health'] as num?)?.toInt() ?? 0,
      text: json['text'] as String?,
      mechanics:
          (json['mechanics'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$CardInHandImplToJson(_$CardInHandImpl instance) =>
    <String, dynamic>{
      'cardId': instance.cardId,
      'name': instance.name,
      'cost': instance.cost,
      'type': _$CardTypeEnumMap[instance.type]!,
      'rarity': _$RarityEnumMap[instance.rarity]!,
      'attack': instance.attack,
      'health': instance.health,
      'text': instance.text,
      'mechanics': instance.mechanics,
    };

const _$CardTypeEnumMap = {
  CardType.minion: 'minion',
  CardType.spell: 'spell',
  CardType.weapon: 'weapon',
  CardType.hero: 'hero',
  CardType.heropower: 'heropower',
};

const _$RarityEnumMap = {
  Rarity.common: 'common',
  Rarity.rare: 'rare',
  Rarity.epic: 'epic',
  Rarity.legendary: 'legendary',
};

_$MinionOnBoardImpl _$$MinionOnBoardImplFromJson(Map<String, dynamic> json) =>
    _$MinionOnBoardImpl(
      cardId: json['cardId'] as String,
      name: json['name'] as String,
      attack: (json['attack'] as num).toInt(),
      health: (json['health'] as num).toInt(),
      isPlayerOwned: json['isPlayerOwned'] as bool,
      hasTaunt: json['hasTaunt'] as bool? ?? false,
      hasDivineShield: json['hasDivineShield'] as bool? ?? false,
      hasWindfury: json['hasWindfury'] as bool? ?? false,
      canAttack: json['canAttack'] as bool? ?? true,
      canAttackFace: json['canAttackFace'] as bool? ?? true,
      hasStealth: json['hasStealth'] as bool? ?? false,
    );

Map<String, dynamic> _$$MinionOnBoardImplToJson(_$MinionOnBoardImpl instance) =>
    <String, dynamic>{
      'cardId': instance.cardId,
      'name': instance.name,
      'attack': instance.attack,
      'health': instance.health,
      'isPlayerOwned': instance.isPlayerOwned,
      'hasTaunt': instance.hasTaunt,
      'hasDivineShield': instance.hasDivineShield,
      'hasWindfury': instance.hasWindfury,
      'canAttack': instance.canAttack,
      'canAttackFace': instance.canAttackFace,
      'hasStealth': instance.hasStealth,
    };

_$BoardImpl _$$BoardImplFromJson(Map<String, dynamic> json) => _$BoardImpl(
  playerMinions:
      (json['playerMinions'] as List<dynamic>?)
          ?.map((e) => MinionOnBoard.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  opponentMinions:
      (json['opponentMinions'] as List<dynamic>?)
          ?.map((e) => MinionOnBoard.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  opponentHp: (json['opponentHp'] as num?)?.toInt() ?? 0,
  playerHp: (json['playerHp'] as num?)?.toInt() ?? 30,
);

Map<String, dynamic> _$$BoardImplToJson(_$BoardImpl instance) =>
    <String, dynamic>{
      'playerMinions': instance.playerMinions,
      'opponentMinions': instance.opponentMinions,
      'opponentHp': instance.opponentHp,
      'playerHp': instance.playerHp,
    };

_$ConstructedStateImpl _$$ConstructedStateImplFromJson(
  Map<String, dynamic> json,
) => _$ConstructedStateImpl(
  playerClass: json['playerClass'] as String,
  format: $enumDecode(_$ConstructedFormatEnumMap, json['format']),
  hand: (json['hand'] as List<dynamic>)
      .map((e) => CardInHand.fromJson(e as Map<String, dynamic>))
      .toList(),
  board: Board.fromJson(json['board'] as Map<String, dynamic>),
  mana: (json['mana'] as num).toInt(),
  maxMana: (json['maxMana'] as num).toInt(),
  turn: (json['turn'] as num).toInt(),
  isPlayerTurn: json['isPlayerTurn'] as bool? ?? false,
  heroPowerAvailable: json['heroPowerAvailable'] as bool? ?? false,
  weaponAttack: (json['weaponAttack'] as num?)?.toInt() ?? 0,
  isMulligan: json['isMulligan'] as bool? ?? false,
  hasCoin: json['hasCoin'] as bool? ?? false,
);

Map<String, dynamic> _$$ConstructedStateImplToJson(
  _$ConstructedStateImpl instance,
) => <String, dynamic>{
  'playerClass': instance.playerClass,
  'format': _$ConstructedFormatEnumMap[instance.format]!,
  'hand': instance.hand,
  'board': instance.board,
  'mana': instance.mana,
  'maxMana': instance.maxMana,
  'turn': instance.turn,
  'isPlayerTurn': instance.isPlayerTurn,
  'heroPowerAvailable': instance.heroPowerAvailable,
  'weaponAttack': instance.weaponAttack,
  'isMulligan': instance.isMulligan,
  'hasCoin': instance.hasCoin,
};

const _$ConstructedFormatEnumMap = {
  ConstructedFormat.standard: 'standard',
  ConstructedFormat.wild: 'wild',
};

_$BgsMinionImpl _$$BgsMinionImplFromJson(Map<String, dynamic> json) =>
    _$BgsMinionImpl(
      cardId: json['cardId'] as String,
      name: json['name'] as String,
      attack: (json['attack'] as num).toInt(),
      health: (json['health'] as num).toInt(),
      tier: (json['tier'] as num).toInt(),
      isGolden: json['isGolden'] as bool? ?? false,
      types:
          (json['types'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
    );

Map<String, dynamic> _$$BgsMinionImplToJson(_$BgsMinionImpl instance) =>
    <String, dynamic>{
      'cardId': instance.cardId,
      'name': instance.name,
      'attack': instance.attack,
      'health': instance.health,
      'tier': instance.tier,
      'isGolden': instance.isGolden,
      'types': instance.types,
    };

_$BgsStateImpl _$$BgsStateImplFromJson(Map<String, dynamic> json) =>
    _$BgsStateImpl(
      tavernTier: (json['tavernTier'] as num).toInt(),
      gold: (json['gold'] as num).toInt(),
      maxGold: (json['maxGold'] as num).toInt(),
      shop: (json['shop'] as List<dynamic>)
          .map((e) => BgsMinion.fromJson(e as Map<String, dynamic>))
          .toList(),
      board: (json['board'] as List<dynamic>)
          .map((e) => BgsMinion.fromJson(e as Map<String, dynamic>))
          .toList(),
      turn: (json['turn'] as num).toInt(),
      isShopPhase: json['isShopPhase'] as bool? ?? false,
      playerHp: (json['playerHp'] as num?)?.toInt() ?? 40,
    );

Map<String, dynamic> _$$BgsStateImplToJson(_$BgsStateImpl instance) =>
    <String, dynamic>{
      'tavernTier': instance.tavernTier,
      'gold': instance.gold,
      'maxGold': instance.maxGold,
      'shop': instance.shop,
      'board': instance.board,
      'turn': instance.turn,
      'isShopPhase': instance.isShopPhase,
      'playerHp': instance.playerHp,
    };

_$ConstructedGameStateImpl _$$ConstructedGameStateImplFromJson(
  Map<String, dynamic> json,
) => _$ConstructedGameStateImpl(
  ConstructedState.fromJson(json['state'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$ConstructedGameStateImplToJson(
  _$ConstructedGameStateImpl instance,
) => <String, dynamic>{'state': instance.state, 'runtimeType': instance.$type};

_$BattlegroundsGameStateImpl _$$BattlegroundsGameStateImplFromJson(
  Map<String, dynamic> json,
) => _$BattlegroundsGameStateImpl(
  BgsState.fromJson(json['state'] as Map<String, dynamic>),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$$BattlegroundsGameStateImplToJson(
  _$BattlegroundsGameStateImpl instance,
) => <String, dynamic>{'state': instance.state, 'runtimeType': instance.$type};

_$IdleGameStateImpl _$$IdleGameStateImplFromJson(Map<String, dynamic> json) =>
    _$IdleGameStateImpl($type: json['runtimeType'] as String?);

Map<String, dynamic> _$$IdleGameStateImplToJson(_$IdleGameStateImpl instance) =>
    <String, dynamic>{'runtimeType': instance.$type};
