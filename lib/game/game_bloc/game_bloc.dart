// ignore_for_file: depend_on_referenced_packages, void_checks

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:riverpodtemp/game/models/board.dart';
import 'package:riverpodtemp/infrastructure/services/local_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bloc/bloc.dart';

import '../models/tile.dart';

part 'game_event.dart';

part 'game_state.dart';

part 'game_bloc.freezed.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(const GameState()) {
    final verticalOrder = [
      12,
      8,
      4,
      0,
      13,
      9,
      5,
      1,
      14,
      10,
      6,
      2,
      15,
      11,
      7,
      3
    ];

    Tile random(List<int> indexes) {
      var i = 0;
      var rng = Random();
      do {
        i = rng.nextInt(16);
      } while (indexes.contains(i));

      return Tile(const Uuid().v4(), 2, i);
    }

    bool inRange(index, nextIndex) {
      return index < 4 && nextIndex < 4 ||
          index >= 4 && index < 8 && nextIndex >= 4 && nextIndex < 8 ||
          index >= 8 && index < 12 && nextIndex >= 8 && nextIndex < 12 ||
          index >= 12 && nextIndex >= 12;
    }

    Tile calculate(Tile tile, List<Tile> tiles, direction) {
      bool asc =
          direction == SwipeDirection.left || direction == SwipeDirection.up;
      bool vert =
          direction == SwipeDirection.up || direction == SwipeDirection.down;
      int index = vert ? verticalOrder[tile.index] : tile.index;
      int nextIndex = ((index + 1) / 4).ceil() * 4 - (asc ? 4 : 1);

      if (tiles.isNotEmpty) {
        var last = tiles.last;
        var lastIndex = last.nextIndex ?? last.index;
        lastIndex = vert ? verticalOrder[lastIndex] : lastIndex;
        if (inRange(index, lastIndex)) {
          nextIndex = lastIndex + (asc ? 1 : -1);
        }
      }

      return tile.copyWith(
          nextIndex: vert ? verticalOrder.indexOf(nextIndex) : nextIndex);
    }

    on<Init>((event, emit) async {
      var board = LocalStorage.getBoard();
      emit(state.copyWith(
          board: board ??
              Board.newGame(state.board?.best ?? 0 + (state.board?.score ?? 0),
                  [random([])])));
    });

    on<Move>((event, emit) {
      bool asc = event.direction == SwipeDirection.left ||
          event.direction == SwipeDirection.up;
      bool vert = event.direction == SwipeDirection.up ||
          event.direction == SwipeDirection.down;
      List<Tile> list = List.from(state.board?.tiles ?? []);
      list.sort(((a, b) =>
          (asc ? 1 : -1) *
          (vert
              ? (verticalOrder[a.index].compareTo(verticalOrder[b.index]))
              : a.index.compareTo(b.index))));

      List<Tile> tiles = [];

      for (int i = 0, l = list.length; i < l; i++) {
        var tile = list[i];

        tile = calculate(tile, tiles, event.direction);
        tiles.add(tile);

        if (i + 1 < l) {
          var next = list[i + 1];
          if (tile.value == next.value) {
            var index = vert ? verticalOrder[tile.index] : tile.index,
                nextIndex = vert ? verticalOrder[next.index] : next.index;
            if (inRange(index, nextIndex)) {
              tiles.add(next.copyWith(nextIndex: tile.nextIndex));
              i += 1;
              continue;
            }
          }
        }
      }
      final board = state.board?.copyWith(tiles: tiles, undo: state.board);
      event.onSuccess();
      emit(state.copyWith(board: board));
    });

    on<Merge>((event, emit) {
      List<Tile> tiles = [];
      var tilesMoved = false;
      List<int> indexes = [];
      int score = state.board?.score ?? 0;

      for (int i = 0, l = state.board?.tiles.length ?? 0; i < l; i++) {
        var tile = state.board?.tiles[i];

        var value = tile?.value, merged = false;

        if (i + 1 < l) {
          var next = (state.board?.tiles[i + 1]);
          if (tile?.nextIndex == next?.nextIndex ||
              tile?.index == next?.nextIndex && tile?.nextIndex == null) {
            value = (tile?.value ?? 0) + (next?.value ?? 0);
            merged = true;
            score += (tile?.value ?? 0);
            i += 1;
          }
        }

        if (merged ||
            tile?.nextIndex != null && tile?.index != tile?.nextIndex) {
          tilesMoved = true;
        }

        tiles.add(tile?.copyWith(
                index: tile.nextIndex ?? tile.index,
                nextIndex: null,
                value: value,
                merged: merged) ??
            Tile("", 0, 0));
        indexes.add(tiles.last.index);
      }

      if (tilesMoved) {
        tiles.add(random(indexes));
      }
      final board = state.board?.copyWith(score: score, tiles: tiles);
      emit(state.copyWith(board: board));
    });

    on<EndRound>((event, emit) {
      var gameOver = true, gameWon = false;
      List<Tile> tiles = [];

      if (state.board?.tiles.length == 16) {
        List list = List.from(state.board?.tiles ?? []);
        list.sort(((a, b) => a.index.compareTo(b.index)));

        for (int i = 0, l = list.length; i < l; i++) {
          var tile = list[i];

          if (tile?.value == 2048) {
            gameWon = true;
          }

          var x = (i - (((i + 1) / 4).ceil() * 4 - 4));

          if (x > 0 && i - 1 >= 0) {
            var left = list[i - 1];
            if (tile?.value == left?.value) {
              gameOver = false;
            }
          }

          if (x < 3 && i + 1 < l) {
            var right = list[i + 1];
            if (tile?.value == right?.value) {
              gameOver = false;
            }
          }

          if (i - 4 >= 0) {
            var top = list[i - 4];
            if (tile?.value == top?.value) {
              gameOver = false;
            }
          }

          if (i + 4 < l) {
            var bottom = list[i + 4];
            if (tile?.value == bottom?.value) {
              gameOver = false;
            }
          }
          tiles.add(tile?.copyWith(merged: false) ?? Tile("", 0, 0));
        }
      } else {
        gameOver = false;
        for (var tile in state.board?.tiles ?? []) {
          if (tile.value == 2048) {
            gameWon = true;
          }
          tiles.add(tile.copyWith(merged: false));
        }
      }

      final board =
          state.board?.copyWith(won: gameWon, tiles: tiles, over: gameOver);
      emit(state.copyWith(board: board, position: true));

      var nextDirection = state.swipeDirection;
      if (nextDirection != null) {
        bool asc = nextDirection == SwipeDirection.left ||
            nextDirection == SwipeDirection.up;
        bool vert = nextDirection == SwipeDirection.up ||
            nextDirection == SwipeDirection.down;
        List<Tile> list = List.from(state.board?.tiles ?? []);

        list.sort(((a, b) =>
            (asc ? 1 : -1) *
            (vert
                ? (verticalOrder[a.index].compareTo(verticalOrder[b.index]))
                : a.index.compareTo(b.index))));

        List<Tile> tiles = [];

        for (int i = 0, l = list.length; i < l; i++) {
          var tile = list[i];

          tile = calculate(tile, tiles, nextDirection);
          tiles.add(tile);

          if (i + 1 < l) {
            var next = list[i + 1];
            if (tile.value == next.value) {
              var index = vert ? verticalOrder[tile.index] : tile.index,
                  nextIndex = vert ? verticalOrder[next.index] : next.index;
              if (inRange(index, nextIndex)) {
                tiles.add(next.copyWith(nextIndex: tile.nextIndex));
                i += 1;
                continue;
              }
            }
          }
        }

        final board = state.board?.copyWith(tiles: tiles, undo: state.board);
        emit(state.copyWith(swipeDirection: null, board: board));
        event.onSuccess();
      }
      event.onFail();
    });

    on<OnKey>((event, emit) {
      SwipeDirection? direction;
      if (event.event.logicalKey == LogicalKeyboardKey.arrowRight) {
        direction = SwipeDirection.right;
      } else if (event.event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        direction = SwipeDirection.left;
      } else if (event.event.logicalKey == LogicalKeyboardKey.arrowUp) {
        direction = SwipeDirection.up;
      } else if (event.event.logicalKey == LogicalKeyboardKey.arrowDown) {
        direction = SwipeDirection.down;
      }

      if (direction != null) {
        bool asc =
            direction == SwipeDirection.left || direction == SwipeDirection.up;
        bool vert =
            direction == SwipeDirection.up || direction == SwipeDirection.down;
        List<Tile> list = List.from(state.board?.tiles ?? []);
        list.sort(((a, b) =>
            (asc ? 1 : -1) *
            (vert
                ? (verticalOrder[a.index].compareTo(verticalOrder[b.index]))
                : a.index.compareTo(b.index))));

        List<Tile> tiles = [];

        for (int i = 0, l = list.length; i < l; i++) {
          var tile = list[i];

          tile = calculate(tile, tiles, direction);
          tiles.add(tile);

          if (i + 1 < l) {
            var next = list[i + 1];
            if (tile.value == next.value) {
              var index = vert ? verticalOrder[tile.index] : tile.index,
                  nextIndex = vert ? verticalOrder[next.index] : next.index;
              if (inRange(index, nextIndex)) {
                tiles.add(next.copyWith(nextIndex: tile.nextIndex));
                i += 1;
                continue;
              }
            }
          }
        }

        final board = state.board?.copyWith(tiles: tiles, undo: state.board);
        emit(state.copyWith(board: board));
        event.onSuccess();
      }
      event.onFail();
    });

    on<NewGame>((event, emit) {
      emit(state.copyWith(
          board: Board.newGame(
              state.board?.best ?? 0 + (state.board?.score ?? 0),
              [random([])])));
    });

    on<Undo>((event, emit) {
      if (state.board?.undo != null) {
        final board = state.board?.copyWith(
            score: state.board?.undo!.score,
            tiles: state.board?.undo!.tiles,
            best: state.board?.undo!.best);
        emit(state.copyWith(board: board));
      }
    });

    on<Save>((event, emit) {
      LocalStorage.setBoard(state.board);
    });

    on<Queue>((event, emit) {
      emit(state.copyWith(swipeDirection: event.direction));
    });

    on<Clear>((event, emit) {
      emit(state.copyWith(swipeDirection: null));
    });

    on<ChangePosition>((event, emit) {
      emit(state.copyWith(position: event.value));
    });
  }
}
