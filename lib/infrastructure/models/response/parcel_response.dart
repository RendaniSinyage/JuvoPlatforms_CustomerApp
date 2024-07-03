

import '../data/links.dart';
import '../data/meta.dart';
import '../data/translation.dart';

class ParcelTypeResponse {
  List<TypeModel>? data;
  Links? links;
  Meta? meta;

  ParcelTypeResponse({
    this.data,
    this.links,
    this.meta,
  });

  ParcelTypeResponse copyWith({
    List<TypeModel>? data,
    Links? links,
    Meta? meta,
  }) =>
      ParcelTypeResponse(
        data: data ?? this.data,
        links: links ?? this.links,
        meta: meta ?? this.meta,
      );

  factory ParcelTypeResponse.fromJson(Map<String, dynamic> json) => ParcelTypeResponse(
    data: json["data"] == null ? [] : List<TypeModel>.from(json["data"]!.map((x) => TypeModel.fromJson(x))),
    links: json["links"] == null ? null : Links.fromJson(json["links"]),
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "links": links?.toJson(),
    "meta": meta?.toJson(),
  };
}

class TypeModel {
  int? id;
  String? type;
  String? img;
  num? minWidth;
  num? minHeight;
  num? minLength;
  num? maxWidth;
  num? maxHeight;
  num? maxLength;
  num? minG;
  num? maxG;
  num? price;
  num? pricePerKm;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Option>? options;

  TypeModel({
    this.id,
    this.type,
    this.img,
    this.minWidth,
    this.minHeight,
    this.minLength,
    this.maxWidth,
    this.maxHeight,
    this.maxLength,
    this.minG,
    this.maxG,
    this.price,
    this.pricePerKm,
    this.createdAt,
    this.updatedAt,
    this.options,
  });

  TypeModel copyWith({
    int? id,
    String? type,
    String? img,
    num? minWidth,
    num? minHeight,
    num? minLength,
    num? maxWidth,
    num? maxHeight,
    num? maxLength,
    num? minG,
    num? maxG,
    num? price,
    num? pricePerKm,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Option>? options,
  }) =>
      TypeModel(
        id: id ?? this.id,
        type: type ?? this.type,
        img: img ?? this.img,
        minWidth: minWidth ?? this.minWidth,
        minHeight: minHeight ?? this.minHeight,
        minLength: minLength ?? this.minLength,
        maxWidth: maxWidth ?? this.maxWidth,
        maxHeight: maxHeight ?? this.maxHeight,
        maxLength: maxLength ?? this.maxLength,
        minG: minG ?? this.minG,
        maxG: maxG ?? this.maxG,
        price: price ?? this.price,
        pricePerKm: pricePerKm ?? this.pricePerKm,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        options: options ?? this.options,
      );

  factory TypeModel.fromJson(Map<String, dynamic> json) => TypeModel(
    id: json["id"],
    type: json["type"],
    img: json["img"],
    minWidth: json["min_width"],
    minHeight: json["min_height"],
    minLength: json["min_length"],
    maxWidth: json["max_width"],
    maxHeight: json["max_height"],
    maxLength: json["max_length"],
    minG: json["min_g"],
    maxG: json["max_g"],
    price: json["price"],
    pricePerKm: json["price_per_km"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    options: json["options"] == null ? [] : List<Option>.from(json["options"]!.map((x) => Option.fromJson(x))),

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "img": img,
    "min_width": minWidth,
    "min_height": minHeight,
    "min_length": minLength,
    "max_width": maxWidth,
    "max_height": maxHeight,
    "max_length": maxLength,
    "min_g": minG,
    "max_g": maxG,
    "price": price,
    "price_per_km": pricePerKm,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "options": options == null ? [] : List<dynamic>.from(options!.map((x) => x.toJson())),

  };
}

class Option {
  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  Translation? translation;

  Option({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.translation,
  });

  Option copyWith({
    int? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Translation? translation,
  }) =>
      Option(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        translation: translation ?? this.translation,
      );

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    id: json["id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    translation: json["translation"] == null ? null : Translation.fromJson(json["translation"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "translation": translation?.toJson(),
  };
}
