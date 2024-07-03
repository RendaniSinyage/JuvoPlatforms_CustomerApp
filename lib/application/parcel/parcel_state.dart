import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpodtemp/infrastructure/models/models.dart';

part 'parcel_state.freezed.dart';

@freezed
class ParcelState with _$ParcelState {
  const factory ParcelState({
    @Default(false) bool isLoading,
    @Default(false) bool isButtonLoading,
    @Default(false) bool isMapLoading,
    @Default(false) bool error,
    @Default(null) LocationModel? locationFrom,
    @Default(null) LocationModel? locationTo,
    @Default(null) String? addressTo,
    @Default(null) String? addressFrom,
    @Default(null) TimeOfDay? time,
    @Default(null) ParcelCalculateResponse? calculate,
    @Default([]) List<TypeModel?> types,
    @Default(0) int selectType,
    @Default(false) bool expand,
    @Default(false) bool anonymous,
    @Default(null) ParcelOrder? parcel,
    @Default(null) PaymentData? selectPayment,
    @Default({}) Map<MarkerId, Marker> markers,
    @Default([]) List<LatLng> polylineCoordinates,
  }) = _ParcelState;

  const ParcelState._();
}
