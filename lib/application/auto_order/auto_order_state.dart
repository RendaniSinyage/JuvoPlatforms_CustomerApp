// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auto_order_state.freezed.dart';

@freezed
class AutoOrderState with _$AutoOrderState {
  const factory AutoOrderState({
    required DateTime from,
    required DateTime to,
    TimeOfDay? time,
    @Default(false) isError,
  }) = _AutoOrderState;

  const AutoOrderState._();
}
