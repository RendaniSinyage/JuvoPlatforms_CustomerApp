import 'package:freezed_annotation/freezed_annotation.dart';

part 'intro_state.freezed.dart';

@freezed
class IntroState with _$IntroState {
  const factory IntroState({@Default(0) int currentIndex}) = _IntroState;

  const IntroState._();
}
