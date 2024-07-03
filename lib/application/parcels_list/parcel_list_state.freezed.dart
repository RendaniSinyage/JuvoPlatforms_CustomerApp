// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parcel_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ParcelListState {
  bool get isActiveLoading => throw _privateConstructorUsedError;
  bool get isHistoryLoading => throw _privateConstructorUsedError;
  int get totalActiveCount => throw _privateConstructorUsedError;
  List<ParcelOrder> get activeOrders => throw _privateConstructorUsedError;
  List<ParcelOrder> get historyOrders => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ParcelListStateCopyWith<ParcelListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParcelListStateCopyWith<$Res> {
  factory $ParcelListStateCopyWith(
          ParcelListState value, $Res Function(ParcelListState) then) =
      _$ParcelListStateCopyWithImpl<$Res, ParcelListState>;
  @useResult
  $Res call(
      {bool isActiveLoading,
      bool isHistoryLoading,
      int totalActiveCount,
      List<ParcelOrder> activeOrders,
      List<ParcelOrder> historyOrders});
}

/// @nodoc
class _$ParcelListStateCopyWithImpl<$Res, $Val extends ParcelListState>
    implements $ParcelListStateCopyWith<$Res> {
  _$ParcelListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isActiveLoading = null,
    Object? isHistoryLoading = null,
    Object? totalActiveCount = null,
    Object? activeOrders = null,
    Object? historyOrders = null,
  }) {
    return _then(_value.copyWith(
      isActiveLoading: null == isActiveLoading
          ? _value.isActiveLoading
          : isActiveLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isHistoryLoading: null == isHistoryLoading
          ? _value.isHistoryLoading
          : isHistoryLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      totalActiveCount: null == totalActiveCount
          ? _value.totalActiveCount
          : totalActiveCount // ignore: cast_nullable_to_non_nullable
              as int,
      activeOrders: null == activeOrders
          ? _value.activeOrders
          : activeOrders // ignore: cast_nullable_to_non_nullable
              as List<ParcelOrder>,
      historyOrders: null == historyOrders
          ? _value.historyOrders
          : historyOrders // ignore: cast_nullable_to_non_nullable
              as List<ParcelOrder>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ParcelListStateImplCopyWith<$Res>
    implements $ParcelListStateCopyWith<$Res> {
  factory _$$ParcelListStateImplCopyWith(_$ParcelListStateImpl value,
          $Res Function(_$ParcelListStateImpl) then) =
      __$$ParcelListStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isActiveLoading,
      bool isHistoryLoading,
      int totalActiveCount,
      List<ParcelOrder> activeOrders,
      List<ParcelOrder> historyOrders});
}

/// @nodoc
class __$$ParcelListStateImplCopyWithImpl<$Res>
    extends _$ParcelListStateCopyWithImpl<$Res, _$ParcelListStateImpl>
    implements _$$ParcelListStateImplCopyWith<$Res> {
  __$$ParcelListStateImplCopyWithImpl(
      _$ParcelListStateImpl _value, $Res Function(_$ParcelListStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isActiveLoading = null,
    Object? isHistoryLoading = null,
    Object? totalActiveCount = null,
    Object? activeOrders = null,
    Object? historyOrders = null,
  }) {
    return _then(_$ParcelListStateImpl(
      isActiveLoading: null == isActiveLoading
          ? _value.isActiveLoading
          : isActiveLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isHistoryLoading: null == isHistoryLoading
          ? _value.isHistoryLoading
          : isHistoryLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      totalActiveCount: null == totalActiveCount
          ? _value.totalActiveCount
          : totalActiveCount // ignore: cast_nullable_to_non_nullable
              as int,
      activeOrders: null == activeOrders
          ? _value._activeOrders
          : activeOrders // ignore: cast_nullable_to_non_nullable
              as List<ParcelOrder>,
      historyOrders: null == historyOrders
          ? _value._historyOrders
          : historyOrders // ignore: cast_nullable_to_non_nullable
              as List<ParcelOrder>,
    ));
  }
}

/// @nodoc

class _$ParcelListStateImpl extends _ParcelListState {
  const _$ParcelListStateImpl(
      {this.isActiveLoading = false,
      this.isHistoryLoading = false,
      this.totalActiveCount = 0,
      final List<ParcelOrder> activeOrders = const [],
      final List<ParcelOrder> historyOrders = const []})
      : _activeOrders = activeOrders,
        _historyOrders = historyOrders,
        super._();

  @override
  @JsonKey()
  final bool isActiveLoading;
  @override
  @JsonKey()
  final bool isHistoryLoading;
  @override
  @JsonKey()
  final int totalActiveCount;
  final List<ParcelOrder> _activeOrders;
  @override
  @JsonKey()
  List<ParcelOrder> get activeOrders {
    if (_activeOrders is EqualUnmodifiableListView) return _activeOrders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activeOrders);
  }

  final List<ParcelOrder> _historyOrders;
  @override
  @JsonKey()
  List<ParcelOrder> get historyOrders {
    if (_historyOrders is EqualUnmodifiableListView) return _historyOrders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_historyOrders);
  }

  @override
  String toString() {
    return 'ParcelListState(isActiveLoading: $isActiveLoading, isHistoryLoading: $isHistoryLoading, totalActiveCount: $totalActiveCount, activeOrders: $activeOrders, historyOrders: $historyOrders)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParcelListStateImpl &&
            (identical(other.isActiveLoading, isActiveLoading) ||
                other.isActiveLoading == isActiveLoading) &&
            (identical(other.isHistoryLoading, isHistoryLoading) ||
                other.isHistoryLoading == isHistoryLoading) &&
            (identical(other.totalActiveCount, totalActiveCount) ||
                other.totalActiveCount == totalActiveCount) &&
            const DeepCollectionEquality()
                .equals(other._activeOrders, _activeOrders) &&
            const DeepCollectionEquality()
                .equals(other._historyOrders, _historyOrders));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isActiveLoading,
      isHistoryLoading,
      totalActiveCount,
      const DeepCollectionEquality().hash(_activeOrders),
      const DeepCollectionEquality().hash(_historyOrders));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ParcelListStateImplCopyWith<_$ParcelListStateImpl> get copyWith =>
      __$$ParcelListStateImplCopyWithImpl<_$ParcelListStateImpl>(
          this, _$identity);
}

abstract class _ParcelListState extends ParcelListState {
  const factory _ParcelListState(
      {final bool isActiveLoading,
      final bool isHistoryLoading,
      final int totalActiveCount,
      final List<ParcelOrder> activeOrders,
      final List<ParcelOrder> historyOrders}) = _$ParcelListStateImpl;
  const _ParcelListState._() : super._();

  @override
  bool get isActiveLoading;
  @override
  bool get isHistoryLoading;
  @override
  int get totalActiveCount;
  @override
  List<ParcelOrder> get activeOrders;
  @override
  List<ParcelOrder> get historyOrders;
  @override
  @JsonKey(ignore: true)
  _$$ParcelListStateImplCopyWith<_$ParcelListStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
