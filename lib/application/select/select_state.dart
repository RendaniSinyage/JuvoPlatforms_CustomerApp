// ignore_for_file: depend_on_referenced_packages

import 'package:freezed_annotation/freezed_annotation.dart';

part 'select_state.freezed.dart';

@freezed
class SelectState with _$SelectState {
  const factory SelectState({
    @Default(0) int selectedIndex,
  }) = _SelectState;

  const SelectState._();
}
