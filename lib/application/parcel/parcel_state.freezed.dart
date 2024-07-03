// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parcel_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ParcelState {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isButtonLoading => throw _privateConstructorUsedError;
  bool get isMapLoading => throw _privateConstructorUsedError;
  bool get error => throw _privateConstructorUsedError;
  LocationModel? get locationFrom => throw _privateConstructorUsedError;
  LocationModel? get locationTo => throw _privateConstructorUsedError;
  String? get addressTo => throw _privateConstructorUsedError;
  String? get addressFrom => throw _privateConstructorUsedError;
  TimeOfDay? get time => throw _privateConstructorUsedError;
  ParcelCalculateResponse? get calculate => throw _privateConstructorUsedError;
  List<TypeModel?> get types => throw _privateConstructorUsedError;
  int get selectType => throw _privateConstructorUsedError;
  bool get expand => throw _privateConstructorUsedError;
  bool get anonymous => throw _privateConstructorUsedError;
  ParcelOrder? get parcel => throw _privateConstructorUsedError;
  PaymentData? get selectPayment => throw _privateConstructorUsedError;
  Map<MarkerId, Marker> get markers => throw _privateConstructorUsedError;
  List<LatLng> get polylineCoordinates => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ParcelStateCopyWith<ParcelState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParcelStateCopyWith<$Res> {
  factory $ParcelStateCopyWith(
          ParcelState value, $Res Function(ParcelState) then) =
      _$ParcelStateCopyWithImpl<$Res, ParcelState>;
  @useResult
  $Res call(
      {bool isLoading,
      bool isButtonLoading,
      bool isMapLoading,
      bool error,
      LocationModel? locationFrom,
      LocationModel? locationTo,
      String? addressTo,
      String? addressFrom,
      TimeOfDay? time,
      ParcelCalculateResponse? calculate,
      List<TypeModel?> types,
      int selectType,
      bool expand,
      bool anonymous,
      ParcelOrder? parcel,
      PaymentData? selectPayment,
      Map<MarkerId, Marker> markers,
      List<LatLng> polylineCoordinates});
}

/// @nodoc
class _$ParcelStateCopyWithImpl<$Res, $Val extends ParcelState>
    implements $ParcelStateCopyWith<$Res> {
  _$ParcelStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isButtonLoading = null,
    Object? isMapLoading = null,
    Object? error = null,
    Object? locationFrom = freezed,
    Object? locationTo = freezed,
    Object? addressTo = freezed,
    Object? addressFrom = freezed,
    Object? time = freezed,
    Object? calculate = freezed,
    Object? types = null,
    Object? selectType = null,
    Object? expand = null,
    Object? anonymous = null,
    Object? parcel = freezed,
    Object? selectPayment = freezed,
    Object? markers = null,
    Object? polylineCoordinates = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isButtonLoading: null == isButtonLoading
          ? _value.isButtonLoading
          : isButtonLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isMapLoading: null == isMapLoading
          ? _value.isMapLoading
          : isMapLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as bool,
      locationFrom: freezed == locationFrom
          ? _value.locationFrom
          : locationFrom // ignore: cast_nullable_to_non_nullable
              as LocationModel?,
      locationTo: freezed == locationTo
          ? _value.locationTo
          : locationTo // ignore: cast_nullable_to_non_nullable
              as LocationModel?,
      addressTo: freezed == addressTo
          ? _value.addressTo
          : addressTo // ignore: cast_nullable_to_non_nullable
              as String?,
      addressFrom: freezed == addressFrom
          ? _value.addressFrom
          : addressFrom // ignore: cast_nullable_to_non_nullable
              as String?,
      time: freezed == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as TimeOfDay?,
      calculate: freezed == calculate
          ? _value.calculate
          : calculate // ignore: cast_nullable_to_non_nullable
              as ParcelCalculateResponse?,
      types: null == types
          ? _value.types
          : types // ignore: cast_nullable_to_non_nullable
              as List<TypeModel?>,
      selectType: null == selectType
          ? _value.selectType
          : selectType // ignore: cast_nullable_to_non_nullable
              as int,
      expand: null == expand
          ? _value.expand
          : expand // ignore: cast_nullable_to_non_nullable
              as bool,
      anonymous: null == anonymous
          ? _value.anonymous
          : anonymous // ignore: cast_nullable_to_non_nullable
              as bool,
      parcel: freezed == parcel
          ? _value.parcel
          : parcel // ignore: cast_nullable_to_non_nullable
              as ParcelOrder?,
      selectPayment: freezed == selectPayment
          ? _value.selectPayment
          : selectPayment // ignore: cast_nullable_to_non_nullable
              as PaymentData?,
      markers: null == markers
          ? _value.markers
          : markers // ignore: cast_nullable_to_non_nullable
              as Map<MarkerId, Marker>,
      polylineCoordinates: null == polylineCoordinates
          ? _value.polylineCoordinates
          : polylineCoordinates // ignore: cast_nullable_to_non_nullable
              as List<LatLng>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ParcelStateImplCopyWith<$Res>
    implements $ParcelStateCopyWith<$Res> {
  factory _$$ParcelStateImplCopyWith(
          _$ParcelStateImpl value, $Res Function(_$ParcelStateImpl) then) =
      __$$ParcelStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      bool isButtonLoading,
      bool isMapLoading,
      bool error,
      LocationModel? locationFrom,
      LocationModel? locationTo,
      String? addressTo,
      String? addressFrom,
      TimeOfDay? time,
      ParcelCalculateResponse? calculate,
      List<TypeModel?> types,
      int selectType,
      bool expand,
      bool anonymous,
      ParcelOrder? parcel,
      PaymentData? selectPayment,
      Map<MarkerId, Marker> markers,
      List<LatLng> polylineCoordinates});
}

/// @nodoc
class __$$ParcelStateImplCopyWithImpl<$Res>
    extends _$ParcelStateCopyWithImpl<$Res, _$ParcelStateImpl>
    implements _$$ParcelStateImplCopyWith<$Res> {
  __$$ParcelStateImplCopyWithImpl(
      _$ParcelStateImpl _value, $Res Function(_$ParcelStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isButtonLoading = null,
    Object? isMapLoading = null,
    Object? error = null,
    Object? locationFrom = freezed,
    Object? locationTo = freezed,
    Object? addressTo = freezed,
    Object? addressFrom = freezed,
    Object? time = freezed,
    Object? calculate = freezed,
    Object? types = null,
    Object? selectType = null,
    Object? expand = null,
    Object? anonymous = null,
    Object? parcel = freezed,
    Object? selectPayment = freezed,
    Object? markers = null,
    Object? polylineCoordinates = null,
  }) {
    return _then(_$ParcelStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isButtonLoading: null == isButtonLoading
          ? _value.isButtonLoading
          : isButtonLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isMapLoading: null == isMapLoading
          ? _value.isMapLoading
          : isMapLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as bool,
      locationFrom: freezed == locationFrom
          ? _value.locationFrom
          : locationFrom // ignore: cast_nullable_to_non_nullable
              as LocationModel?,
      locationTo: freezed == locationTo
          ? _value.locationTo
          : locationTo // ignore: cast_nullable_to_non_nullable
              as LocationModel?,
      addressTo: freezed == addressTo
          ? _value.addressTo
          : addressTo // ignore: cast_nullable_to_non_nullable
              as String?,
      addressFrom: freezed == addressFrom
          ? _value.addressFrom
          : addressFrom // ignore: cast_nullable_to_non_nullable
              as String?,
      time: freezed == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as TimeOfDay?,
      calculate: freezed == calculate
          ? _value.calculate
          : calculate // ignore: cast_nullable_to_non_nullable
              as ParcelCalculateResponse?,
      types: null == types
          ? _value._types
          : types // ignore: cast_nullable_to_non_nullable
              as List<TypeModel?>,
      selectType: null == selectType
          ? _value.selectType
          : selectType // ignore: cast_nullable_to_non_nullable
              as int,
      expand: null == expand
          ? _value.expand
          : expand // ignore: cast_nullable_to_non_nullable
              as bool,
      anonymous: null == anonymous
          ? _value.anonymous
          : anonymous // ignore: cast_nullable_to_non_nullable
              as bool,
      parcel: freezed == parcel
          ? _value.parcel
          : parcel // ignore: cast_nullable_to_non_nullable
              as ParcelOrder?,
      selectPayment: freezed == selectPayment
          ? _value.selectPayment
          : selectPayment // ignore: cast_nullable_to_non_nullable
              as PaymentData?,
      markers: null == markers
          ? _value._markers
          : markers // ignore: cast_nullable_to_non_nullable
              as Map<MarkerId, Marker>,
      polylineCoordinates: null == polylineCoordinates
          ? _value._polylineCoordinates
          : polylineCoordinates // ignore: cast_nullable_to_non_nullable
              as List<LatLng>,
    ));
  }
}

/// @nodoc

class _$ParcelStateImpl extends _ParcelState {
  const _$ParcelStateImpl(
      {this.isLoading = false,
      this.isButtonLoading = false,
      this.isMapLoading = false,
      this.error = false,
      this.locationFrom = null,
      this.locationTo = null,
      this.addressTo = null,
      this.addressFrom = null,
      this.time = null,
      this.calculate = null,
      final List<TypeModel?> types = const [],
      this.selectType = 0,
      this.expand = false,
      this.anonymous = false,
      this.parcel = null,
      this.selectPayment = null,
      final Map<MarkerId, Marker> markers = const {},
      final List<LatLng> polylineCoordinates = const []})
      : _types = types,
        _markers = markers,
        _polylineCoordinates = polylineCoordinates,
        super._();

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isButtonLoading;
  @override
  @JsonKey()
  final bool isMapLoading;
  @override
  @JsonKey()
  final bool error;
  @override
  @JsonKey()
  final LocationModel? locationFrom;
  @override
  @JsonKey()
  final LocationModel? locationTo;
  @override
  @JsonKey()
  final String? addressTo;
  @override
  @JsonKey()
  final String? addressFrom;
  @override
  @JsonKey()
  final TimeOfDay? time;
  @override
  @JsonKey()
  final ParcelCalculateResponse? calculate;
  final List<TypeModel?> _types;
  @override
  @JsonKey()
  List<TypeModel?> get types {
    if (_types is EqualUnmodifiableListView) return _types;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_types);
  }

  @override
  @JsonKey()
  final int selectType;
  @override
  @JsonKey()
  final bool expand;
  @override
  @JsonKey()
  final bool anonymous;
  @override
  @JsonKey()
  final ParcelOrder? parcel;
  @override
  @JsonKey()
  final PaymentData? selectPayment;
  final Map<MarkerId, Marker> _markers;
  @override
  @JsonKey()
  Map<MarkerId, Marker> get markers {
    if (_markers is EqualUnmodifiableMapView) return _markers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_markers);
  }

  final List<LatLng> _polylineCoordinates;
  @override
  @JsonKey()
  List<LatLng> get polylineCoordinates {
    if (_polylineCoordinates is EqualUnmodifiableListView)
      return _polylineCoordinates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_polylineCoordinates);
  }

  @override
  String toString() {
    return 'ParcelState(isLoading: $isLoading, isButtonLoading: $isButtonLoading, isMapLoading: $isMapLoading, error: $error, locationFrom: $locationFrom, locationTo: $locationTo, addressTo: $addressTo, addressFrom: $addressFrom, time: $time, calculate: $calculate, types: $types, selectType: $selectType, expand: $expand, anonymous: $anonymous, parcel: $parcel, selectPayment: $selectPayment, markers: $markers, polylineCoordinates: $polylineCoordinates)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParcelStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isButtonLoading, isButtonLoading) ||
                other.isButtonLoading == isButtonLoading) &&
            (identical(other.isMapLoading, isMapLoading) ||
                other.isMapLoading == isMapLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.locationFrom, locationFrom) ||
                other.locationFrom == locationFrom) &&
            (identical(other.locationTo, locationTo) ||
                other.locationTo == locationTo) &&
            (identical(other.addressTo, addressTo) ||
                other.addressTo == addressTo) &&
            (identical(other.addressFrom, addressFrom) ||
                other.addressFrom == addressFrom) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.calculate, calculate) ||
                other.calculate == calculate) &&
            const DeepCollectionEquality().equals(other._types, _types) &&
            (identical(other.selectType, selectType) ||
                other.selectType == selectType) &&
            (identical(other.expand, expand) || other.expand == expand) &&
            (identical(other.anonymous, anonymous) ||
                other.anonymous == anonymous) &&
            (identical(other.parcel, parcel) || other.parcel == parcel) &&
            (identical(other.selectPayment, selectPayment) ||
                other.selectPayment == selectPayment) &&
            const DeepCollectionEquality().equals(other._markers, _markers) &&
            const DeepCollectionEquality()
                .equals(other._polylineCoordinates, _polylineCoordinates));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      isButtonLoading,
      isMapLoading,
      error,
      locationFrom,
      locationTo,
      addressTo,
      addressFrom,
      time,
      calculate,
      const DeepCollectionEquality().hash(_types),
      selectType,
      expand,
      anonymous,
      parcel,
      selectPayment,
      const DeepCollectionEquality().hash(_markers),
      const DeepCollectionEquality().hash(_polylineCoordinates));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ParcelStateImplCopyWith<_$ParcelStateImpl> get copyWith =>
      __$$ParcelStateImplCopyWithImpl<_$ParcelStateImpl>(this, _$identity);
}

abstract class _ParcelState extends ParcelState {
  const factory _ParcelState(
      {final bool isLoading,
      final bool isButtonLoading,
      final bool isMapLoading,
      final bool error,
      final LocationModel? locationFrom,
      final LocationModel? locationTo,
      final String? addressTo,
      final String? addressFrom,
      final TimeOfDay? time,
      final ParcelCalculateResponse? calculate,
      final List<TypeModel?> types,
      final int selectType,
      final bool expand,
      final bool anonymous,
      final ParcelOrder? parcel,
      final PaymentData? selectPayment,
      final Map<MarkerId, Marker> markers,
      final List<LatLng> polylineCoordinates}) = _$ParcelStateImpl;
  const _ParcelState._() : super._();

  @override
  bool get isLoading;
  @override
  bool get isButtonLoading;
  @override
  bool get isMapLoading;
  @override
  bool get error;
  @override
  LocationModel? get locationFrom;
  @override
  LocationModel? get locationTo;
  @override
  String? get addressTo;
  @override
  String? get addressFrom;
  @override
  TimeOfDay? get time;
  @override
  ParcelCalculateResponse? get calculate;
  @override
  List<TypeModel?> get types;
  @override
  int get selectType;
  @override
  bool get expand;
  @override
  bool get anonymous;
  @override
  ParcelOrder? get parcel;
  @override
  PaymentData? get selectPayment;
  @override
  Map<MarkerId, Marker> get markers;
  @override
  List<LatLng> get polylineCoordinates;
  @override
  @JsonKey(ignore: true)
  _$$ParcelStateImplCopyWith<_$ParcelStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
