// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommendation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$BgsRecommendation {
  BgsMinion get minion => throw _privateConstructorUsedError;
  double get score => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  bool get shouldFreeze => throw _privateConstructorUsedError;
  bool get shouldUpgradeTavern => throw _privateConstructorUsedError;

  /// Create a copy of BgsRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BgsRecommendationCopyWith<BgsRecommendation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BgsRecommendationCopyWith<$Res> {
  factory $BgsRecommendationCopyWith(
    BgsRecommendation value,
    $Res Function(BgsRecommendation) then,
  ) = _$BgsRecommendationCopyWithImpl<$Res, BgsRecommendation>;
  @useResult
  $Res call({
    BgsMinion minion,
    double score,
    String reason,
    bool shouldFreeze,
    bool shouldUpgradeTavern,
  });

  $BgsMinionCopyWith<$Res> get minion;
}

/// @nodoc
class _$BgsRecommendationCopyWithImpl<$Res, $Val extends BgsRecommendation>
    implements $BgsRecommendationCopyWith<$Res> {
  _$BgsRecommendationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BgsRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minion = null,
    Object? score = null,
    Object? reason = null,
    Object? shouldFreeze = null,
    Object? shouldUpgradeTavern = null,
  }) {
    return _then(
      _value.copyWith(
            minion: null == minion
                ? _value.minion
                : minion // ignore: cast_nullable_to_non_nullable
                      as BgsMinion,
            score: null == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                      as double,
            reason: null == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as String,
            shouldFreeze: null == shouldFreeze
                ? _value.shouldFreeze
                : shouldFreeze // ignore: cast_nullable_to_non_nullable
                      as bool,
            shouldUpgradeTavern: null == shouldUpgradeTavern
                ? _value.shouldUpgradeTavern
                : shouldUpgradeTavern // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of BgsRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BgsMinionCopyWith<$Res> get minion {
    return $BgsMinionCopyWith<$Res>(_value.minion, (value) {
      return _then(_value.copyWith(minion: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BgsRecommendationImplCopyWith<$Res>
    implements $BgsRecommendationCopyWith<$Res> {
  factory _$$BgsRecommendationImplCopyWith(
    _$BgsRecommendationImpl value,
    $Res Function(_$BgsRecommendationImpl) then,
  ) = __$$BgsRecommendationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    BgsMinion minion,
    double score,
    String reason,
    bool shouldFreeze,
    bool shouldUpgradeTavern,
  });

  @override
  $BgsMinionCopyWith<$Res> get minion;
}

/// @nodoc
class __$$BgsRecommendationImplCopyWithImpl<$Res>
    extends _$BgsRecommendationCopyWithImpl<$Res, _$BgsRecommendationImpl>
    implements _$$BgsRecommendationImplCopyWith<$Res> {
  __$$BgsRecommendationImplCopyWithImpl(
    _$BgsRecommendationImpl _value,
    $Res Function(_$BgsRecommendationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BgsRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minion = null,
    Object? score = null,
    Object? reason = null,
    Object? shouldFreeze = null,
    Object? shouldUpgradeTavern = null,
  }) {
    return _then(
      _$BgsRecommendationImpl(
        minion: null == minion
            ? _value.minion
            : minion // ignore: cast_nullable_to_non_nullable
                  as BgsMinion,
        score: null == score
            ? _value.score
            : score // ignore: cast_nullable_to_non_nullable
                  as double,
        reason: null == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String,
        shouldFreeze: null == shouldFreeze
            ? _value.shouldFreeze
            : shouldFreeze // ignore: cast_nullable_to_non_nullable
                  as bool,
        shouldUpgradeTavern: null == shouldUpgradeTavern
            ? _value.shouldUpgradeTavern
            : shouldUpgradeTavern // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$BgsRecommendationImpl implements _BgsRecommendation {
  const _$BgsRecommendationImpl({
    required this.minion,
    required this.score,
    required this.reason,
    this.shouldFreeze = false,
    this.shouldUpgradeTavern = false,
  });

  @override
  final BgsMinion minion;
  @override
  final double score;
  @override
  final String reason;
  @override
  @JsonKey()
  final bool shouldFreeze;
  @override
  @JsonKey()
  final bool shouldUpgradeTavern;

  @override
  String toString() {
    return 'BgsRecommendation(minion: $minion, score: $score, reason: $reason, shouldFreeze: $shouldFreeze, shouldUpgradeTavern: $shouldUpgradeTavern)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BgsRecommendationImpl &&
            (identical(other.minion, minion) || other.minion == minion) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.shouldFreeze, shouldFreeze) ||
                other.shouldFreeze == shouldFreeze) &&
            (identical(other.shouldUpgradeTavern, shouldUpgradeTavern) ||
                other.shouldUpgradeTavern == shouldUpgradeTavern));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    minion,
    score,
    reason,
    shouldFreeze,
    shouldUpgradeTavern,
  );

  /// Create a copy of BgsRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BgsRecommendationImplCopyWith<_$BgsRecommendationImpl> get copyWith =>
      __$$BgsRecommendationImplCopyWithImpl<_$BgsRecommendationImpl>(
        this,
        _$identity,
      );
}

abstract class _BgsRecommendation implements BgsRecommendation {
  const factory _BgsRecommendation({
    required final BgsMinion minion,
    required final double score,
    required final String reason,
    final bool shouldFreeze,
    final bool shouldUpgradeTavern,
  }) = _$BgsRecommendationImpl;

  @override
  BgsMinion get minion;
  @override
  double get score;
  @override
  String get reason;
  @override
  bool get shouldFreeze;
  @override
  bool get shouldUpgradeTavern;

  /// Create a copy of BgsRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BgsRecommendationImplCopyWith<_$BgsRecommendationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
