import 'tile.dart';

class Board {
  final int score;
  final int best;
  final List<Tile> tiles;
  final bool over;
  final bool won;
  final Board? undo;

  Board(this.score, this.best, this.tiles,
      {this.over = false, this.won = false, this.undo});

  Board.newGame(this.best, this.tiles)
      : score = 0,
        over = false,
        won = false,
        undo = null;

  Board copyWith(
          {int? score,
          int? best,
          List<Tile>? tiles,
          bool? over,
          bool? won,
          Board? undo}) =>
      Board(score ?? this.score, best ?? this.best, tiles ?? this.tiles,
          over: over ?? this.over,
          won: won ?? this.won,
          undo: undo ?? this.undo);

  factory Board.fromJson(Map<dynamic, dynamic> json) =>
      Board(json["score"], json["best"], json["tiles"],
          won: json["won"], undo: json["undo"], over: json["over"]);

  Map<dynamic, dynamic> toJson() => {
        "score": score,
        "best": best,
        "tiles": tiles,
        "won": won,
        "over": over,
        "undo": undo,
      };
}
