import 'translation.dart';


// ProductUnit class to handle unit data from API
class ProductUnit {
  final int? id;
  final bool? active;
  final String? position;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Translation? translation;

  ProductUnit({
    this.id,
    this.active,
    this.position,
    this.createdAt,
    this.updatedAt,
    this.translation,
  });

  ProductUnit copyWith({
    int? id,
    bool? active,
    String? position,
    DateTime? createdAt,
    DateTime? updatedAt,
    Translation? translation,
  }) =>
      ProductUnit(
        id: id ?? this.id,
        active: active ?? this.active,
        position: position ?? this.position,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        translation: translation ?? this.translation,
      );

  factory ProductUnit.fromJson(Map<String, dynamic> json) => ProductUnit(
    id: json["id"],
    active: json["active"],
    position: json["position"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
    translation: json["translation"] == null
        ? null
        : Translation.fromJson(json["translation"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "active": active,
    "position": position,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "translation": translation?.toJson(),
  };
}