// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'closed_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ClosedState {
  int get currentIndex => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ClosedStateCopyWith<ClosedState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClosedStateCopyWith<$Res> {
  factory $ClosedStateCopyWith(
          ClosedState value, $Res Function(ClosedState) then) =
      _$ClosedStateCopyWithImpl<$Res, ClosedState>;
  @useResult
  $Res call({int currentIndex});
}

/// @nodoc
class _$ClosedStateCopyWithImpl<$Res, $Val extends ClosedState>
    implements $ClosedStateCopyWith<$Res> {
  _$ClosedStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentIndex = null,
  }) {
    return _then(_value.copyWith(
      currentIndex: null == currentIndex
          ? _value.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ClosedStateImplCopyWith<$Res>
    implements $ClosedStateCopyWith<$Res> {
  factory _$$ClosedStateImplCopyWith(
          _$ClosedStateImpl value, $Res Function(_$ClosedStateImpl) then) =
      __$$ClosedStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int currentIndex});
}

/// @nodoc
class __$$ClosedStateImplCopyWithImpl<$Res>
    extends _$ClosedStateCopyWithImpl<$Res, _$ClosedStateImpl>
    implements _$$ClosedStateImplCopyWith<$Res> {
  __$$ClosedStateImplCopyWithImpl(
      _$ClosedStateImpl _value, $Res Function(_$ClosedStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentIndex = null,
  }) {
    return _then(_$ClosedStateImpl(
      currentIndex: null == currentIndex
          ? _value.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$ClosedStateImpl extends _ClosedState {
  const _$ClosedStateImpl({this.currentIndex = 0}) : super._();

  @override
  @JsonKey()
  final int currentIndex;

  @override
  String toString() {
    return 'ClosedState(currentIndex: $currentIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClosedStateImpl &&
            (identical(other.currentIndex, currentIndex) ||
                other.currentIndex == currentIndex));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentIndex);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ClosedStateImplCopyWith<_$ClosedStateImpl> get copyWith =>
      __$$ClosedStateImplCopyWithImpl<_$ClosedStateImpl>(this, _$identity);
}

abstract class _ClosedState extends ClosedState {
  const factory _ClosedState({final int currentIndex}) = _$ClosedStateImpl;
  const _ClosedState._() : super._();

  @override
  int get currentIndex;
  @override
  @JsonKey(ignore: true)
  _$$ClosedStateImplCopyWith<_$ClosedStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
