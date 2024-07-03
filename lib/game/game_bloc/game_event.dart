part of 'game_bloc.dart';

@freezed
abstract class GameEvent with _$GameEvent {
  const factory GameEvent.init() = Init;

  const factory GameEvent.newGame() = NewGame;

  const factory GameEvent.move({
    required SwipeDirection direction,
    required VoidCallback onSuccess,
    required VoidCallback onFail,
  }) = Move;

  const factory GameEvent.merge() = Merge;

  const factory GameEvent.undo() = Undo;

  const factory GameEvent.onKey({
    required KeyEvent event,
    required VoidCallback onSuccess,
    required VoidCallback onFail,
  }) = OnKey;

  const factory GameEvent.endRound({
    required VoidCallback onSuccess,
    required VoidCallback onFail,
  }) = EndRound;

  const factory GameEvent.save() = Save;

  const factory GameEvent.queue(SwipeDirection direction) = Queue;

  const factory GameEvent.clear() = Clear;

  const factory GameEvent.changePosition(bool value) = ChangePosition;
}
