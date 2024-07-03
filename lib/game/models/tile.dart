class Tile {
  final String id;
  final int value;
  final int index;
  final int? nextIndex;
  final bool merged;

  Tile(this.id, this.value, this.index, {this.nextIndex, this.merged = false});

  double getTop(double size) {
    var i = ((index + 1) / 4).ceil();
    return ((i - 1) * size) + (12.0 * i);
  }

  double getLeft(double size) {
    var i = (index - (((index + 1) / 4).ceil() * 4 - 4));
    return (i * size) + (12.0 * (i + 1));
  }

  double? getNextTop(double size) {
    if (nextIndex == null) return null;
    var i = ((nextIndex! + 1) / 4).ceil();
    return ((i - 1) * size) + (12.0 * i);
  }

  double? getNextLeft(double size) {
    if (nextIndex == null) return null;
    var i = (nextIndex! - (((nextIndex! + 1) / 4).ceil() * 4 - 4));
    return (i * size) + (12.0 * (i + 1));
  }

  Tile copyWith(
          {String? id, int? value, int? index, int? nextIndex, bool? merged}) =>
      Tile(id ?? this.id, value ?? this.value, index ?? this.index,
          nextIndex: nextIndex ?? this.nextIndex,
          merged: merged ?? this.merged);

  factory Tile.fromJson(Map<String, dynamic> json) =>
      Tile(json["id"], json["value"], json["index"],
          nextIndex: json["next_index"], merged: json["merged"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "index": index,
        "value": value,
        "next_index": nextIndex,
        "merged": merged,
      };
}
