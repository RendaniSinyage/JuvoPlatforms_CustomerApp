import 'package:freezed_annotation/freezed_annotation.dart';

part 'closed_state.freezed.dart';

@freezed
class ClosedState with _$ClosedState {
  const factory ClosedState({@Default(0) int currentIndex}) = _ClosedState;

  const ClosedState._();
}
