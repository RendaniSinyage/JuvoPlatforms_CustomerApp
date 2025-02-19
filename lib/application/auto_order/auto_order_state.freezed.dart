// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auto_order_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AutoOrderState {
  DateTime get from => throw _privateConstructorUsedError;
  DateTime get to => throw _privateConstructorUsedError;
  TimeOfDay? get time => throw _privateConstructorUsedError;
  dynamic get isError => throw _privateConstructorUsedError;

  /// Create a copy of AutoOrderState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AutoOrderStateCopyWith<AutoOrderState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AutoOrderStateCopyWith<$Res> {
  factory $AutoOrderStateCopyWith(
          AutoOrderState value, $Res Function(AutoOrderState) then) =
      _$AutoOrderStateCopyWithImpl<$Res, AutoOrderState>;
  @useResult
  $Res call({DateTime from, DateTime to, TimeOfDay? time, dynamic isError});
}

/// @nodoc
class _$AutoOrderStateCopyWithImpl<$Res, $Val extends AutoOrderState>
    implements $AutoOrderStateCopyWith<$Res> {
  _$AutoOrderStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AutoOrderState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? from = null,
    Object? to = null,
    Object? time = freezed,
    Object? isError = freezed,
  }) {
    return _then(_value.copyWith(
      from: null == from
          ? _value.from
          : from // ignore: cast_nullable_to_non_nullable
              as DateTime,
      to: null == to
          ? _value.to
          : to // ignore: cast_nullable_to_non_nullable
              as DateTime,
      time: freezed == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as TimeOfDay?,
      isError: freezed == isError
          ? _value.isError
          : isError // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AutoOrderStateImplCopyWith<$Res>
    implements $AutoOrderStateCopyWith<$Res> {
  factory _$$AutoOrderStateImplCopyWith(_$AutoOrderStateImpl value,
          $Res Function(_$AutoOrderStateImpl) then) =
      __$$AutoOrderStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime from, DateTime to, TimeOfDay? time, dynamic isError});
}

/// @nodoc
class __$$AutoOrderStateImplCopyWithImpl<$Res>
    extends _$AutoOrderStateCopyWithImpl<$Res, _$AutoOrderStateImpl>
    implements _$$AutoOrderStateImplCopyWith<$Res> {
  __$$AutoOrderStateImplCopyWithImpl(
      _$AutoOrderStateImpl _value, $Res Function(_$AutoOrderStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of AutoOrderState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? from = null,
    Object? to = null,
    Object? time = freezed,
    Object? isError = freezed,
  }) {
    return _then(_$AutoOrderStateImpl(
      from: null == from
          ? _value.from
          : from // ignore: cast_nullable_to_non_nullable
              as DateTime,
      to: null == to
          ? _value.to
          : to // ignore: cast_nullable_to_non_nullable
              as DateTime,
      time: freezed == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as TimeOfDay?,
      isError: freezed == isError ? _value.isError! : isError,
    ));
  }
}

/// @nodoc

class _$AutoOrderStateImpl extends _AutoOrderState {
  const _$AutoOrderStateImpl(
      {required this.from, required this.to, this.time, this.isError = false})
      : super._();

  @override
  final DateTime from;
  @override
  final DateTime to;
  @override
  final TimeOfDay? time;
  @override
  @JsonKey()
  final dynamic isError;

  @override
  String toString() {
    return 'AutoOrderState(from: $from, to: $to, time: $time, isError: $isError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AutoOrderStateImpl &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.to, to) || other.to == to) &&
            (identical(other.time, time) || other.time == time) &&
            const DeepCollectionEquality().equals(other.isError, isError));
  }

  @override
  int get hashCode => Object.hash(runtimeType, from, to, time,
      const DeepCollectionEquality().hash(isError));

  /// Create a copy of AutoOrderState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AutoOrderStateImplCopyWith<_$AutoOrderStateImpl> get copyWith =>
      __$$AutoOrderStateImplCopyWithImpl<_$AutoOrderStateImpl>(
          this, _$identity);
}

abstract class _AutoOrderState extends AutoOrderState {
  const factory _AutoOrderState(
      {required final DateTime from,
      required final DateTime to,
      final TimeOfDay? time,
      final dynamic isError}) = _$AutoOrderStateImpl;
  const _AutoOrderState._() : super._();

  @override
  DateTime get from;
  @override
  DateTime get to;
  @override
  TimeOfDay? get time;
  @override
  dynamic get isError;

  /// Create a copy of AutoOrderState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AutoOrderStateImplCopyWith<_$AutoOrderStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
