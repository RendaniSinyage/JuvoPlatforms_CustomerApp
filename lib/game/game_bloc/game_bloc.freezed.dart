// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GameEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() newGame,
    required TResult Function(SwipeDirection direction, VoidCallback onSuccess,
            VoidCallback onFail)
        move,
    required TResult Function() merge,
    required TResult Function() undo,
    required TResult Function(
            KeyEvent event, VoidCallback onSuccess, VoidCallback onFail)
        onKey,
    required TResult Function(VoidCallback onSuccess, VoidCallback onFail)
        endRound,
    required TResult Function() save,
    required TResult Function(SwipeDirection direction) queue,
    required TResult Function() clear,
    required TResult Function(bool value) changePosition,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? newGame,
    TResult? Function(SwipeDirection direction, VoidCallback onSuccess,
            VoidCallback onFail)?
        move,
    TResult? Function()? merge,
    TResult? Function()? undo,
    TResult? Function(
            KeyEvent event, VoidCallback onSuccess, VoidCallback onFail)?
        onKey,
    TResult? Function(VoidCallback onSuccess, VoidCallback onFail)? endRound,
    TResult? Function()? save,
    TResult? Function(SwipeDirection direction)? queue,
    TResult? Function()? clear,
    TResult? Function(bool value)? changePosition,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? newGame,
    TResult Function(SwipeDirection direction, VoidCallback onSuccess,
            VoidCallback onFail)?
        move,
    TResult Function()? merge,
    TResult Function()? undo,
    TResult Function(
            KeyEvent event, VoidCallback onSuccess, VoidCallback onFail)?
        onKey,
    TResult Function(VoidCallback onSuccess, VoidCallback onFail)? endRound,
    TResult Function()? save,
    TResult Function(SwipeDirection direction)? queue,
    TResult Function()? clear,
    TResult Function(bool value)? changePosition,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Init value) init,
    required TResult Function(NewGame value) newGame,
    required TResult Function(Move value) move,
    required TResult Function(Merge value) merge,
    required TResult Function(Undo value) undo,
    required TResult Function(OnKey value) onKey,
    required TResult Function(EndRound value) endRound,
    required TResult Function(Save value) save,
    required TResult Function(Queue value) queue,
    required TResult Function(Clear value) clear,
    required TResult Function(ChangePosition value) changePosition,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Init value)? init,
    TResult? Function(NewGame value)? newGame,
    TResult? Function(Move value)? move,
    TResult? Function(Merge value)? merge,
    TResult? Function(Undo value)? undo,
    TResult? Function(OnKey value)? onKey,
    TResult? Function(EndRound value)? endRound,
    TResult? Function(Save value)? save,
    TResult? Function(Queue value)? queue,
    TResult? Function(Clear value)? clear,
    TResult? Function(ChangePosition value)? changePosition,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Init value)? init,
    TResult Function(NewGame value)? newGame,
    TResult Function(Move value)? move,
    TResult Function(Merge value)? merge,
    TResult Function(Undo value)? undo,
    TResult Function(OnKey value)? onKey,
    TResult Function(EndRound value)? endRound,
    TResult Function(Save value)? save,
    TResult Function(Queue value)? queue,
    TResult Function(Clear value)? clear,
    TResult Function(ChangePosition value)? changePosition,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameEventCopyWith<$Res> {
  factory $GameEventCopyWith(GameEvent value, $Res Function(GameEvent) then) =
      _$GameEventCopyWithImpl<$Res, GameEvent>;
}

/// @nodoc
class _$GameEventCopyWithImpl<$Res, $Val extends GameEvent>
    implements $GameEventCopyWith<$Res> {
  _$GameEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$InitImplCopyWith<$Res> {
  factory _$$InitImplCopyWith(
          _$InitImpl value, $Res Function(_$InitImpl) then) =
      __$$InitImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitImplCopyWithImpl<$Res>
    extends _$GameEventCopyWithImpl<$Res, _$InitImpl>
    implements _$$InitImplCopyWith<$Res> {
  __$$InitImplCopyWithImpl(_$InitImpl _value, $Res Function(_$InitImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$InitImpl implements Init {
  const _$InitImpl();

  @override
  String toString() {
    return 'GameEvent.init()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() newGame,
    required TResult Function(SwipeDirection direction, VoidCallback onSuccess,
            VoidCallback onFail)
        move,
    required TResult Function() merge,
    required TResult Function() undo,
    required TResult Function(
            KeyEvent event, VoidCallback onSuccess, VoidCallback onFail)
        onKey,
    required TResult Function(VoidCallback onSuccess, VoidCallback onFail)
        endRound,
    required TResult Function() save,
    required TResult Function(SwipeDirection direction) queue,
    required TResult Function() clear,
    required TResult Function(bool value) changePosition,
  }) {
    return init();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? newGame,
    TResult? Function(SwipeDirection direction, VoidCallback onSuccess,
            VoidCallback onFail)?
        move,
    TResult? Function()? merge,
    TResult? Function()? undo,
    TResult? Function(
            KeyEvent event, VoidCallback onSuccess, VoidCallback onFail)?
        onKey,
    TResult? Function(VoidCallback onSuccess, VoidCallback onFail)? endRound,
    TResult? Function()? save,
    TResult? Function(SwipeDirection direction)? queue,
    TResult? Function()? clear,
    TResult? Function(bool value)? changePosition,
  }) {
    return init?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? newGame,
    TResult Function(SwipeDirection direction, VoidCallback onSuccess,
            VoidCallback onFail)?
        move,
    TResult Function()? merge,
    TResult Function()? undo,
    TResult Function(
            KeyEvent event, VoidCallback onSuccess, VoidCallback onFail)?
        onKey,
    TResult Function(VoidCallback onSuccess, VoidCallback onFail)? endRound,
    TResult Function()? save,
    TResult Function(SwipeDirection direction)? queue,
    TResult Function()? clear,
    TResult Function(bool value)? changePosition,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Init value) init,
    required TResult Function(NewGame value) newGame,
    required TResult Function(Move value) move,
    required TResult Function(Merge value) merge,
    required TResult Function(Undo value) undo,
    required TResult Function(OnKey value) onKey,
    required TResult Function(EndRound value) endRound,
    required TResult Function(Save value) save,
    required TResult Function(Queue value) queue,
    required TResult Function(Clear value) clear,
    required TResult Function(ChangePosition value) changePosition,
  }) {
    return init(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Init value)? init,
    TResult? Function(NewGame value)? newGame,
    TResult? Function(Move value)? move,
    TResult? Function(Merge value)? merge,
    TResult? Function(Undo value)? undo,
    TResult? Function(OnKey value)? onKey,
    TResult? Function(EndRound value)? endRound,
    TResult? Function(Save value)? save,
    TResult? Function(Queue value)? queue,
    TResult? Function(Clear value)? clear,
    TResult? Function(ChangePosition value)? changePosition,
  }) {
    return init?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Init value)? init,
    TResult Function(NewGame value)? newGame,
    TResult Function(Move value)? move,
    TResult Function(Merge value)? merge,
    TResult Function(Undo value)? undo,
    TResult Function(OnKey value)? onKey,
    TResult Function(EndRound value)? endRound,
    TResult Function(Save value)? save,
    TResult Function(Queue value)? queue,
    TResult Function(Clear value)? clear,
    TResult Function(ChangePosition value)? changePosition,
    required TResult orElse(),
  }) {
    if (init != null) {
      return init(this);
    }
    return orElse();
  }
}

abstract class Init implements GameEvent {
  const factory Init() = _$InitImpl;
}

/// @nodoc
abstract class _$$NewGameImplCopyWith<$Res> {
  factory _$$NewGameImplCopyWith(
          _$NewGameImpl value, $Res Function(_$NewGameImpl) then) =
      __$$NewGameImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NewGameImplCopyWithImpl<$Res>
    extends _$GameEventCopyWithImpl<$Res, _$NewGameImpl>
    implements _$$NewGameImplCopyWith<$Res> {
  __$$NewGameImplCopyWithImpl(
      _$NewGameImpl _value, $Res Function(_$NewGameImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$NewGameImpl implements NewGame {
  const _$NewGameImpl();

  @override
  String toString() {
    return 'GameEvent.newGame()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$NewGameImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() newGame,
    required TResult Function(SwipeDirection direction, VoidCallback onSuccess,
            VoidCallback onFail)
        move,
    required TResult Function() merge,
    required TResult Function() undo,
    required TResult Function(
            KeyEvent event, VoidCallback onSuccess, VoidCallback onFail)
        onKey,
    required TResult Function(VoidCallback onSuccess, VoidCallback onFail)
        endRound,
    required TResult Function() save,
    required TResult Function(SwipeDirection direction) queue,
    required TResult Function() clear,
    required TResult Function(bool value) changePosition,
  }) {
    return newGame();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? newGame,
    TResult? Function(SwipeDirection direction, VoidCallback onSuccess,
            VoidCallback onFail)?
        move,
    TResult? Function()? merge,
    TResult? Function()? undo,
    TResult? Function(
            KeyEvent event, VoidCallback onSuccess, VoidCallback onFail)?
        onKey,
    TResult? Function(VoidCallback onSuccess, VoidCallback onFail)? endRound,
    TResult? Function()? save,
    TResult? Function(SwipeDirection direction)? queue,
    TResult? Function()? clear,
    TResult? Function(bool value)? changePosition,
  }) {
    return newGame?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? newGame,
    TResult Function(SwipeDirection direction, VoidCallback onSuccess,
            VoidCallback onFail)?
        move,
    TResult Function()? merge,
    TResult Function()? undo,
    TResult Function(
            KeyEvent event, VoidCallback onSuccess, VoidCallback onFail)?
        onKey,
    TResult Function(VoidCallback onSuccess, VoidCallback onFail)? endRound,
    TResult Function()? save,
    TResult Function(SwipeDirection direction)? queue,
    TResult Function()? clear,
    TResult Function(bool value)? changePosition,
    required TResult orElse(),
  }) {
    if (newGame != null) {
      return newGame();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Init value) init,
    required TResult Function(NewGame value) newGame,
    required TResult Function(Move value) move,
    required TResult Function(Merge value) merge,
    required TResult Function(Undo value) undo,
    required TResult Function(OnKey value) onKey,
    required TResult Function(EndRound value) endRound,
    required TResult Function(Save value) save,
    required TResult Function(Queue value) queue,
    required TResult Function(Clear value) clear,
    required TResult Function(ChangePosition value) changePosition,
  }) {
    return newGame(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Init value)? init,
    TResult? Function(NewGame value)? newGame,
    TResult? Function(Move value)? move,
    TResult? Function(Merge value)? merge,
    TResult? Function(Undo value)? undo,
    TResult? Function(OnKey value)? onKey,
    TResult? Function(EndRound value)? endRound,
    TResult? Function(Save value)? save,
    TResult? Function(Queue value)? queue,
    TResult? Function(Clear value)? clear,
    TResult? Function(ChangePosition value)? changePosition,
  }) {
    return newGame?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Init value)? init,
    TResult Function(NewGame value)? newGame,
    TResult Function(Move value)? move,
    TResult Function(Merge value)? merge,
    TResult Function(Undo value)? undo,
    TResult Function(OnKey value)? onKey,
    TResult Function(EndRound value)? endRound,
    TResult Function(Save value)? save,
    TResult Function(Queue value)? queue,
    TResult Function(Clear value)? clear,
    TResult Function(ChangePosition value)? changePosition,
    required TResult orElse(),
  }) {
    if (newGame != null) {
      return newGame(this);
    }
    return orElse();
  }
}

abstract class NewGame implements GameEvent {
  const factory NewGame() = _$NewGameImpl;
}

/// @nodoc
abstract class _$$MoveImplCopyWith<$Res> {
  factory _$$MoveImplCopyWith(
          _$MoveImpl value, $Res Function(_$MoveImpl) then) =
      __$$MoveImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {SwipeDirection direction, VoidCallback onSuccess, VoidCallback onFail});
}

/// @nodoc
class __$$MoveImplCopyWithImpl<$Res>
    extends _$GameEventCopyWithImpl<$Res, _$MoveImpl>
    implements _$$MoveImplCopyWith<$Res> {
  __$$MoveImplCopyWithImpl(_$MoveImpl _value, $Res Function(_$MoveImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? direction = null,
    Object? onSuccess = null,
    Object? onFail = null,
  }) {
    return _then(_$MoveImpl(
      direction: null == direction
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as SwipeDirection,
      onSuccess: null == onSuccess
          ? _value.onSuccess
          : onSuccess // ignore: cast_nullable_to_non_nullable
              as VoidCallback,
      onFail: null == onFail
          ? _value.onFail
          : onFail // ignore: cast_nullable_to_non_nullable
              as VoidCallback,
    ));
  }
}

/// @nodoc

class _$MoveImpl implements Move {
  const _$MoveImpl(
      {required this.direction, required this.onSuccess, required this.onFail});

  @override
  final SwipeDirection direction;
  @override
  final VoidCallback onSuccess;
  @override
  final VoidCallback onFail;

  @override
  String toString() {
    return 'GameEvent.move(direction: $direction, onSuccess: $onSuccess, onFail: $onFail)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MoveImpl &&
            (identical(other.direction, direction) ||
                other.direction == direction) &&
            (identical(other.onSuccess, onSuccess) ||
                other.onSuccess == onSuccess) &&
            (identical(other.onFail, onFail) || other.onFail == onFail));
  }

  @override
  int get hashCode => Object.hash(runtimeType, direction, onSuccess, onFail);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MoveImplCopyWith<_$MoveImpl> get copyWith =>
      __$$MoveImplCopyWithImpl<_$MoveImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() newGame,
    required TResult Function(SwipeDirection direction, VoidCallback onSuccess,
            VoidCallback onFail)
        move,
    required TResult Function() merge,
    required TResult Function() undo,
    required TResult Function(
            KeyEvent event, VoidCallback onSuccess, VoidCallback onFail)
        onKey,
    required TResult Function(VoidCallback onSuccess, VoidCallback onFail)
        endRound,
    required TResult Function() save,
    required TResult Function(SwipeDirection direction) queue,
    required TResult Function() clear,
    required TResult Function(bool value) changePosition,
  }) {
    return move(direction, onSuccess, onFail);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? newGame,
    TResult? Function(SwipeDirection direction, VoidCallback onSuccess,
            VoidCallback onFail)?
        move,
    TResult? Function()? merge,
    TResult? Function()? undo,
    TResult? Function(
            KeyEvent event, VoidCallback onSuccess, VoidCallback onFail)?
        onKey,
    TResult? Function(VoidCallback onSuccess, VoidCallback onFail)? endRound,
    TResult? Function()? save,
    TResult? Function(SwipeDirection direction)? queue,
    TResult? Function()? clear,
    TResult? Function(bool value)? changePosition,
  }) {
    return move?.call(direction, onSuccess, onFail);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? newGame,
    TResult Function(SwipeDirection direction, VoidCallback onSuccess,
            VoidCallback onFail)?
        move,
    TResult Function()? merge,
    TResult Function()? undo,
    TResult Function(
            KeyEvent event, VoidCallback onSuccess, VoidCallback onFail)?
        onKey,
    TResult Function(VoidCallback onSuccess, VoidCallback onFail)? endRound,
    TResult Function()? save,
    TResult Function(SwipeDirection direction)? queue,
    TResult Function()? clear,
    TResult Function(bool value)? changePosition,
    required TResult orElse(),
  }) {
    if (move != null) {
      return move(direction, onSuccess, onFail);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Init value) init,
    required TResult Function(NewGame value) newGame,
    required TResult Function(Move value) move,
    required TResult Function(Merge value) merge,
    required TResult Function(Undo value) undo,
    required TResult Function(OnKey value) onKey,
    required TResult Function(EndRound value) endRound,
    required TResult Function(Save value) save,
    required TResult Function(Queue value) queue,
    required TResult Function(Clear value) clear,
    required TResult Function(ChangePosition value) changePosition,
  }) {
    return move(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Init value)? init,
    TResult? Function(NewGame value)? newGame,
    TResult? Function(Move value)? move,
    TResult? Function(Merge value)? merge,
    TResult? Function(Undo value)? undo,
    TResult? Function(OnKey value)? onKey,
    TResult? Function(EndRound value)? endRound,
    TResult? Function(Save value)? save,
    TResult? Function(Queue value)? queue,
    TResult? Function(Clear value)? clear,
    TResult? Function(ChangePosition value)? changePosition,
  }) {
    return move?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Init value)? init,
    TResult Function(NewGame value)? newGame,
    TResult Function(Move value)? move,
    TResult Function(Merge value)? merge,
    TResult Function(Undo value)? undo,
    TResult Function(OnKey value)? onKey,
    TResult Function(EndRound value)? endRound,
    TResult Function(Save value)? save,
    TResult Function(Queue value)? queue,
    TResult Function(Clear value)? clear,
    TResult Function(ChangePosition value)? changePosition,
    required TResult orElse(),
  }) {
    if (move != null) {
      return move(this);
    }
    return orElse();
  }
}

abstract class Move implements GameEvent {
  const factory Move(
      {required final SwipeDirection direction,
      required final VoidCallback onSuccess,
      required final VoidCallback onFail}) = _$MoveImpl;

  SwipeDirection get direction;
  VoidCallback get onSuccess;
  VoidCallback get onFail;
  @JsonKey(ignore: true)
  _$$MoveImplCopyWith<_$MoveImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MergeImplCopyWith<$Res> {
  factory _$$MergeImplCopyWith(
          _$MergeImpl value, $Res Function(_$MergeImpl) then) =
      __$$MergeImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$MergeImplCopyWithImpl<$Res>
    extends _$GameEventCopyWithImpl<$Res, _$MergeImpl>
    implements _$$MergeImplCopyWith<$Res> {
  __$$MergeImplCopyWithImpl(
      _$MergeImpl _value, $Res Function(_$MergeImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$MergeImpl implements Merge {
  const _$MergeImpl();

  @override
  String toString() {
    return 'GameEvent.merge()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$MergeImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() newGame,
    required TResult Function(SwipeDirection direction, VoidCallback onSuccess,
            VoidCallback onFail)
        move,
    required TResult Function() merge,
    required TResult Function() undo,
    required TResult Function(
            KeyEvent event, VoidCallback onSuccess, VoidCallback onFail)
        onKey,
    required TResult Function(VoidCallback onSuccess, VoidCallback onFail)
        endRound,
    required TResult Function() save,
    required TResult Function(SwipeDirection direction) queue,
    required TResult Function() clear,
    required TResult Function(bool value) changePosition,
  }) {
    return merge();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? newGame,
    TResult? Function(SwipeDirection direction, VoidCallback onSuccess,
            VoidCallback onFail)?
        move,
    TResult? Function()? merge,
    TResult? Function()? undo,
    TResult? Function(
            KeyEvent event, VoidCallback onSuccess, VoidCallback onFail)?
        onKey,
    TResult? Function(VoidCallback onSuccess, VoidCallback onFail)? endRound,
    TResult? Function()? save,
    TResult? Function(SwipeDirection direction)? queue,
    TResult? Function()? clear,
    TResult? Function(bool value)? changePosition,
  }) {
    return merge?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? newGame,
    TResult Function(SwipeDirection direction, VoidCallback onSuccess,
            VoidCallback onFail)?
        move,
    TResult Function()? merge,
    TResult Function()? undo,
    TResult Function(
            KeyEvent event, VoidCallback onSuccess, VoidCallback onFail)?
        onKey,
    TResult Function(VoidCallback onSuccess, VoidCallback onFail)? endRound,
    TResult Function()? save,
    TResult Function(SwipeDirection direction)? queue,
    TResult Function()? clear,
    TResult Function(bool value)? changePosition,
    required TResult orElse(),
  }) {
    if (merge != null) {
      return merge();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Init value) init,
    required TResult Function(NewGame value) newGame,
    required TResult Function(Move value) move,
    required TResult Function(Merge value) merge,
    required TResult Function(Undo value) undo,
    required TResult Function(OnKey value) onKey,
    required TResult Function(EndRound value) endRound,
    required TResult Function(Save value) save,
    required TResult Function(Queue value) queue,
    required TResult Function(Clear value) clear,
    required TResult Function(ChangePosition value) changePosition,
  }) {
    return merge(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Init value)? init,
    TResult? Function(NewGame value)? newGame,
    TResult? Function(Move value)? move,
    TResult? Function(Merge value)? merge,
    TResult? Function(Undo value)? undo,
    TResult? Function(OnKey value)? onKey,
    TResult? Function(EndRound value)? endRound,
    TResult? Function(Save value)? save,
    TResult? Function(Queue value)? queue,
    TResult? Function(Clear value)? clear,
    TResult? Function(ChangePosition value)? changePosition,
  }) {
    return merge?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Init value)? init,
    TResult Function(NewGame value)? newGame,
    TResult Function(Move value)? move,
    TResult Function(Merge value)? merge,
    TResult Function(Undo value)? undo,
    TResult Function(OnKey value)? onKey,
    TResult Function(EndRound value)? endRound,
    TResult Function(Save value)? save,
    TResult Function(Queue value)? queue,
    TResult Function(Clear value)? clear,
    TResult Function(ChangePosition value)? changePosition,
    required TResult orElse(),
  }) {
    if (merge != null) {
      return merge(this);
    }
    return orElse();
  }
}

abstract class Merge implements GameEvent {
  const factory Merge() = _$MergeImpl;
}

/// @nodoc
abstract class _$$UndoImplCopyWith<$Res> {
  factory _$$UndoImplCopyWith(
          _$UndoImpl value, $Res Function(_$UndoImpl) then) =
      __$$UndoImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UndoImplCopyWithImpl<$Res>
    extends _$GameEventCopyWithImpl<$Res, _$UndoImpl>
    implements _$$UndoImplCopyWith<$Res> {
  __$$UndoImplCopyWithImpl(_$UndoImpl _value, $Res Function(_$UndoImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$UndoImpl implements Undo {
  const _$UndoImpl();

  @override
  String toString() {
    return 'GameEvent.undo()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UndoImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() newGame,
    required TResult Function(SwipeDirection direction, VoidCallback onSuccess,
            VoidCallback onFail)
        move,
    required TResult Function() merge,
    required TResult Function() undo,
    required TResult Function(
            KeyEvent event, VoidCallback onSuccess, VoidCallback onFail)
        onKey,
    required TResult Function(VoidCallback onSuccess, VoidCallback onFail)
        endRound,
    required TResult Function() save,
    required TResult Function(SwipeDirection direction) queue,
    required TResult Function() clear,
    required TResult Function(bool value) changePosition,
  }) {
    return undo();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? newGame,
    TResult? Function(SwipeDirection direction, VoidCallback onSuccess,
            VoidCallback onFail)?
        move,
    TResult? Function()? merge,
    TResult? Function()? undo,
    TResult? Function(
            KeyEvent event, VoidCallback onSuccess, VoidCallback onFail)?
        onKey,
    TResult? Function(VoidCallback onSuccess, VoidCallback onFail)? endRound,
    TResult? Function()? save,
    TResult? Function(SwipeDirection direction)? queue,
    TResult? Function()? clear,
    TResult? Function(bool value)? changePosition,
  }) {
    return undo?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? newGame,
    TResult Function(SwipeDirection direction, VoidCallback onSuccess,
            VoidCallback onFail)?
        move,
    TResult Function()? merge,
    TResult Function()? undo,
    TResult Function(
            KeyEvent event, VoidCallback onSuccess, VoidCallback onFail)?
        onKey,
    TResult Function(VoidCallback onSuccess, VoidCallback onFail)? endRound,
    TResult Function()? save,
    TResult Function(SwipeDirection direction)? queue,
    TResult Function()? clear,
    TResult Function(bool value)? changePosition,
    required TResult orElse(),
  }) {
    if (undo != null) {
      return undo();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Init value) init,
    required TResult Function(NewGame value) newGame,
    required TResult Function(Move value) move,
    required TResult Function(Merge value) merge,
    required TResult Function(Undo value) undo,
    required TResult Function(OnKey value) onKey,
    required TResult Function(EndRound value) endRound,
    required TResult Function(Save value) save,
    required TResult Function(Queue value) queue,
    required TResult Function(Clear value) clear,
    required TResult Function(ChangePosition value) changePosition,
  }) {
    return undo(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Init value)? init,
    TResult? Function(NewGame value)? newGame,
    TResult? Function(Move value)? move,
    TResult? Function(Merge value)? merge,
    TResult? Function(Undo value)? undo,
    TResult? Function(OnKey value)? onKey,
    TResult? Function(EndRound value)? endRound,
    TResult? Function(Save value)? save,
    TResult? Function(Queue value)? queue,
    TResult? Function(Clear value)? clear,
    TResult? Function(ChangePosition value)? changePosition,
  }) {
    return undo?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Init value)? init,
    TResult Function(NewGame value)? newGame,
    TResult Function(Move value)? move,
    TResult Function(Merge value)? merge,
    TResult Function(Undo value)? undo,
    TResult Function(OnKey value)? onKey,
    TResult Function(EndRound value)? endRound,
    TResult Function(Save value)? save,
    TResult Function(Queue value)? queue,
    TResult Function(Clear value)? clear,
    TResult Function(ChangePosition value)? changePosition,
    required TResult orElse(),
  }) {
    if (undo != null) {
      return undo(this);
    }
    return orElse();
  }
}

abstract class Undo implements GameEvent {
  const factory Undo() = _$UndoImpl;
}

/// @nodoc
abstract class _$$OnKeyImplCopyWith<$Res> {
  factory _$$OnKeyImplCopyWith(
          _$OnKeyImpl value, $Res Function(_$OnKeyImpl) then) =
      __$$OnKeyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({KeyEvent event, VoidCallback onSuccess, VoidCallback onFail});
}

/// @nodoc
class __$$OnKeyImplCopyWithImpl<$Res>
    extends _$GameEventCopyWithImpl<$Res, _$OnKeyImpl>
    implements _$$OnKeyImplCopyWith<$Res> {
  __$$OnKeyImplCopyWithImpl(
      _$OnKeyImpl _value, $Res Function(_$OnKeyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event = null,
    Object? onSuccess = null,
    Object? onFail = null,
  }) {
    return _then(_$OnKeyImpl(
      event: null == event
          ? _value.event
          : event // ignore: cast_nullable_to_non_nullable
              as KeyEvent,
      onSuccess: null == onSuccess
          ? _value.onSuccess
          : onSuccess // ignore: cast_nullable_to_non_nullable
              as VoidCallback,
      onFail: null == onFail
          ? _value.onFail
          : onFail // ignore: cast_nullable_to_non_nullable
              as VoidCallback,
    ));
  }
}

/// @nodoc

class _$OnKeyImpl implements OnKey {
  const _$OnKeyImpl(
      {required this.event, required this.onSuccess, required this.onFail});

  @override
  final KeyEvent event;
  @override
  final VoidCallback onSuccess;
  @override
  final VoidCallback onFail;

  @override
  String toString() {
    return 'GameEvent.onKey(event: $event, onSuccess: $onSuccess, onFail: $onFail)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnKeyImpl &&
            (identical(other.event, event) || other.event == event) &&
            (identical(other.onSuccess, onSuccess) ||
                other.onSuccess == onSuccess) &&
            (identical(other.onFail, onFail) || other.onFail == onFail));
  }

  @override
  int get hashCode => Object.hash(runtimeType, event, onSuccess, onFail);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OnKeyImplCopyWith<_$OnKeyImpl> get copyWith =>
      __$$OnKeyImplCopyWithImpl<_$OnKeyImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() newGame,
    required TResult Function(SwipeDirection direction, VoidCallback onSuccess,
            VoidCallback onFail)
        move,
    required TResult Function() merge,
    required TResult Function() undo,
    required TResult Function(
            KeyEvent event, VoidCallback onSuccess, VoidCallback onFail)
        onKey,
    required TResult Function(VoidCallback onSuccess, VoidCallback onFail)
        endRound,
    required TResult Function() save,
    required TResult Function(SwipeDirection direction) queue,
    required TResult Function() clear,
    required TResult Function(bool value) changePosition,
  }) {
    return onKey(event, onSuccess, onFail);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? newGame,
    TResult? Function(SwipeDirection direction, VoidCallback onSuccess,
            VoidCallback onFail)?
        move,
    TResult? Function()? merge,
    TResult? Function()? undo,
    TResult? Function(
            KeyEvent event, VoidCallback onSuccess, VoidCallback onFail)?
        onKey,
    TResult? Function(VoidCallback onSuccess, VoidCallback onFail)? endRound,
    TResult? Function()? save,
    TResult? Function(SwipeDirection direction)? queue,
    TResult? Function()? clear,
    TResult? Function(bool value)? changePosition,
  }) {
    return onKey?.call(event, onSuccess, onFail);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? newGame,
    TResult Function(SwipeDirection direction, VoidCallback onSuccess,
            VoidCallback onFail)?
        move,
    TResult Function()? merge,
    TResult Function()? undo,
    TResult Function(
            KeyEvent event, VoidCallback onSuccess, VoidCallback onFail)?
        onKey,
    TResult Function(VoidCallback onSuccess, VoidCallback onFail)? endRound,
    TResult Function()? save,
    TResult Function(SwipeDirection direction)? queue,
    TResult Function()? clear,
    TResult Function(bool value)? changePosition,
    required TResult orElse(),
  }) {
    if (onKey != null) {
      return onKey(event, onSuccess, onFail);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Init value) init,
    required TResult Function(NewGame value) newGame,
    required TResult Function(Move value) move,
    required TResult Function(Merge value) merge,
    required TResult Function(Undo value) undo,
    required TResult Function(OnKey value) onKey,
    required TResult Function(EndRound value) endRound,
    required TResult Function(Save value) save,
    required TResult Function(Queue value) queue,
    required TResult Function(Clear value) clear,
    required TResult Function(ChangePosition value) changePosition,
  }) {
    return onKey(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Init value)? init,
    TResult? Function(NewGame value)? newGame,
    TResult? Function(Move value)? move,
    TResult? Function(Merge value)? merge,
    TResult? Function(Undo value)? undo,
    TResult? Function(OnKey value)? onKey,
    TResult? Function(EndRound value)? endRound,
    TResult? Function(Save value)? save,
    TResult? Function(Queue value)? queue,
    TResult? Function(Clear value)? clear,
    TResult? Function(ChangePosition value)? changePosition,
  }) {
    return onKey?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Init value)? init,
    TResult Function(NewGame value)? newGame,
    TResult Function(Move value)? move,
    TResult Function(Merge value)? merge,
    TResult Function(Undo value)? undo,
    TResult Function(OnKey value)? onKey,
    TResult Function(EndRound value)? endRound,
    TResult Function(Save value)? save,
    TResult Function(Queue value)? queue,
    TResult Function(Clear value)? clear,
    TResult Function(ChangePosition value)? changePosition,
    required TResult orElse(),
  }) {
    if (onKey != null) {
      return onKey(this);
    }
    return orElse();
  }
}

abstract class OnKey implements GameEvent {
  const factory OnKey(
      {required final KeyEvent event,
      required final VoidCallback onSuccess,
      required final VoidCallback onFail}) = _$OnKeyImpl;

  KeyEvent get event;
  VoidCallback get onSuccess;
  VoidCallback get onFail;
  @JsonKey(ignore: true)
  _$$OnKeyImplCopyWith<_$OnKeyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$EndRoundImplCopyWith<$Res> {
  factory _$$EndRoundImplCopyWith(
          _$EndRoundImpl value, $Res Function(_$EndRoundImpl) then) =
      __$$EndRoundImplCopyWithImpl<$Res>;
  @useResult
  $Res call({VoidCallback onSuccess, VoidCallback onFail});
}

/// @nodoc
class __$$EndRoundImplCopyWithImpl<$Res>
    extends _$GameEventCopyWithImpl<$Res, _$EndRoundImpl>
    implements _$$EndRoundImplCopyWith<$Res> {
  __$$EndRoundImplCopyWithImpl(
      _$EndRoundImpl _value, $Res Function(_$EndRoundImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? onSuccess = null,
    Object? onFail = null,
  }) {
    return _then(_$EndRoundImpl(
      onSuccess: null == onSuccess
          ? _value.onSuccess
          : onSuccess // ignore: cast_nullable_to_non_nullable
              as VoidCallback,
      onFail: null == onFail
          ? _value.onFail
          : onFail // ignore: cast_nullable_to_non_nullable
              as VoidCallback,
    ));
  }
}

/// @nodoc

class _$EndRoundImpl implements EndRound {
  const _$EndRoundImpl({required this.onSuccess, required this.onFail});

  @override
  final VoidCallback onSuccess;
  @override
  final VoidCallback onFail;

  @override
  String toString() {
    return 'GameEvent.endRound(onSuccess: $onSuccess, onFail: $onFail)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EndRoundImpl &&
            (identical(other.onSuccess, onSuccess) ||
                other.onSuccess == onSuccess) &&
            (identical(other.onFail, onFail) || other.onFail == onFail));
  }

  @override
  int get hashCode => Object.hash(runtimeType, onSuccess, onFail);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EndRoundImplCopyWith<_$EndRoundImpl> get copyWith =>
      __$$EndRoundImplCopyWithImpl<_$EndRoundImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() newGame,
    required TResult Function(SwipeDirection direction, VoidCallback onSuccess,
            VoidCallback onFail)
        move,
    required TResult Function() merge,
    required TResult Function() undo,
    required TResult Function(
            KeyEvent event, VoidCallback onSuccess, VoidCallback onFail)
        onKey,
    required TResult Function(VoidCallback onSuccess, VoidCallback onFail)
        endRound,
    required TResult Function() save,
    required TResult Function(SwipeDirection direction) queue,
    required TResult Function() clear,
    required TResult Function(bool value) changePosition,
  }) {
    return endRound(onSuccess, onFail);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? newGame,
    TResult? Function(SwipeDirection direction, VoidCallback onSuccess,
            VoidCallback onFail)?
        move,
    TResult? Function()? merge,
    TResult? Function()? undo,
    TResult? Function(
            KeyEvent event, VoidCallback onSuccess, VoidCallback onFail)?
        onKey,
    TResult? Function(VoidCallback onSuccess, VoidCallback onFail)? endRound,
    TResult? Function()? save,
    TResult? Function(SwipeDirection direction)? queue,
    TResult? Function()? clear,
    TResult? Function(bool value)? changePosition,
  }) {
    return endRound?.call(onSuccess, onFail);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? newGame,
    TResult Function(SwipeDirection direction, VoidCallback onSuccess,
            VoidCallback onFail)?
        move,
    TResult Function()? merge,
    TResult Function()? undo,
    TResult Function(
            KeyEvent event, VoidCallback onSuccess, VoidCallback onFail)?
        onKey,
    TResult Function(VoidCallback onSuccess, VoidCallback onFail)? endRound,
    TResult Function()? save,
    TResult Function(SwipeDirection direction)? queue,
    TResult Function()? clear,
    TResult Function(bool value)? changePosition,
    required TResult orElse(),
  }) {
    if (endRound != null) {
      return endRound(onSuccess, onFail);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Init value) init,
    required TResult Function(NewGame value) newGame,
    required TResult Function(Move value) move,
    required TResult Function(Merge value) merge,
    required TResult Function(Undo value) undo,
    required TResult Function(OnKey value) onKey,
    required TResult Function(EndRound value) endRound,
    required TResult Function(Save value) save,
    required TResult Function(Queue value) queue,
    required TResult Function(Clear value) clear,
    required TResult Function(ChangePosition value) changePosition,
  }) {
    return endRound(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Init value)? init,
    TResult? Function(NewGame value)? newGame,
    TResult? Function(Move value)? move,
    TResult? Function(Merge value)? merge,
    TResult? Function(Undo value)? undo,
    TResult? Function(OnKey value)? onKey,
    TResult? Function(EndRound value)? endRound,
    TResult? Function(Save value)? save,
    TResult? Function(Queue value)? queue,
    TResult? Function(Clear value)? clear,
    TResult? Function(ChangePosition value)? changePosition,
  }) {
    return endRound?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Init value)? init,
    TResult Function(NewGame value)? newGame,
    TResult Function(Move value)? move,
    TResult Function(Merge value)? merge,
    TResult Function(Undo value)? undo,
    TResult Function(OnKey value)? onKey,
    TResult Function(EndRound value)? endRound,
    TResult Function(Save value)? save,
    TResult Function(Queue value)? queue,
    TResult Function(Clear value)? clear,
    TResult Function(ChangePosition value)? changePosition,
    required TResult orElse(),
  }) {
    if (endRound != null) {
      return endRound(this);
    }
    return orElse();
  }
}

abstract class EndRound implements GameEvent {
  const factory EndRound(
      {required final VoidCallback onSuccess,
      required final VoidCallback onFail}) = _$EndRoundImpl;

  VoidCallback get onSuccess;
  VoidCallback get onFail;
  @JsonKey(ignore: true)
  _$$EndRoundImplCopyWith<_$EndRoundImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SaveImplCopyWith<$Res> {
  factory _$$SaveImplCopyWith(
          _$SaveImpl value, $Res Function(_$SaveImpl) then) =
      __$$SaveImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SaveImplCopyWithImpl<$Res>
    extends _$GameEventCopyWithImpl<$Res, _$SaveImpl>
    implements _$$SaveImplCopyWith<$Res> {
  __$$SaveImplCopyWithImpl(_$SaveImpl _value, $Res Function(_$SaveImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$SaveImpl implements Save {
  const _$SaveImpl();

  @override
  String toString() {
    return 'GameEvent.save()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SaveImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() newGame,
    required TResult Function(SwipeDirection direction, VoidCallback onSuccess,
            VoidCallback onFail)
        move,
    required TResult Function() merge,
    required TResult Function() undo,
    required TResult Function(
            KeyEvent event, VoidCallback onSuccess, VoidCallback onFail)
        onKey,
    required TResult Function(VoidCallback onSuccess, VoidCallback onFail)
        endRound,
    required TResult Function() save,
    required TResult Function(SwipeDirection direction) queue,
    required TResult Function() clear,
    required TResult Function(bool value) changePosition,
  }) {
    return save();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? newGame,
    TResult? Function(SwipeDirection direction, VoidCallback onSuccess,
            VoidCallback onFail)?
        move,
    TResult? Function()? merge,
    TResult? Function()? undo,
    TResult? Function(
            KeyEvent event, VoidCallback onSuccess, VoidCallback onFail)?
        onKey,
    TResult? Function(VoidCallback onSuccess, VoidCallback onFail)? endRound,
    TResult? Function()? save,
    TResult? Function(SwipeDirection direction)? queue,
    TResult? Function()? clear,
    TResult? Function(bool value)? changePosition,
  }) {
    return save?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? newGame,
    TResult Function(SwipeDirection direction, VoidCallback onSuccess,
            VoidCallback onFail)?
        move,
    TResult Function()? merge,
    TResult Function()? undo,
    TResult Function(
            KeyEvent event, VoidCallback onSuccess, VoidCallback onFail)?
        onKey,
    TResult Function(VoidCallback onSuccess, VoidCallback onFail)? endRound,
    TResult Function()? save,
    TResult Function(SwipeDirection direction)? queue,
    TResult Function()? clear,
    TResult Function(bool value)? changePosition,
    required TResult orElse(),
  }) {
    if (save != null) {
      return save();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Init value) init,
    required TResult Function(NewGame value) newGame,
    required TResult Function(Move value) move,
    required TResult Function(Merge value) merge,
    required TResult Function(Undo value) undo,
    required TResult Function(OnKey value) onKey,
    required TResult Function(EndRound value) endRound,
    required TResult Function(Save value) save,
    required TResult Function(Queue value) queue,
    required TResult Function(Clear value) clear,
    required TResult Function(ChangePosition value) changePosition,
  }) {
    return save(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Init value)? init,
    TResult? Function(NewGame value)? newGame,
    TResult? Function(Move value)? move,
    TResult? Function(Merge value)? merge,
    TResult? Function(Undo value)? undo,
    TResult? Function(OnKey value)? onKey,
    TResult? Function(EndRound value)? endRound,
    TResult? Function(Save value)? save,
    TResult? Function(Queue value)? queue,
    TResult? Function(Clear value)? clear,
    TResult? Function(ChangePosition value)? changePosition,
  }) {
    return save?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Init value)? init,
    TResult Function(NewGame value)? newGame,
    TResult Function(Move value)? move,
    TResult Function(Merge value)? merge,
    TResult Function(Undo value)? undo,
    TResult Function(OnKey value)? onKey,
    TResult Function(EndRound value)? endRound,
    TResult Function(Save value)? save,
    TResult Function(Queue value)? queue,
    TResult Function(Clear value)? clear,
    TResult Function(ChangePosition value)? changePosition,
    required TResult orElse(),
  }) {
    if (save != null) {
      return save(this);
    }
    return orElse();
  }
}

abstract class Save implements GameEvent {
  const factory Save() = _$SaveImpl;
}

/// @nodoc
abstract class _$$QueueImplCopyWith<$Res> {
  factory _$$QueueImplCopyWith(
          _$QueueImpl value, $Res Function(_$QueueImpl) then) =
      __$$QueueImplCopyWithImpl<$Res>;
  @useResult
  $Res call({SwipeDirection direction});
}

/// @nodoc
class __$$QueueImplCopyWithImpl<$Res>
    extends _$GameEventCopyWithImpl<$Res, _$QueueImpl>
    implements _$$QueueImplCopyWith<$Res> {
  __$$QueueImplCopyWithImpl(
      _$QueueImpl _value, $Res Function(_$QueueImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? direction = null,
  }) {
    return _then(_$QueueImpl(
      null == direction
          ? _value.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as SwipeDirection,
    ));
  }
}

/// @nodoc

class _$QueueImpl implements Queue {
  const _$QueueImpl(this.direction);

  @override
  final SwipeDirection direction;

  @override
  String toString() {
    return 'GameEvent.queue(direction: $direction)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QueueImpl &&
            (identical(other.direction, direction) ||
                other.direction == direction));
  }

  @override
  int get hashCode => Object.hash(runtimeType, direction);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QueueImplCopyWith<_$QueueImpl> get copyWith =>
      __$$QueueImplCopyWithImpl<_$QueueImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() newGame,
    required TResult Function(SwipeDirection direction, VoidCallback onSuccess,
            VoidCallback onFail)
        move,
    required TResult Function() merge,
    required TResult Function() undo,
    required TResult Function(
            KeyEvent event, VoidCallback onSuccess, VoidCallback onFail)
        onKey,
    required TResult Function(VoidCallback onSuccess, VoidCallback onFail)
        endRound,
    required TResult Function() save,
    required TResult Function(SwipeDirection direction) queue,
    required TResult Function() clear,
    required TResult Function(bool value) changePosition,
  }) {
    return queue(direction);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? newGame,
    TResult? Function(SwipeDirection direction, VoidCallback onSuccess,
            VoidCallback onFail)?
        move,
    TResult? Function()? merge,
    TResult? Function()? undo,
    TResult? Function(
            KeyEvent event, VoidCallback onSuccess, VoidCallback onFail)?
        onKey,
    TResult? Function(VoidCallback onSuccess, VoidCallback onFail)? endRound,
    TResult? Function()? save,
    TResult? Function(SwipeDirection direction)? queue,
    TResult? Function()? clear,
    TResult? Function(bool value)? changePosition,
  }) {
    return queue?.call(direction);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? newGame,
    TResult Function(SwipeDirection direction, VoidCallback onSuccess,
            VoidCallback onFail)?
        move,
    TResult Function()? merge,
    TResult Function()? undo,
    TResult Function(
            KeyEvent event, VoidCallback onSuccess, VoidCallback onFail)?
        onKey,
    TResult Function(VoidCallback onSuccess, VoidCallback onFail)? endRound,
    TResult Function()? save,
    TResult Function(SwipeDirection direction)? queue,
    TResult Function()? clear,
    TResult Function(bool value)? changePosition,
    required TResult orElse(),
  }) {
    if (queue != null) {
      return queue(direction);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Init value) init,
    required TResult Function(NewGame value) newGame,
    required TResult Function(Move value) move,
    required TResult Function(Merge value) merge,
    required TResult Function(Undo value) undo,
    required TResult Function(OnKey value) onKey,
    required TResult Function(EndRound value) endRound,
    required TResult Function(Save value) save,
    required TResult Function(Queue value) queue,
    required TResult Function(Clear value) clear,
    required TResult Function(ChangePosition value) changePosition,
  }) {
    return queue(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Init value)? init,
    TResult? Function(NewGame value)? newGame,
    TResult? Function(Move value)? move,
    TResult? Function(Merge value)? merge,
    TResult? Function(Undo value)? undo,
    TResult? Function(OnKey value)? onKey,
    TResult? Function(EndRound value)? endRound,
    TResult? Function(Save value)? save,
    TResult? Function(Queue value)? queue,
    TResult? Function(Clear value)? clear,
    TResult? Function(ChangePosition value)? changePosition,
  }) {
    return queue?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Init value)? init,
    TResult Function(NewGame value)? newGame,
    TResult Function(Move value)? move,
    TResult Function(Merge value)? merge,
    TResult Function(Undo value)? undo,
    TResult Function(OnKey value)? onKey,
    TResult Function(EndRound value)? endRound,
    TResult Function(Save value)? save,
    TResult Function(Queue value)? queue,
    TResult Function(Clear value)? clear,
    TResult Function(ChangePosition value)? changePosition,
    required TResult orElse(),
  }) {
    if (queue != null) {
      return queue(this);
    }
    return orElse();
  }
}

abstract class Queue implements GameEvent {
  const factory Queue(final SwipeDirection direction) = _$QueueImpl;

  SwipeDirection get direction;
  @JsonKey(ignore: true)
  _$$QueueImplCopyWith<_$QueueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ClearImplCopyWith<$Res> {
  factory _$$ClearImplCopyWith(
          _$ClearImpl value, $Res Function(_$ClearImpl) then) =
      __$$ClearImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ClearImplCopyWithImpl<$Res>
    extends _$GameEventCopyWithImpl<$Res, _$ClearImpl>
    implements _$$ClearImplCopyWith<$Res> {
  __$$ClearImplCopyWithImpl(
      _$ClearImpl _value, $Res Function(_$ClearImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ClearImpl implements Clear {
  const _$ClearImpl();

  @override
  String toString() {
    return 'GameEvent.clear()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ClearImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() newGame,
    required TResult Function(SwipeDirection direction, VoidCallback onSuccess,
            VoidCallback onFail)
        move,
    required TResult Function() merge,
    required TResult Function() undo,
    required TResult Function(
            KeyEvent event, VoidCallback onSuccess, VoidCallback onFail)
        onKey,
    required TResult Function(VoidCallback onSuccess, VoidCallback onFail)
        endRound,
    required TResult Function() save,
    required TResult Function(SwipeDirection direction) queue,
    required TResult Function() clear,
    required TResult Function(bool value) changePosition,
  }) {
    return clear();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? newGame,
    TResult? Function(SwipeDirection direction, VoidCallback onSuccess,
            VoidCallback onFail)?
        move,
    TResult? Function()? merge,
    TResult? Function()? undo,
    TResult? Function(
            KeyEvent event, VoidCallback onSuccess, VoidCallback onFail)?
        onKey,
    TResult? Function(VoidCallback onSuccess, VoidCallback onFail)? endRound,
    TResult? Function()? save,
    TResult? Function(SwipeDirection direction)? queue,
    TResult? Function()? clear,
    TResult? Function(bool value)? changePosition,
  }) {
    return clear?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? newGame,
    TResult Function(SwipeDirection direction, VoidCallback onSuccess,
            VoidCallback onFail)?
        move,
    TResult Function()? merge,
    TResult Function()? undo,
    TResult Function(
            KeyEvent event, VoidCallback onSuccess, VoidCallback onFail)?
        onKey,
    TResult Function(VoidCallback onSuccess, VoidCallback onFail)? endRound,
    TResult Function()? save,
    TResult Function(SwipeDirection direction)? queue,
    TResult Function()? clear,
    TResult Function(bool value)? changePosition,
    required TResult orElse(),
  }) {
    if (clear != null) {
      return clear();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Init value) init,
    required TResult Function(NewGame value) newGame,
    required TResult Function(Move value) move,
    required TResult Function(Merge value) merge,
    required TResult Function(Undo value) undo,
    required TResult Function(OnKey value) onKey,
    required TResult Function(EndRound value) endRound,
    required TResult Function(Save value) save,
    required TResult Function(Queue value) queue,
    required TResult Function(Clear value) clear,
    required TResult Function(ChangePosition value) changePosition,
  }) {
    return clear(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Init value)? init,
    TResult? Function(NewGame value)? newGame,
    TResult? Function(Move value)? move,
    TResult? Function(Merge value)? merge,
    TResult? Function(Undo value)? undo,
    TResult? Function(OnKey value)? onKey,
    TResult? Function(EndRound value)? endRound,
    TResult? Function(Save value)? save,
    TResult? Function(Queue value)? queue,
    TResult? Function(Clear value)? clear,
    TResult? Function(ChangePosition value)? changePosition,
  }) {
    return clear?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Init value)? init,
    TResult Function(NewGame value)? newGame,
    TResult Function(Move value)? move,
    TResult Function(Merge value)? merge,
    TResult Function(Undo value)? undo,
    TResult Function(OnKey value)? onKey,
    TResult Function(EndRound value)? endRound,
    TResult Function(Save value)? save,
    TResult Function(Queue value)? queue,
    TResult Function(Clear value)? clear,
    TResult Function(ChangePosition value)? changePosition,
    required TResult orElse(),
  }) {
    if (clear != null) {
      return clear(this);
    }
    return orElse();
  }
}

abstract class Clear implements GameEvent {
  const factory Clear() = _$ClearImpl;
}

/// @nodoc
abstract class _$$ChangePositionImplCopyWith<$Res> {
  factory _$$ChangePositionImplCopyWith(_$ChangePositionImpl value,
          $Res Function(_$ChangePositionImpl) then) =
      __$$ChangePositionImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool value});
}

/// @nodoc
class __$$ChangePositionImplCopyWithImpl<$Res>
    extends _$GameEventCopyWithImpl<$Res, _$ChangePositionImpl>
    implements _$$ChangePositionImplCopyWith<$Res> {
  __$$ChangePositionImplCopyWithImpl(
      _$ChangePositionImpl _value, $Res Function(_$ChangePositionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$ChangePositionImpl(
      null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$ChangePositionImpl implements ChangePosition {
  const _$ChangePositionImpl(this.value);

  @override
  final bool value;

  @override
  String toString() {
    return 'GameEvent.changePosition(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChangePositionImpl &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChangePositionImplCopyWith<_$ChangePositionImpl> get copyWith =>
      __$$ChangePositionImplCopyWithImpl<_$ChangePositionImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() init,
    required TResult Function() newGame,
    required TResult Function(SwipeDirection direction, VoidCallback onSuccess,
            VoidCallback onFail)
        move,
    required TResult Function() merge,
    required TResult Function() undo,
    required TResult Function(
            KeyEvent event, VoidCallback onSuccess, VoidCallback onFail)
        onKey,
    required TResult Function(VoidCallback onSuccess, VoidCallback onFail)
        endRound,
    required TResult Function() save,
    required TResult Function(SwipeDirection direction) queue,
    required TResult Function() clear,
    required TResult Function(bool value) changePosition,
  }) {
    return changePosition(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? init,
    TResult? Function()? newGame,
    TResult? Function(SwipeDirection direction, VoidCallback onSuccess,
            VoidCallback onFail)?
        move,
    TResult? Function()? merge,
    TResult? Function()? undo,
    TResult? Function(
            KeyEvent event, VoidCallback onSuccess, VoidCallback onFail)?
        onKey,
    TResult? Function(VoidCallback onSuccess, VoidCallback onFail)? endRound,
    TResult? Function()? save,
    TResult? Function(SwipeDirection direction)? queue,
    TResult? Function()? clear,
    TResult? Function(bool value)? changePosition,
  }) {
    return changePosition?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? init,
    TResult Function()? newGame,
    TResult Function(SwipeDirection direction, VoidCallback onSuccess,
            VoidCallback onFail)?
        move,
    TResult Function()? merge,
    TResult Function()? undo,
    TResult Function(
            KeyEvent event, VoidCallback onSuccess, VoidCallback onFail)?
        onKey,
    TResult Function(VoidCallback onSuccess, VoidCallback onFail)? endRound,
    TResult Function()? save,
    TResult Function(SwipeDirection direction)? queue,
    TResult Function()? clear,
    TResult Function(bool value)? changePosition,
    required TResult orElse(),
  }) {
    if (changePosition != null) {
      return changePosition(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Init value) init,
    required TResult Function(NewGame value) newGame,
    required TResult Function(Move value) move,
    required TResult Function(Merge value) merge,
    required TResult Function(Undo value) undo,
    required TResult Function(OnKey value) onKey,
    required TResult Function(EndRound value) endRound,
    required TResult Function(Save value) save,
    required TResult Function(Queue value) queue,
    required TResult Function(Clear value) clear,
    required TResult Function(ChangePosition value) changePosition,
  }) {
    return changePosition(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Init value)? init,
    TResult? Function(NewGame value)? newGame,
    TResult? Function(Move value)? move,
    TResult? Function(Merge value)? merge,
    TResult? Function(Undo value)? undo,
    TResult? Function(OnKey value)? onKey,
    TResult? Function(EndRound value)? endRound,
    TResult? Function(Save value)? save,
    TResult? Function(Queue value)? queue,
    TResult? Function(Clear value)? clear,
    TResult? Function(ChangePosition value)? changePosition,
  }) {
    return changePosition?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Init value)? init,
    TResult Function(NewGame value)? newGame,
    TResult Function(Move value)? move,
    TResult Function(Merge value)? merge,
    TResult Function(Undo value)? undo,
    TResult Function(OnKey value)? onKey,
    TResult Function(EndRound value)? endRound,
    TResult Function(Save value)? save,
    TResult Function(Queue value)? queue,
    TResult Function(Clear value)? clear,
    TResult Function(ChangePosition value)? changePosition,
    required TResult orElse(),
  }) {
    if (changePosition != null) {
      return changePosition(this);
    }
    return orElse();
  }
}

abstract class ChangePosition implements GameEvent {
  const factory ChangePosition(final bool value) = _$ChangePositionImpl;

  bool get value;
  @JsonKey(ignore: true)
  _$$ChangePositionImplCopyWith<_$ChangePositionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GameState {
  Board? get board => throw _privateConstructorUsedError;
  SwipeDirection? get swipeDirection => throw _privateConstructorUsedError;
  bool get position => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GameStateCopyWith<GameState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GameStateCopyWith<$Res> {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) then) =
      _$GameStateCopyWithImpl<$Res, GameState>;
  @useResult
  $Res call({Board? board, SwipeDirection? swipeDirection, bool position});
}

/// @nodoc
class _$GameStateCopyWithImpl<$Res, $Val extends GameState>
    implements $GameStateCopyWith<$Res> {
  _$GameStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? board = freezed,
    Object? swipeDirection = freezed,
    Object? position = null,
  }) {
    return _then(_value.copyWith(
      board: freezed == board
          ? _value.board
          : board // ignore: cast_nullable_to_non_nullable
              as Board?,
      swipeDirection: freezed == swipeDirection
          ? _value.swipeDirection
          : swipeDirection // ignore: cast_nullable_to_non_nullable
              as SwipeDirection?,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GameStateImplCopyWith<$Res>
    implements $GameStateCopyWith<$Res> {
  factory _$$GameStateImplCopyWith(
          _$GameStateImpl value, $Res Function(_$GameStateImpl) then) =
      __$$GameStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Board? board, SwipeDirection? swipeDirection, bool position});
}

/// @nodoc
class __$$GameStateImplCopyWithImpl<$Res>
    extends _$GameStateCopyWithImpl<$Res, _$GameStateImpl>
    implements _$$GameStateImplCopyWith<$Res> {
  __$$GameStateImplCopyWithImpl(
      _$GameStateImpl _value, $Res Function(_$GameStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? board = freezed,
    Object? swipeDirection = freezed,
    Object? position = null,
  }) {
    return _then(_$GameStateImpl(
      board: freezed == board
          ? _value.board
          : board // ignore: cast_nullable_to_non_nullable
              as Board?,
      swipeDirection: freezed == swipeDirection
          ? _value.swipeDirection
          : swipeDirection // ignore: cast_nullable_to_non_nullable
              as SwipeDirection?,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$GameStateImpl implements _GameState {
  const _$GameStateImpl(
      {this.board = null, this.swipeDirection = null, this.position = true});

  @override
  @JsonKey()
  final Board? board;
  @override
  @JsonKey()
  final SwipeDirection? swipeDirection;
  @override
  @JsonKey()
  final bool position;

  @override
  String toString() {
    return 'GameState(board: $board, swipeDirection: $swipeDirection, position: $position)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameStateImpl &&
            (identical(other.board, board) || other.board == board) &&
            (identical(other.swipeDirection, swipeDirection) ||
                other.swipeDirection == swipeDirection) &&
            (identical(other.position, position) ||
                other.position == position));
  }

  @override
  int get hashCode => Object.hash(runtimeType, board, swipeDirection, position);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      __$$GameStateImplCopyWithImpl<_$GameStateImpl>(this, _$identity);
}

abstract class _GameState implements GameState {
  const factory _GameState(
      {final Board? board,
      final SwipeDirection? swipeDirection,
      final bool position}) = _$GameStateImpl;

  @override
  Board? get board;
  @override
  SwipeDirection? get swipeDirection;
  @override
  bool get position;
  @override
  @JsonKey(ignore: true)
  _$$GameStateImplCopyWith<_$GameStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
