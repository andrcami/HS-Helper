// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CardInHand _$CardInHandFromJson(Map<String, dynamic> json) {
  return _CardInHand.fromJson(json);
}

/// @nodoc
mixin _$CardInHand {
  String get cardId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get cost => throw _privateConstructorUsedError;
  CardType get type => throw _privateConstructorUsedError;
  Rarity get rarity => throw _privateConstructorUsedError;
  int get attack => throw _privateConstructorUsedError;
  int get health => throw _privateConstructorUsedError;
  String? get text => throw _privateConstructorUsedError;
  List<String> get mechanics => throw _privateConstructorUsedError;

  /// Serializes this CardInHand to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CardInHand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CardInHandCopyWith<CardInHand> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CardInHandCopyWith<$Res> {
  factory $CardInHandCopyWith(
    CardInHand value,
    $Res Function(CardInHand) then,
  ) = _$CardInHandCopyWithImpl<$Res, CardInHand>;
  @useResult
  $Res call({
    String cardId,
    String name,
    int cost,
    CardType type,
    Rarity rarity,
    int attack,
    int health,
    String? text,
    List<String> mechanics,
  });
}

/// @nodoc
class _$CardInHandCopyWithImpl<$Res, $Val extends CardInHand>
    implements $CardInHandCopyWith<$Res> {
  _$CardInHandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CardInHand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cardId = null,
    Object? name = null,
    Object? cost = null,
    Object? type = null,
    Object? rarity = null,
    Object? attack = null,
    Object? health = null,
    Object? text = freezed,
    Object? mechanics = null,
  }) {
    return _then(
      _value.copyWith(
            cardId: null == cardId
                ? _value.cardId
                : cardId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            cost: null == cost
                ? _value.cost
                : cost // ignore: cast_nullable_to_non_nullable
                      as int,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as CardType,
            rarity: null == rarity
                ? _value.rarity
                : rarity // ignore: cast_nullable_to_non_nullable
                      as Rarity,
            attack: null == attack
                ? _value.attack
                : attack // ignore: cast_nullable_to_non_nullable
                      as int,
            health: null == health
                ? _value.health
                : health // ignore: cast_nullable_to_non_nullable
                      as int,
            text: freezed == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String?,
            mechanics: null == mechanics
                ? _value.mechanics
                : mechanics // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CardInHandImplCopyWith<$Res>
    implements $CardInHandCopyWith<$Res> {
  factory _$$CardInHandImplCopyWith(
    _$CardInHandImpl value,
    $Res Function(_$CardInHandImpl) then,
  ) = __$$CardInHandImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String cardId,
    String name,
    int cost,
    CardType type,
    Rarity rarity,
    int attack,
    int health,
    String? text,
    List<String> mechanics,
  });
}

/// @nodoc
class __$$CardInHandImplCopyWithImpl<$Res>
    extends _$CardInHandCopyWithImpl<$Res, _$CardInHandImpl>
    implements _$$CardInHandImplCopyWith<$Res> {
  __$$CardInHandImplCopyWithImpl(
    _$CardInHandImpl _value,
    $Res Function(_$CardInHandImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CardInHand
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cardId = null,
    Object? name = null,
    Object? cost = null,
    Object? type = null,
    Object? rarity = null,
    Object? attack = null,
    Object? health = null,
    Object? text = freezed,
    Object? mechanics = null,
  }) {
    return _then(
      _$CardInHandImpl(
        cardId: null == cardId
            ? _value.cardId
            : cardId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        cost: null == cost
            ? _value.cost
            : cost // ignore: cast_nullable_to_non_nullable
                  as int,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as CardType,
        rarity: null == rarity
            ? _value.rarity
            : rarity // ignore: cast_nullable_to_non_nullable
                  as Rarity,
        attack: null == attack
            ? _value.attack
            : attack // ignore: cast_nullable_to_non_nullable
                  as int,
        health: null == health
            ? _value.health
            : health // ignore: cast_nullable_to_non_nullable
                  as int,
        text: freezed == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String?,
        mechanics: null == mechanics
            ? _value._mechanics
            : mechanics // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CardInHandImpl implements _CardInHand {
  const _$CardInHandImpl({
    required this.cardId,
    required this.name,
    required this.cost,
    required this.type,
    required this.rarity,
    this.attack = 0,
    this.health = 0,
    this.text,
    final List<String> mechanics = const [],
  }) : _mechanics = mechanics;

  factory _$CardInHandImpl.fromJson(Map<String, dynamic> json) =>
      _$$CardInHandImplFromJson(json);

  @override
  final String cardId;
  @override
  final String name;
  @override
  final int cost;
  @override
  final CardType type;
  @override
  final Rarity rarity;
  @override
  @JsonKey()
  final int attack;
  @override
  @JsonKey()
  final int health;
  @override
  final String? text;
  final List<String> _mechanics;
  @override
  @JsonKey()
  List<String> get mechanics {
    if (_mechanics is EqualUnmodifiableListView) return _mechanics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mechanics);
  }

  @override
  String toString() {
    return 'CardInHand(cardId: $cardId, name: $name, cost: $cost, type: $type, rarity: $rarity, attack: $attack, health: $health, text: $text, mechanics: $mechanics)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CardInHandImpl &&
            (identical(other.cardId, cardId) || other.cardId == cardId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.cost, cost) || other.cost == cost) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.rarity, rarity) || other.rarity == rarity) &&
            (identical(other.attack, attack) || other.attack == attack) &&
            (identical(other.health, health) || other.health == health) &&
            (identical(other.text, text) || other.text == text) &&
            const DeepCollectionEquality().equals(
              other._mechanics,
              _mechanics,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    cardId,
    name,
    cost,
    type,
    rarity,
    attack,
    health,
    text,
    const DeepCollectionEquality().hash(_mechanics),
  );

  /// Create a copy of CardInHand
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CardInHandImplCopyWith<_$CardInHandImpl> get copyWith =>
      __$$CardInHandImplCopyWithImpl<_$CardInHandImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CardInHandImplToJson(this);
  }
}

abstract class _CardInHand implements CardInHand {
  const factory _CardInHand({
    required final String cardId,
    required final String name,
    required final int cost,
    required final CardType type,
    required final Rarity rarity,
    final int attack,
    final int health,
    final String? text,
    final List<String> mechanics,
  }) = _$CardInHandImpl;

  factory _CardInHand.fromJson(Map<String, dynamic> json) =
      _$CardInHandImpl.fromJson;

  @override
  String get cardId;
  @override
  String get name;
  @override
  int get cost;
  @override
  CardType get type;
  @override
  Rarity get rarity;
  @override
  int get attack;
  @override
  int get health;
  @override
  String? get text;
  @override
  List<String> get mechanics;

  /// Create a copy of CardInHand
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CardInHandImplCopyWith<_$CardInHandImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MinionOnBoard _$MinionOnBoardFromJson(Map<String, dynamic> json) {
  return _MinionOnBoard.fromJson(json);
}

/// @nodoc
mixin _$MinionOnBoard {
  String get cardId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get attack => throw _privateConstructorUsedError;
  int get health => throw _privateConstructorUsedError;
  bool get isPlayerOwned => throw _privateConstructorUsedError;
  bool get hasTaunt => throw _privateConstructorUsedError;
  bool get hasDivineShield => throw _privateConstructorUsedError;
  bool get hasWindfury => throw _privateConstructorUsedError;

  /// Serializes this MinionOnBoard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MinionOnBoard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MinionOnBoardCopyWith<MinionOnBoard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MinionOnBoardCopyWith<$Res> {
  factory $MinionOnBoardCopyWith(
    MinionOnBoard value,
    $Res Function(MinionOnBoard) then,
  ) = _$MinionOnBoardCopyWithImpl<$Res, MinionOnBoard>;
  @useResult
  $Res call({
    String cardId,
    String name,
    int attack,
    int health,
    bool isPlayerOwned,
    bool hasTaunt,
    bool hasDivineShield,
    bool hasWindfury,
  });
}

/// @nodoc
class _$MinionOnBoardCopyWithImpl<$Res, $Val extends MinionOnBoard>
    implements $MinionOnBoardCopyWith<$Res> {
  _$MinionOnBoardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MinionOnBoard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cardId = null,
    Object? name = null,
    Object? attack = null,
    Object? health = null,
    Object? isPlayerOwned = null,
    Object? hasTaunt = null,
    Object? hasDivineShield = null,
    Object? hasWindfury = null,
  }) {
    return _then(
      _value.copyWith(
            cardId: null == cardId
                ? _value.cardId
                : cardId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            attack: null == attack
                ? _value.attack
                : attack // ignore: cast_nullable_to_non_nullable
                      as int,
            health: null == health
                ? _value.health
                : health // ignore: cast_nullable_to_non_nullable
                      as int,
            isPlayerOwned: null == isPlayerOwned
                ? _value.isPlayerOwned
                : isPlayerOwned // ignore: cast_nullable_to_non_nullable
                      as bool,
            hasTaunt: null == hasTaunt
                ? _value.hasTaunt
                : hasTaunt // ignore: cast_nullable_to_non_nullable
                      as bool,
            hasDivineShield: null == hasDivineShield
                ? _value.hasDivineShield
                : hasDivineShield // ignore: cast_nullable_to_non_nullable
                      as bool,
            hasWindfury: null == hasWindfury
                ? _value.hasWindfury
                : hasWindfury // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MinionOnBoardImplCopyWith<$Res>
    implements $MinionOnBoardCopyWith<$Res> {
  factory _$$MinionOnBoardImplCopyWith(
    _$MinionOnBoardImpl value,
    $Res Function(_$MinionOnBoardImpl) then,
  ) = __$$MinionOnBoardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String cardId,
    String name,
    int attack,
    int health,
    bool isPlayerOwned,
    bool hasTaunt,
    bool hasDivineShield,
    bool hasWindfury,
  });
}

/// @nodoc
class __$$MinionOnBoardImplCopyWithImpl<$Res>
    extends _$MinionOnBoardCopyWithImpl<$Res, _$MinionOnBoardImpl>
    implements _$$MinionOnBoardImplCopyWith<$Res> {
  __$$MinionOnBoardImplCopyWithImpl(
    _$MinionOnBoardImpl _value,
    $Res Function(_$MinionOnBoardImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MinionOnBoard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cardId = null,
    Object? name = null,
    Object? attack = null,
    Object? health = null,
    Object? isPlayerOwned = null,
    Object? hasTaunt = null,
    Object? hasDivineShield = null,
    Object? hasWindfury = null,
  }) {
    return _then(
      _$MinionOnBoardImpl(
        cardId: null == cardId
            ? _value.cardId
            : cardId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        attack: null == attack
            ? _value.attack
            : attack // ignore: cast_nullable_to_non_nullable
                  as int,
        health: null == health
            ? _value.health
            : health // ignore: cast_nullable_to_non_nullable
                  as int,
        isPlayerOwned: null == isPlayerOwned
            ? _value.isPlayerOwned
            : isPlayerOwned // ignore: cast_nullable_to_non_nullable
                  as bool,
        hasTaunt: null == hasTaunt
            ? _value.hasTaunt
            : hasTaunt // ignore: cast_nullable_to_non_nullable
                  as bool,
        hasDivineShield: null == hasDivineShield
            ? _value.hasDivineShield
            : hasDivineShield // ignore: cast_nullable_to_non_nullable
                  as bool,
        hasWindfury: null == hasWindfury
            ? _value.hasWindfury
            : hasWindfury // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MinionOnBoardImpl implements _MinionOnBoard {
  const _$MinionOnBoardImpl({
    required this.cardId,
    required this.name,
    required this.attack,
    required this.health,
    required this.isPlayerOwned,
    this.hasTaunt = false,
    this.hasDivineShield = false,
    this.hasWindfury = false,
  });

  factory _$MinionOnBoardImpl.fromJson(Map<String, dynamic> json) =>
      _$$MinionOnBoardImplFromJson(json);

  @override
  final String cardId;
  @override
  final String name;
  @override
  final int attack;
  @override
  final int health;
  @override
  final bool isPlayerOwned;
  @override
  @JsonKey()
  final bool hasTaunt;
  @override
  @JsonKey()
  final bool hasDivineShield;
  @override
  @JsonKey()
  final bool hasWindfury;

  @override
  String toString() {
    return 'MinionOnBoard(cardId: $cardId, name: $name, attack: $attack, health: $health, isPlayerOwned: $isPlayerOwned, hasTaunt: $hasTaunt, hasDivineShield: $hasDivineShield, hasWindfury: $hasWindfury)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MinionOnBoardImpl &&
            (identical(other.cardId, cardId) || other.cardId == cardId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.attack, attack) || other.attack == attack) &&
            (identical(other.health, health) || other.health == health) &&
            (identical(other.isPlayerOwned, isPlayerOwned) ||
                other.isPlayerOwned == isPlayerOwned) &&
            (identical(other.hasTaunt, hasTaunt) ||
                other.hasTaunt == hasTaunt) &&
            (identical(other.hasDivineShield, hasDivineShield) ||
                other.hasDivineShield == hasDivineShield) &&
            (identical(other.hasWindfury, hasWindfury) ||
                other.hasWindfury == hasWindfury));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    cardId,
    name,
    attack,
    health,
    isPlayerOwned,
    hasTaunt,
    hasDivineShield,
    hasWindfury,
  );

  /// Create a copy of MinionOnBoard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MinionOnBoardImplCopyWith<_$MinionOnBoardImpl> get copyWith =>
      __$$MinionOnBoardImplCopyWithImpl<_$MinionOnBoardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MinionOnBoardImplToJson(this);
  }
}

abstract class _MinionOnBoard implements MinionOnBoard {
  const factory _MinionOnBoard({
    required final String cardId,
    required final String name,
    required final int attack,
    required final int health,
    required final bool isPlayerOwned,
    final bool hasTaunt,
    final bool hasDivineShield,
    final bool hasWindfury,
  }) = _$MinionOnBoardImpl;

  factory _MinionOnBoard.fromJson(Map<String, dynamic> json) =
      _$MinionOnBoardImpl.fromJson;

  @override
  String get cardId;
  @override
  String get name;
  @override
  int get attack;
  @override
  int get health;
  @override
  bool get isPlayerOwned;
  @override
  bool get hasTaunt;
  @override
  bool get hasDivineShield;
  @override
  bool get hasWindfury;

  /// Create a copy of MinionOnBoard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MinionOnBoardImplCopyWith<_$MinionOnBoardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Board _$BoardFromJson(Map<String, dynamic> json) {
  return _Board.fromJson(json);
}

/// @nodoc
mixin _$Board {
  List<MinionOnBoard> get playerMinions => throw _privateConstructorUsedError;
  List<MinionOnBoard> get opponentMinions => throw _privateConstructorUsedError;
  int get opponentHp => throw _privateConstructorUsedError;
  int get playerHp => throw _privateConstructorUsedError;

  /// Serializes this Board to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Board
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BoardCopyWith<Board> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BoardCopyWith<$Res> {
  factory $BoardCopyWith(Board value, $Res Function(Board) then) =
      _$BoardCopyWithImpl<$Res, Board>;
  @useResult
  $Res call({
    List<MinionOnBoard> playerMinions,
    List<MinionOnBoard> opponentMinions,
    int opponentHp,
    int playerHp,
  });
}

/// @nodoc
class _$BoardCopyWithImpl<$Res, $Val extends Board>
    implements $BoardCopyWith<$Res> {
  _$BoardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Board
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerMinions = null,
    Object? opponentMinions = null,
    Object? opponentHp = null,
    Object? playerHp = null,
  }) {
    return _then(
      _value.copyWith(
            playerMinions: null == playerMinions
                ? _value.playerMinions
                : playerMinions // ignore: cast_nullable_to_non_nullable
                      as List<MinionOnBoard>,
            opponentMinions: null == opponentMinions
                ? _value.opponentMinions
                : opponentMinions // ignore: cast_nullable_to_non_nullable
                      as List<MinionOnBoard>,
            opponentHp: null == opponentHp
                ? _value.opponentHp
                : opponentHp // ignore: cast_nullable_to_non_nullable
                      as int,
            playerHp: null == playerHp
                ? _value.playerHp
                : playerHp // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BoardImplCopyWith<$Res> implements $BoardCopyWith<$Res> {
  factory _$$BoardImplCopyWith(
    _$BoardImpl value,
    $Res Function(_$BoardImpl) then,
  ) = __$$BoardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<MinionOnBoard> playerMinions,
    List<MinionOnBoard> opponentMinions,
    int opponentHp,
    int playerHp,
  });
}

/// @nodoc
class __$$BoardImplCopyWithImpl<$Res>
    extends _$BoardCopyWithImpl<$Res, _$BoardImpl>
    implements _$$BoardImplCopyWith<$Res> {
  __$$BoardImplCopyWithImpl(
    _$BoardImpl _value,
    $Res Function(_$BoardImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Board
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerMinions = null,
    Object? opponentMinions = null,
    Object? opponentHp = null,
    Object? playerHp = null,
  }) {
    return _then(
      _$BoardImpl(
        playerMinions: null == playerMinions
            ? _value._playerMinions
            : playerMinions // ignore: cast_nullable_to_non_nullable
                  as List<MinionOnBoard>,
        opponentMinions: null == opponentMinions
            ? _value._opponentMinions
            : opponentMinions // ignore: cast_nullable_to_non_nullable
                  as List<MinionOnBoard>,
        opponentHp: null == opponentHp
            ? _value.opponentHp
            : opponentHp // ignore: cast_nullable_to_non_nullable
                  as int,
        playerHp: null == playerHp
            ? _value.playerHp
            : playerHp // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BoardImpl implements _Board {
  const _$BoardImpl({
    final List<MinionOnBoard> playerMinions = const [],
    final List<MinionOnBoard> opponentMinions = const [],
    this.opponentHp = 0,
    this.playerHp = 30,
  }) : _playerMinions = playerMinions,
       _opponentMinions = opponentMinions;

  factory _$BoardImpl.fromJson(Map<String, dynamic> json) =>
      _$$BoardImplFromJson(json);

  final List<MinionOnBoard> _playerMinions;
  @override
  @JsonKey()
  List<MinionOnBoard> get playerMinions {
    if (_playerMinions is EqualUnmodifiableListView) return _playerMinions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_playerMinions);
  }

  final List<MinionOnBoard> _opponentMinions;
  @override
  @JsonKey()
  List<MinionOnBoard> get opponentMinions {
    if (_opponentMinions is EqualUnmodifiableListView) return _opponentMinions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_opponentMinions);
  }

  @override
  @JsonKey()
  final int opponentHp;
  @override
  @JsonKey()
  final int playerHp;

  @override
  String toString() {
    return 'Board(playerMinions: $playerMinions, opponentMinions: $opponentMinions, opponentHp: $opponentHp, playerHp: $playerHp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BoardImpl &&
            const DeepCollectionEquality().equals(
              other._playerMinions,
              _playerMinions,
            ) &&
            const DeepCollectionEquality().equals(
              other._opponentMinions,
              _opponentMinions,
            ) &&
            (identical(other.opponentHp, opponentHp) ||
                other.opponentHp == opponentHp) &&
            (identical(other.playerHp, playerHp) ||
                other.playerHp == playerHp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_playerMinions),
    const DeepCollectionEquality().hash(_opponentMinions),
    opponentHp,
    playerHp,
  );

  /// Create a copy of Board
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BoardImplCopyWith<_$BoardImpl> get copyWith =>
      __$$BoardImplCopyWithImpl<_$BoardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BoardImplToJson(this);
  }
}

abstract class _Board implements Board {
  const factory _Board({
    final List<MinionOnBoard> playerMinions,
    final List<MinionOnBoard> opponentMinions,
    final int opponentHp,
    final int playerHp,
  }) = _$BoardImpl;

  factory _Board.fromJson(Map<String, dynamic> json) = _$BoardImpl.fromJson;

  @override
  List<MinionOnBoard> get playerMinions;
  @override
  List<MinionOnBoard> get opponentMinions;
  @override
  int get opponentHp;
  @override
  int get playerHp;

  /// Create a copy of Board
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BoardImplCopyWith<_$BoardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ConstructedState _$ConstructedStateFromJson(Map<String, dynamic> json) {
  return _ConstructedState.fromJson(json);
}

/// @nodoc
mixin _$ConstructedState {
  String get playerClass => throw _privateConstructorUsedError;
  ConstructedFormat get format => throw _privateConstructorUsedError;
  List<CardInHand> get hand => throw _privateConstructorUsedError;
  Board get board => throw _privateConstructorUsedError;
  int get mana => throw _privateConstructorUsedError;
  int get maxMana => throw _privateConstructorUsedError;
  int get turn => throw _privateConstructorUsedError;
  bool get isPlayerTurn => throw _privateConstructorUsedError;
  bool get heroPowerAvailable => throw _privateConstructorUsedError;
  int get weaponAttack => throw _privateConstructorUsedError;

  /// Serializes this ConstructedState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConstructedState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConstructedStateCopyWith<ConstructedState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConstructedStateCopyWith<$Res> {
  factory $ConstructedStateCopyWith(
    ConstructedState value,
    $Res Function(ConstructedState) then,
  ) = _$ConstructedStateCopyWithImpl<$Res, ConstructedState>;
  @useResult
  $Res call({
    String playerClass,
    ConstructedFormat format,
    List<CardInHand> hand,
    Board board,
    int mana,
    int maxMana,
    int turn,
    bool isPlayerTurn,
    bool heroPowerAvailable,
    int weaponAttack,
  });

  $BoardCopyWith<$Res> get board;
}

/// @nodoc
class _$ConstructedStateCopyWithImpl<$Res, $Val extends ConstructedState>
    implements $ConstructedStateCopyWith<$Res> {
  _$ConstructedStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConstructedState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerClass = null,
    Object? format = null,
    Object? hand = null,
    Object? board = null,
    Object? mana = null,
    Object? maxMana = null,
    Object? turn = null,
    Object? isPlayerTurn = null,
    Object? heroPowerAvailable = null,
    Object? weaponAttack = null,
  }) {
    return _then(
      _value.copyWith(
            playerClass: null == playerClass
                ? _value.playerClass
                : playerClass // ignore: cast_nullable_to_non_nullable
                      as String,
            format: null == format
                ? _value.format
                : format // ignore: cast_nullable_to_non_nullable
                      as ConstructedFormat,
            hand: null == hand
                ? _value.hand
                : hand // ignore: cast_nullable_to_non_nullable
                      as List<CardInHand>,
            board: null == board
                ? _value.board
                : board // ignore: cast_nullable_to_non_nullable
                      as Board,
            mana: null == mana
                ? _value.mana
                : mana // ignore: cast_nullable_to_non_nullable
                      as int,
            maxMana: null == maxMana
                ? _value.maxMana
                : maxMana // ignore: cast_nullable_to_non_nullable
                      as int,
            turn: null == turn
                ? _value.turn
                : turn // ignore: cast_nullable_to_non_nullable
                      as int,
            isPlayerTurn: null == isPlayerTurn
                ? _value.isPlayerTurn
                : isPlayerTurn // ignore: cast_nullable_to_non_nullable
                      as bool,
            heroPowerAvailable: null == heroPowerAvailable
                ? _value.heroPowerAvailable
                : heroPowerAvailable // ignore: cast_nullable_to_non_nullable
                      as bool,
            weaponAttack: null == weaponAttack
                ? _value.weaponAttack
                : weaponAttack // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }

  /// Create a copy of ConstructedState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BoardCopyWith<$Res> get board {
    return $BoardCopyWith<$Res>(_value.board, (value) {
      return _then(_value.copyWith(board: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ConstructedStateImplCopyWith<$Res>
    implements $ConstructedStateCopyWith<$Res> {
  factory _$$ConstructedStateImplCopyWith(
    _$ConstructedStateImpl value,
    $Res Function(_$ConstructedStateImpl) then,
  ) = __$$ConstructedStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String playerClass,
    ConstructedFormat format,
    List<CardInHand> hand,
    Board board,
    int mana,
    int maxMana,
    int turn,
    bool isPlayerTurn,
    bool heroPowerAvailable,
    int weaponAttack,
  });

  @override
  $BoardCopyWith<$Res> get board;
}

/// @nodoc
class __$$ConstructedStateImplCopyWithImpl<$Res>
    extends _$ConstructedStateCopyWithImpl<$Res, _$ConstructedStateImpl>
    implements _$$ConstructedStateImplCopyWith<$Res> {
  __$$ConstructedStateImplCopyWithImpl(
    _$ConstructedStateImpl _value,
    $Res Function(_$ConstructedStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ConstructedState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerClass = null,
    Object? format = null,
    Object? hand = null,
    Object? board = null,
    Object? mana = null,
    Object? maxMana = null,
    Object? turn = null,
    Object? isPlayerTurn = null,
    Object? heroPowerAvailable = null,
    Object? weaponAttack = null,
  }) {
    return _then(
      _$ConstructedStateImpl(
        playerClass: null == playerClass
            ? _value.playerClass
            : playerClass // ignore: cast_nullable_to_non_nullable
                  as String,
        format: null == format
            ? _value.format
            : format // ignore: cast_nullable_to_non_nullable
                  as ConstructedFormat,
        hand: null == hand
            ? _value._hand
            : hand // ignore: cast_nullable_to_non_nullable
                  as List<CardInHand>,
        board: null == board
            ? _value.board
            : board // ignore: cast_nullable_to_non_nullable
                  as Board,
        mana: null == mana
            ? _value.mana
            : mana // ignore: cast_nullable_to_non_nullable
                  as int,
        maxMana: null == maxMana
            ? _value.maxMana
            : maxMana // ignore: cast_nullable_to_non_nullable
                  as int,
        turn: null == turn
            ? _value.turn
            : turn // ignore: cast_nullable_to_non_nullable
                  as int,
        isPlayerTurn: null == isPlayerTurn
            ? _value.isPlayerTurn
            : isPlayerTurn // ignore: cast_nullable_to_non_nullable
                  as bool,
        heroPowerAvailable: null == heroPowerAvailable
            ? _value.heroPowerAvailable
            : heroPowerAvailable // ignore: cast_nullable_to_non_nullable
                  as bool,
        weaponAttack: null == weaponAttack
            ? _value.weaponAttack
            : weaponAttack // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ConstructedStateImpl implements _ConstructedState {
  const _$ConstructedStateImpl({
    required this.playerClass,
    required this.format,
    required final List<CardInHand> hand,
    required this.board,
    required this.mana,
    required this.maxMana,
    required this.turn,
    this.isPlayerTurn = false,
    this.heroPowerAvailable = false,
    this.weaponAttack = 0,
  }) : _hand = hand;

  factory _$ConstructedStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConstructedStateImplFromJson(json);

  @override
  final String playerClass;
  @override
  final ConstructedFormat format;
  final List<CardInHand> _hand;
  @override
  List<CardInHand> get hand {
    if (_hand is EqualUnmodifiableListView) return _hand;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hand);
  }

  @override
  final Board board;
  @override
  final int mana;
  @override
  final int maxMana;
  @override
  final int turn;
  @override
  @JsonKey()
  final bool isPlayerTurn;
  @override
  @JsonKey()
  final bool heroPowerAvailable;
  @override
  @JsonKey()
  final int weaponAttack;

  @override
  String toString() {
    return 'ConstructedState(playerClass: $playerClass, format: $format, hand: $hand, board: $board, mana: $mana, maxMana: $maxMana, turn: $turn, isPlayerTurn: $isPlayerTurn, heroPowerAvailable: $heroPowerAvailable, weaponAttack: $weaponAttack)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConstructedStateImpl &&
            (identical(other.playerClass, playerClass) ||
                other.playerClass == playerClass) &&
            (identical(other.format, format) || other.format == format) &&
            const DeepCollectionEquality().equals(other._hand, _hand) &&
            (identical(other.board, board) || other.board == board) &&
            (identical(other.mana, mana) || other.mana == mana) &&
            (identical(other.maxMana, maxMana) || other.maxMana == maxMana) &&
            (identical(other.turn, turn) || other.turn == turn) &&
            (identical(other.isPlayerTurn, isPlayerTurn) ||
                other.isPlayerTurn == isPlayerTurn) &&
            (identical(other.heroPowerAvailable, heroPowerAvailable) ||
                other.heroPowerAvailable == heroPowerAvailable) &&
            (identical(other.weaponAttack, weaponAttack) ||
                other.weaponAttack == weaponAttack));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    playerClass,
    format,
    const DeepCollectionEquality().hash(_hand),
    board,
    mana,
    maxMana,
    turn,
    isPlayerTurn,
    heroPowerAvailable,
    weaponAttack,
  );

  /// Create a copy of ConstructedState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConstructedStateImplCopyWith<_$ConstructedStateImpl> get copyWith =>
      __$$ConstructedStateImplCopyWithImpl<_$ConstructedStateImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ConstructedStateImplToJson(this);
  }
}

abstract class _ConstructedState implements ConstructedState {
  const factory _ConstructedState({
    required final String playerClass,
    required final ConstructedFormat format,
    required final List<CardInHand> hand,
    required final Board board,
    required final int mana,
    required final int maxMana,
    required final int turn,
    final bool isPlayerTurn,
    final bool heroPowerAvailable,
    final int weaponAttack,
  }) = _$ConstructedStateImpl;

  factory _ConstructedState.fromJson(Map<String, dynamic> json) =
      _$ConstructedStateImpl.fromJson;

  @override
  String get playerClass;
  @override
  ConstructedFormat get format;
  @override
  List<CardInHand> get hand;
  @override
  Board get board;
  @override
  int get mana;
  @override
  int get maxMana;
  @override
  int get turn;
  @override
  bool get isPlayerTurn;
  @override
  bool get heroPowerAvailable;
  @override
  int get weaponAttack;

  /// Create a copy of ConstructedState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConstructedStateImplCopyWith<_$ConstructedStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BgsMinion _$BgsMinionFromJson(Map<String, dynamic> json) {
  return _BgsMinion.fromJson(json);
}

/// @nodoc
mixin _$BgsMinion {
  String get cardId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get attack => throw _privateConstructorUsedError;
  int get health => throw _privateConstructorUsedError;
  int get tier => throw _privateConstructorUsedError;
  bool get isGolden => throw _privateConstructorUsedError;
  List<String> get types => throw _privateConstructorUsedError;

  /// Serializes this BgsMinion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BgsMinion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BgsMinionCopyWith<BgsMinion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BgsMinionCopyWith<$Res> {
  factory $BgsMinionCopyWith(BgsMinion value, $Res Function(BgsMinion) then) =
      _$BgsMinionCopyWithImpl<$Res, BgsMinion>;
  @useResult
  $Res call({
    String cardId,
    String name,
    int attack,
    int health,
    int tier,
    bool isGolden,
    List<String> types,
  });
}

/// @nodoc
class _$BgsMinionCopyWithImpl<$Res, $Val extends BgsMinion>
    implements $BgsMinionCopyWith<$Res> {
  _$BgsMinionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BgsMinion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cardId = null,
    Object? name = null,
    Object? attack = null,
    Object? health = null,
    Object? tier = null,
    Object? isGolden = null,
    Object? types = null,
  }) {
    return _then(
      _value.copyWith(
            cardId: null == cardId
                ? _value.cardId
                : cardId // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            attack: null == attack
                ? _value.attack
                : attack // ignore: cast_nullable_to_non_nullable
                      as int,
            health: null == health
                ? _value.health
                : health // ignore: cast_nullable_to_non_nullable
                      as int,
            tier: null == tier
                ? _value.tier
                : tier // ignore: cast_nullable_to_non_nullable
                      as int,
            isGolden: null == isGolden
                ? _value.isGolden
                : isGolden // ignore: cast_nullable_to_non_nullable
                      as bool,
            types: null == types
                ? _value.types
                : types // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BgsMinionImplCopyWith<$Res>
    implements $BgsMinionCopyWith<$Res> {
  factory _$$BgsMinionImplCopyWith(
    _$BgsMinionImpl value,
    $Res Function(_$BgsMinionImpl) then,
  ) = __$$BgsMinionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String cardId,
    String name,
    int attack,
    int health,
    int tier,
    bool isGolden,
    List<String> types,
  });
}

/// @nodoc
class __$$BgsMinionImplCopyWithImpl<$Res>
    extends _$BgsMinionCopyWithImpl<$Res, _$BgsMinionImpl>
    implements _$$BgsMinionImplCopyWith<$Res> {
  __$$BgsMinionImplCopyWithImpl(
    _$BgsMinionImpl _value,
    $Res Function(_$BgsMinionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BgsMinion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cardId = null,
    Object? name = null,
    Object? attack = null,
    Object? health = null,
    Object? tier = null,
    Object? isGolden = null,
    Object? types = null,
  }) {
    return _then(
      _$BgsMinionImpl(
        cardId: null == cardId
            ? _value.cardId
            : cardId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        attack: null == attack
            ? _value.attack
            : attack // ignore: cast_nullable_to_non_nullable
                  as int,
        health: null == health
            ? _value.health
            : health // ignore: cast_nullable_to_non_nullable
                  as int,
        tier: null == tier
            ? _value.tier
            : tier // ignore: cast_nullable_to_non_nullable
                  as int,
        isGolden: null == isGolden
            ? _value.isGolden
            : isGolden // ignore: cast_nullable_to_non_nullable
                  as bool,
        types: null == types
            ? _value._types
            : types // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BgsMinionImpl implements _BgsMinion {
  const _$BgsMinionImpl({
    required this.cardId,
    required this.name,
    required this.attack,
    required this.health,
    required this.tier,
    this.isGolden = false,
    final List<String> types = const [],
  }) : _types = types;

  factory _$BgsMinionImpl.fromJson(Map<String, dynamic> json) =>
      _$$BgsMinionImplFromJson(json);

  @override
  final String cardId;
  @override
  final String name;
  @override
  final int attack;
  @override
  final int health;
  @override
  final int tier;
  @override
  @JsonKey()
  final bool isGolden;
  final List<String> _types;
  @override
  @JsonKey()
  List<String> get types {
    if (_types is EqualUnmodifiableListView) return _types;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_types);
  }

  @override
  String toString() {
    return 'BgsMinion(cardId: $cardId, name: $name, attack: $attack, health: $health, tier: $tier, isGolden: $isGolden, types: $types)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BgsMinionImpl &&
            (identical(other.cardId, cardId) || other.cardId == cardId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.attack, attack) || other.attack == attack) &&
            (identical(other.health, health) || other.health == health) &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.isGolden, isGolden) ||
                other.isGolden == isGolden) &&
            const DeepCollectionEquality().equals(other._types, _types));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    cardId,
    name,
    attack,
    health,
    tier,
    isGolden,
    const DeepCollectionEquality().hash(_types),
  );

  /// Create a copy of BgsMinion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BgsMinionImplCopyWith<_$BgsMinionImpl> get copyWith =>
      __$$BgsMinionImplCopyWithImpl<_$BgsMinionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BgsMinionImplToJson(this);
  }
}

abstract class _BgsMinion implements BgsMinion {
  const factory _BgsMinion({
    required final String cardId,
    required final String name,
    required final int attack,
    required final int health,
    required final int tier,
    final bool isGolden,
    final List<String> types,
  }) = _$BgsMinionImpl;

  factory _BgsMinion.fromJson(Map<String, dynamic> json) =
      _$BgsMinionImpl.fromJson;

  @override
  String get cardId;
  @override
  String get name;
  @override
  int get attack;
  @override
  int get health;
  @override
  int get tier;
  @override
  bool get isGolden;
  @override
  List<String> get types;

  /// Create a copy of BgsMinion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BgsMinionImplCopyWith<_$BgsMinionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BgsState _$BgsStateFromJson(Map<String, dynamic> json) {
  return _BgsState.fromJson(json);
}

/// @nodoc
mixin _$BgsState {
  int get tavernTier => throw _privateConstructorUsedError;
  int get gold => throw _privateConstructorUsedError;
  int get maxGold => throw _privateConstructorUsedError;
  List<BgsMinion> get shop => throw _privateConstructorUsedError;
  List<BgsMinion> get board => throw _privateConstructorUsedError;
  int get turn => throw _privateConstructorUsedError;
  bool get isShopPhase => throw _privateConstructorUsedError;
  int get playerHp => throw _privateConstructorUsedError;

  /// Serializes this BgsState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BgsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BgsStateCopyWith<BgsState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BgsStateCopyWith<$Res> {
  factory $BgsStateCopyWith(BgsState value, $Res Function(BgsState) then) =
      _$BgsStateCopyWithImpl<$Res, BgsState>;
  @useResult
  $Res call({
    int tavernTier,
    int gold,
    int maxGold,
    List<BgsMinion> shop,
    List<BgsMinion> board,
    int turn,
    bool isShopPhase,
    int playerHp,
  });
}

/// @nodoc
class _$BgsStateCopyWithImpl<$Res, $Val extends BgsState>
    implements $BgsStateCopyWith<$Res> {
  _$BgsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BgsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tavernTier = null,
    Object? gold = null,
    Object? maxGold = null,
    Object? shop = null,
    Object? board = null,
    Object? turn = null,
    Object? isShopPhase = null,
    Object? playerHp = null,
  }) {
    return _then(
      _value.copyWith(
            tavernTier: null == tavernTier
                ? _value.tavernTier
                : tavernTier // ignore: cast_nullable_to_non_nullable
                      as int,
            gold: null == gold
                ? _value.gold
                : gold // ignore: cast_nullable_to_non_nullable
                      as int,
            maxGold: null == maxGold
                ? _value.maxGold
                : maxGold // ignore: cast_nullable_to_non_nullable
                      as int,
            shop: null == shop
                ? _value.shop
                : shop // ignore: cast_nullable_to_non_nullable
                      as List<BgsMinion>,
            board: null == board
                ? _value.board
                : board // ignore: cast_nullable_to_non_nullable
                      as List<BgsMinion>,
            turn: null == turn
                ? _value.turn
                : turn // ignore: cast_nullable_to_non_nullable
                      as int,
            isShopPhase: null == isShopPhase
                ? _value.isShopPhase
                : isShopPhase // ignore: cast_nullable_to_non_nullable
                      as bool,
            playerHp: null == playerHp
                ? _value.playerHp
                : playerHp // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BgsStateImplCopyWith<$Res>
    implements $BgsStateCopyWith<$Res> {
  factory _$$BgsStateImplCopyWith(
    _$BgsStateImpl value,
    $Res Function(_$BgsStateImpl) then,
  ) = __$$BgsStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int tavernTier,
    int gold,
    int maxGold,
    List<BgsMinion> shop,
    List<BgsMinion> board,
    int turn,
    bool isShopPhase,
    int playerHp,
  });
}

/// @nodoc
class __$$BgsStateImplCopyWithImpl<$Res>
    extends _$BgsStateCopyWithImpl<$Res, _$BgsStateImpl>
    implements _$$BgsStateImplCopyWith<$Res> {
  __$$BgsStateImplCopyWithImpl(
    _$BgsStateImpl _value,
    $Res Function(_$BgsStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BgsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tavernTier = null,
    Object? gold = null,
    Object? maxGold = null,
    Object? shop = null,
    Object? board = null,
    Object? turn = null,
    Object? isShopPhase = null,
    Object? playerHp = null,
  }) {
    return _then(
      _$BgsStateImpl(
        tavernTier: null == tavernTier
            ? _value.tavernTier
            : tavernTier // ignore: cast_nullable_to_non_nullable
                  as int,
        gold: null == gold
            ? _value.gold
            : gold // ignore: cast_nullable_to_non_nullable
                  as int,
        maxGold: null == maxGold
            ? _value.maxGold
            : maxGold // ignore: cast_nullable_to_non_nullable
                  as int,
        shop: null == shop
            ? _value._shop
            : shop // ignore: cast_nullable_to_non_nullable
                  as List<BgsMinion>,
        board: null == board
            ? _value._board
            : board // ignore: cast_nullable_to_non_nullable
                  as List<BgsMinion>,
        turn: null == turn
            ? _value.turn
            : turn // ignore: cast_nullable_to_non_nullable
                  as int,
        isShopPhase: null == isShopPhase
            ? _value.isShopPhase
            : isShopPhase // ignore: cast_nullable_to_non_nullable
                  as bool,
        playerHp: null == playerHp
            ? _value.playerHp
            : playerHp // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BgsStateImpl implements _BgsState {
  const _$BgsStateImpl({
    required this.tavernTier,
    required this.gold,
    required this.maxGold,
    required final List<BgsMinion> shop,
    required final List<BgsMinion> board,
    required this.turn,
    this.isShopPhase = false,
    this.playerHp = 40,
  }) : _shop = shop,
       _board = board;

  factory _$BgsStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$BgsStateImplFromJson(json);

  @override
  final int tavernTier;
  @override
  final int gold;
  @override
  final int maxGold;
  final List<BgsMinion> _shop;
  @override
  List<BgsMinion> get shop {
    if (_shop is EqualUnmodifiableListView) return _shop;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_shop);
  }

  final List<BgsMinion> _board;
  @override
  List<BgsMinion> get board {
    if (_board is EqualUnmodifiableListView) return _board;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_board);
  }

  @override
  final int turn;
  @override
  @JsonKey()
  final bool isShopPhase;
  @override
  @JsonKey()
  final int playerHp;

  @override
  String toString() {
    return 'BgsState(tavernTier: $tavernTier, gold: $gold, maxGold: $maxGold, shop: $shop, board: $board, turn: $turn, isShopPhase: $isShopPhase, playerHp: $playerHp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BgsStateImpl &&
            (identical(other.tavernTier, tavernTier) ||
                other.tavernTier == tavernTier) &&
            (identical(other.gold, gold) || other.gold == gold) &&
            (identical(other.maxGold, maxGold) || other.maxGold == maxGold) &&
            const DeepCollectionEquality().equals(other._shop, _shop) &&
            const DeepCollectionEquality().equals(other._board, _board) &&
            (identical(other.turn, turn) || other.turn == turn) &&
            (identical(other.isShopPhase, isShopPhase) ||
                other.isShopPhase == isShopPhase) &&
            (identical(other.playerHp, playerHp) ||
                other.playerHp == playerHp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    tavernTier,
    gold,
    maxGold,
    const DeepCollectionEquality().hash(_shop),
    const DeepCollectionEquality().hash(_board),
    turn,
    isShopPhase,
    playerHp,
  );

  /// Create a copy of BgsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BgsStateImplCopyWith<_$BgsStateImpl> get copyWith =>
      __$$BgsStateImplCopyWithImpl<_$BgsStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BgsStateImplToJson(this);
  }
}

abstract class _BgsState implements BgsState {
  const factory _BgsState({
    required final int tavernTier,
    required final int gold,
    required final int maxGold,
    required final List<BgsMinion> shop,
    required final List<BgsMinion> board,
    required final int turn,
    final bool isShopPhase,
    final int playerHp,
  }) = _$BgsStateImpl;

  factory _BgsState.fromJson(Map<String, dynamic> json) =
      _$BgsStateImpl.fromJson;

  @override
  int get tavernTier;
  @override
  int get gold;
  @override
  int get maxGold;
  @override
  List<BgsMinion> get shop;
  @override
  List<BgsMinion> get board;
  @override
  int get turn;
  @override
  bool get isShopPhase;
  @override
  int get playerHp;

  /// Create a copy of BgsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BgsStateImplCopyWith<_$BgsStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GameState _$GameStateFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'constructed':
      return ConstructedGameState.fromJson(json);
    case 'battlegrounds':
      return BattlegroundsGameState.fromJson(json);
    case 'idle':
      return IdleGameState.fromJson(json);

    default:
      throw CheckedFromJsonException(
        json,
        'runtimeType',
        'GameState',
        'Invalid union type "${json['runtimeType']}"!',
      );
  }
}

/// @nodoc
mixin _$GameState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ConstructedState state) constructed,
    required TResult Function(BgsState state) battlegrounds,
    required TResult Function() idle,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ConstructedState state)? constructed,
    TResult? Function(BgsState state)? battlegrounds,
    TResult? Function()? idle,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ConstructedState state)? constructed,
    TResult Function(BgsState state)? battlegrounds,
    TResult Function()? idle,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ConstructedGameState value) constructed,
    required TResult Function(BattlegroundsGameState value) battlegrounds,
    required TResult Function(IdleGameState value) idle,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ConstructedGameState value)? constructed,
    TResult? Function(BattlegroundsGameState value)? battlegrounds,
    TResult? Function(IdleGameState value)? idle,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ConstructedGameState value)? constructed,
    TResult Function(BattlegroundsGameState value)? battlegrounds,
    TResult Function(IdleGameState value)? idle,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Serializes this GameState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameStateCopyWith<$Res> {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) then) =
      _$GameStateCopyWithImpl<$Res, GameState>;
}

/// @nodoc
class _$GameStateCopyWithImpl<$Res, $Val extends GameState>
    implements $GameStateCopyWith<$Res> {
  _$GameStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ConstructedGameStateImplCopyWith<$Res> {
  factory _$$ConstructedGameStateImplCopyWith(
    _$ConstructedGameStateImpl value,
    $Res Function(_$ConstructedGameStateImpl) then,
  ) = __$$ConstructedGameStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ConstructedState state});

  $ConstructedStateCopyWith<$Res> get state;
}

/// @nodoc
class __$$ConstructedGameStateImplCopyWithImpl<$Res>
    extends _$GameStateCopyWithImpl<$Res, _$ConstructedGameStateImpl>
    implements _$$ConstructedGameStateImplCopyWith<$Res> {
  __$$ConstructedGameStateImplCopyWithImpl(
    _$ConstructedGameStateImpl _value,
    $Res Function(_$ConstructedGameStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? state = null}) {
    return _then(
      _$ConstructedGameStateImpl(
        null == state
            ? _value.state
            : state // ignore: cast_nullable_to_non_nullable
                  as ConstructedState,
      ),
    );
  }

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConstructedStateCopyWith<$Res> get state {
    return $ConstructedStateCopyWith<$Res>(_value.state, (value) {
      return _then(_value.copyWith(state: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$ConstructedGameStateImpl implements ConstructedGameState {
  const _$ConstructedGameStateImpl(this.state, {final String? $type})
    : $type = $type ?? 'constructed';

  factory _$ConstructedGameStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConstructedGameStateImplFromJson(json);

  @override
  final ConstructedState state;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'GameState.constructed(state: $state)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConstructedGameStateImpl &&
            (identical(other.state, state) || other.state == state));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, state);

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConstructedGameStateImplCopyWith<_$ConstructedGameStateImpl>
  get copyWith =>
      __$$ConstructedGameStateImplCopyWithImpl<_$ConstructedGameStateImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ConstructedState state) constructed,
    required TResult Function(BgsState state) battlegrounds,
    required TResult Function() idle,
  }) {
    return constructed(state);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ConstructedState state)? constructed,
    TResult? Function(BgsState state)? battlegrounds,
    TResult? Function()? idle,
  }) {
    return constructed?.call(state);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ConstructedState state)? constructed,
    TResult Function(BgsState state)? battlegrounds,
    TResult Function()? idle,
    required TResult orElse(),
  }) {
    if (constructed != null) {
      return constructed(state);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ConstructedGameState value) constructed,
    required TResult Function(BattlegroundsGameState value) battlegrounds,
    required TResult Function(IdleGameState value) idle,
  }) {
    return constructed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ConstructedGameState value)? constructed,
    TResult? Function(BattlegroundsGameState value)? battlegrounds,
    TResult? Function(IdleGameState value)? idle,
  }) {
    return constructed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ConstructedGameState value)? constructed,
    TResult Function(BattlegroundsGameState value)? battlegrounds,
    TResult Function(IdleGameState value)? idle,
    required TResult orElse(),
  }) {
    if (constructed != null) {
      return constructed(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ConstructedGameStateImplToJson(this);
  }
}

abstract class ConstructedGameState implements GameState {
  const factory ConstructedGameState(final ConstructedState state) =
      _$ConstructedGameStateImpl;

  factory ConstructedGameState.fromJson(Map<String, dynamic> json) =
      _$ConstructedGameStateImpl.fromJson;

  ConstructedState get state;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConstructedGameStateImplCopyWith<_$ConstructedGameStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BattlegroundsGameStateImplCopyWith<$Res> {
  factory _$$BattlegroundsGameStateImplCopyWith(
    _$BattlegroundsGameStateImpl value,
    $Res Function(_$BattlegroundsGameStateImpl) then,
  ) = __$$BattlegroundsGameStateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({BgsState state});

  $BgsStateCopyWith<$Res> get state;
}

/// @nodoc
class __$$BattlegroundsGameStateImplCopyWithImpl<$Res>
    extends _$GameStateCopyWithImpl<$Res, _$BattlegroundsGameStateImpl>
    implements _$$BattlegroundsGameStateImplCopyWith<$Res> {
  __$$BattlegroundsGameStateImplCopyWithImpl(
    _$BattlegroundsGameStateImpl _value,
    $Res Function(_$BattlegroundsGameStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? state = null}) {
    return _then(
      _$BattlegroundsGameStateImpl(
        null == state
            ? _value.state
            : state // ignore: cast_nullable_to_non_nullable
                  as BgsState,
      ),
    );
  }

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BgsStateCopyWith<$Res> get state {
    return $BgsStateCopyWith<$Res>(_value.state, (value) {
      return _then(_value.copyWith(state: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$BattlegroundsGameStateImpl implements BattlegroundsGameState {
  const _$BattlegroundsGameStateImpl(this.state, {final String? $type})
    : $type = $type ?? 'battlegrounds';

  factory _$BattlegroundsGameStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$BattlegroundsGameStateImplFromJson(json);

  @override
  final BgsState state;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'GameState.battlegrounds(state: $state)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BattlegroundsGameStateImpl &&
            (identical(other.state, state) || other.state == state));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, state);

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BattlegroundsGameStateImplCopyWith<_$BattlegroundsGameStateImpl>
  get copyWith =>
      __$$BattlegroundsGameStateImplCopyWithImpl<_$BattlegroundsGameStateImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ConstructedState state) constructed,
    required TResult Function(BgsState state) battlegrounds,
    required TResult Function() idle,
  }) {
    return battlegrounds(state);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ConstructedState state)? constructed,
    TResult? Function(BgsState state)? battlegrounds,
    TResult? Function()? idle,
  }) {
    return battlegrounds?.call(state);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ConstructedState state)? constructed,
    TResult Function(BgsState state)? battlegrounds,
    TResult Function()? idle,
    required TResult orElse(),
  }) {
    if (battlegrounds != null) {
      return battlegrounds(state);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ConstructedGameState value) constructed,
    required TResult Function(BattlegroundsGameState value) battlegrounds,
    required TResult Function(IdleGameState value) idle,
  }) {
    return battlegrounds(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ConstructedGameState value)? constructed,
    TResult? Function(BattlegroundsGameState value)? battlegrounds,
    TResult? Function(IdleGameState value)? idle,
  }) {
    return battlegrounds?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ConstructedGameState value)? constructed,
    TResult Function(BattlegroundsGameState value)? battlegrounds,
    TResult Function(IdleGameState value)? idle,
    required TResult orElse(),
  }) {
    if (battlegrounds != null) {
      return battlegrounds(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$BattlegroundsGameStateImplToJson(this);
  }
}

abstract class BattlegroundsGameState implements GameState {
  const factory BattlegroundsGameState(final BgsState state) =
      _$BattlegroundsGameStateImpl;

  factory BattlegroundsGameState.fromJson(Map<String, dynamic> json) =
      _$BattlegroundsGameStateImpl.fromJson;

  BgsState get state;

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BattlegroundsGameStateImplCopyWith<_$BattlegroundsGameStateImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$IdleGameStateImplCopyWith<$Res> {
  factory _$$IdleGameStateImplCopyWith(
    _$IdleGameStateImpl value,
    $Res Function(_$IdleGameStateImpl) then,
  ) = __$$IdleGameStateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$IdleGameStateImplCopyWithImpl<$Res>
    extends _$GameStateCopyWithImpl<$Res, _$IdleGameStateImpl>
    implements _$$IdleGameStateImplCopyWith<$Res> {
  __$$IdleGameStateImplCopyWithImpl(
    _$IdleGameStateImpl _value,
    $Res Function(_$IdleGameStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GameState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$IdleGameStateImpl implements IdleGameState {
  const _$IdleGameStateImpl({final String? $type}) : $type = $type ?? 'idle';

  factory _$IdleGameStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$IdleGameStateImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'GameState.idle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$IdleGameStateImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(ConstructedState state) constructed,
    required TResult Function(BgsState state) battlegrounds,
    required TResult Function() idle,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(ConstructedState state)? constructed,
    TResult? Function(BgsState state)? battlegrounds,
    TResult? Function()? idle,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(ConstructedState state)? constructed,
    TResult Function(BgsState state)? battlegrounds,
    TResult Function()? idle,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ConstructedGameState value) constructed,
    required TResult Function(BattlegroundsGameState value) battlegrounds,
    required TResult Function(IdleGameState value) idle,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ConstructedGameState value)? constructed,
    TResult? Function(BattlegroundsGameState value)? battlegrounds,
    TResult? Function(IdleGameState value)? idle,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ConstructedGameState value)? constructed,
    TResult Function(BattlegroundsGameState value)? battlegrounds,
    TResult Function(IdleGameState value)? idle,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$IdleGameStateImplToJson(this);
  }
}

abstract class IdleGameState implements GameState {
  const factory IdleGameState() = _$IdleGameStateImpl;

  factory IdleGameState.fromJson(Map<String, dynamic> json) =
      _$IdleGameStateImpl.fromJson;
}
