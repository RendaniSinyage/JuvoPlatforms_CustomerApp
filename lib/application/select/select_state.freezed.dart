// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'select_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SelectState {
  int get selectedIndex => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SelectStateCopyWith<SelectState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SelectStateCopyWith<$Res> {
  factory $SelectStateCopyWith(
          SelectState value, $Res Function(SelectState) then) =
      _$SelectStateCopyWithImpl<$Res, SelectState>;
  @useResult
  $Res call({int selectedIndex});
}

/// @nodoc
class _$SelectStateCopyWithImpl<$Res, $Val extends SelectState>
    implements $SelectStateCopyWith<$Res> {
  _$SelectStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedIndex = null,
  }) {
    return _then(_value.copyWith(
      selectedIndex: null == selectedIndex
          ? _value.selectedIndex
          : selectedIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SelectStateImplCopyWith<$Res>
    implements $SelectStateCopyWith<$Res> {
  factory _$$SelectStateImplCopyWith(
          _$SelectStateImpl value, $Res Function(_$SelectStateImpl) then) =
      __$$SelectStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int selectedIndex});
}

/// @nodoc
class __$$SelectStateImplCopyWithImpl<$Res>
    extends _$SelectStateCopyWithImpl<$Res, _$SelectStateImpl>
    implements _$$SelectStateImplCopyWith<$Res> {
  __$$SelectStateImplCopyWithImpl(
      _$SelectStateImpl _value, $Res Function(_$SelectStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedIndex = null,
  }) {
    return _then(_$SelectStateImpl(
      selectedIndex: null == selectedIndex
          ? _value.selectedIndex
          : selectedIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$SelectStateImpl extends _SelectState {
  const _$SelectStateImpl({this.selectedIndex = 0}) : super._();

  @override
  @JsonKey()
  final int selectedIndex;

  @override
  String toString() {
    return 'SelectState(selectedIndex: $selectedIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SelectStateImpl &&
            (identical(other.selectedIndex, selectedIndex) ||
                other.selectedIndex == selectedIndex));
  }

  @override
  int get hashCode => Object.hash(runtimeType, selectedIndex);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SelectStateImplCopyWith<_$SelectStateImpl> get copyWith =>
      __$$SelectStateImplCopyWithImpl<_$SelectStateImpl>(this, _$identity);
}

abstract class _SelectState extends SelectState {
  const factory _SelectState({final int selectedIndex}) = _$SelectStateImpl;
  const _SelectState._() : super._();

  @override
  int get selectedIndex;
  @override
  @JsonKey(ignore: true)
  _$$SelectStateImplCopyWith<_$SelectStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
