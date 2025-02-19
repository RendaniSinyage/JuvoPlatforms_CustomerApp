import 'package:flutter/material.dart';

class AllProductsResponse {
  DateTime? timestamp;
  bool? status;
  String? message;
  Data? data;

  AllProductsResponse({
    this.timestamp,
    this.status,
    this.message,
    this.data,
  });

  AllProductsResponse copyWith({
    DateTime? timestamp,
    bool? status,
    String? message,
    Data? data,
  }) =>
      AllProductsResponse(
        timestamp: timestamp ?? this.timestamp,
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory AllProductsResponse.fromJson(Map<String, dynamic> json) =>
      AllProductsResponse(
        timestamp: json["timestamp"] == null
            ? null
            : DateTime.parse(json["timestamp"]),
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "timestamp": timestamp?.toIso8601String(),
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  List<Product>? recommended;
  List<All>? all;

  Data({
    this.recommended,
    this.all,
  });

  Data copyWith({
    List<Product>? recommended,
    List<All>? all,
  }) =>
      Data(
        recommended: recommended ?? this.recommended,
        all: all ?? this.all,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        recommended: json["recommended"] == null
            ? []
            : List<Product>.from(
                json["recommended"]!.map((x) => Product.fromJson(x))),
        all: json["all"] == null
            ? []
            : List<All>.from(json["all"]!.map((x) => All.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "recommended": recommended == null
            ? []
            : List<dynamic>.from(recommended!.map((x) => x.toJson())),
        "all":
            all == null ? [] : List<dynamic>.from(all!.map((x) => x.toJson())),
      };
}

class All {
  GlobalKey? key;
  int? id;
  String? uuid;
  String? type;
  int? input;
  int? shopId;
  String? img;
  bool? active;
  String? status;
  Translation? translation;
  List<dynamic>? children;
  List<Product>? products;

  All({
    this.key,
    this.id,
    this.uuid,
    this.type,
    this.input,
    this.shopId,
    this.img,
    this.active,
    this.status,
    this.translation,
    this.children,
    this.products,
  });

  All copyWith({
    int? id,
    GlobalKey? key,
    String? uuid,
    String? type,
    int? input,
    int? shopId,
    String? img,
    bool? active,
    String? status,
    Translation? translation,
    List<dynamic>? children,
    List<Product>? products,
  }) =>
      All(
        id: id ?? this.id,
        key: key ?? this.key,
        uuid: uuid ?? this.uuid,
        type: type ?? this.type,
        input: input ?? this.input,
        shopId: shopId ?? this.shopId,
        img: img ?? this.img,
        active: active ?? this.active,
        status: status ?? this.status,
        translation: translation ?? this.translation,
        children: children ?? this.children,
        products: products ?? this.products,
      );

  factory All.fromJson(Map<String, dynamic> json) => All(
        id: json["id"],
        uuid: json["uuid"],
        type: json["type"],
        input: json["input"],
        shopId: json["shop_id"],
        img: json["img"],
        active: json["active"],
        status: json["status"],
        translation: json["translation"] == null
            ? null
            : Translation.fromJson(json["translation"]),
        children: json["children"] == null
            ? []
            : List<dynamic>.from(json["children"]!.map((x) => x)),
        products: json["products"] == null
            ? []
            : List<Product>.from(
                json["products"]!.map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "type": type,
        "input": input,
        "shop_id": shopId,
        "img": img,
        "active": active,
        "status": status,
        "translation": translation?.toJson(),
        "children":
            children == null ? [] : List<dynamic>.from(children!.map((x) => x)),
        "products": products == null
            ? []
            : List<dynamic>.from(products!.map((x) => x.toJson())),
      };
}

class Product {
  int? id;
  String? uuid;
  int? shopId;
  int? categoryId;
  String? status;
  bool? active;
  bool? addon;
  bool? vegetarian;
  String? img;
  int? minQty;
  int? maxQty;
  int? interval;
  List<dynamic>? discounts;
  Translation? translation;
  Stock? stock;

  Product({
    this.id,
    this.uuid,
    this.shopId,
    this.categoryId,
    this.status,
    this.active,
    this.addon,
    this.vegetarian,
    this.img,
    this.minQty,
    this.maxQty,
    this.interval,
    this.discounts,
    this.translation,
    this.stock,
  });

  Product copyWith({
    int? id,
    String? uuid,
    int? shopId,
    int? categoryId,
    String? status,
    bool? active,
    bool? addon,
    bool? vegetarian,
    String? img,
    int? minQty,
    int? maxQty,
    int? interval,
    List<dynamic>? discounts,
    Translation? translation,
    Stock? stock,
  }) =>
      Product(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        shopId: shopId ?? this.shopId,
        categoryId: categoryId ?? this.categoryId,
        status: status ?? this.status,
        active: active ?? this.active,
        addon: addon ?? this.addon,
        vegetarian: vegetarian ?? this.vegetarian,
        img: img ?? this.img,
        minQty: minQty ?? this.minQty,
        maxQty: maxQty ?? this.maxQty,
        interval: interval ?? this.interval,
        discounts: discounts ?? this.discounts,
        translation: translation ?? this.translation,
        stock: stock ?? this.stock,
      );

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        uuid: json["uuid"],
        shopId: json["shop_id"],
        categoryId: json["category_id"],
        status: json["status"],
        active: json["active"],
        addon: json["addon"],
        vegetarian: json["vegetarian"],
        img: json["img"],
        minQty: json["min_qty"],
        maxQty: json["max_qty"],
        interval: json["interval"],
        discounts: json["discounts"] == null
            ? []
            : List<dynamic>.from(json["discounts"]!.map((x) => x)),
        translation: json["translation"] == null
            ? null
            : Translation.fromJson(json["translation"]),
        stock: json["stock"] == null ? null : Stock.fromJson(json["stock"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "shop_id": shopId,
        "category_id": categoryId,
        "status": status,
        "active": active,
        "addon": addon,
        "vegetarian": vegetarian,
        "img": img,
        "min_qty": minQty,
        "max_qty": maxQty,
        "interval": interval,
        "discounts": discounts == null
            ? []
            : List<dynamic>.from(discounts!.map((x) => x)),
        "translation": translation?.toJson(),
        "stock": stock?.toJson(),
      };
}

class Stock {
  int? id;
  int? countableId;
  double? price;
  int? quantity;
  double? tax;
  double? totalPrice;
  bool? addon;
  dynamic bonus;

  Stock({
    this.id,
    this.countableId,
    this.price,
    this.quantity,
    this.tax,
    this.totalPrice,
    this.addon,
    this.bonus,
  });

  Stock copyWith({
    int? id,
    int? countableId,
    double? price,
    int? quantity,
    double? tax,
    double? totalPrice,
    bool? addon,
    dynamic bonus,
  }) =>
      Stock(
        id: id ?? this.id,
        countableId: countableId ?? this.countableId,
        price: price ?? this.price,
        quantity: quantity ?? this.quantity,
        tax: tax ?? this.tax,
        totalPrice: totalPrice ?? this.totalPrice,
        addon: addon ?? this.addon,
        bonus: bonus ?? this.bonus,
      );

  factory Stock.fromJson(Map<String, dynamic> json) => Stock(
        id: json["id"],
        countableId: json["countable_id"],
        price: json["price"]?.toDouble(),
        quantity: json["quantity"],
        tax: json["tax"]?.toDouble(),
        totalPrice: json["total_price"]?.toDouble(),
        addon: json["addon"],
        bonus: json["bonus"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "countable_id": countableId,
        "price": price,
        "quantity": quantity,
        "tax": tax,
        "total_price": totalPrice,
        "addon": addon,
        "bonus": bonus,
      };
}

class Translation {
  int? id;
  String? locale;
  String? title;
  String? description;

  Translation({
    this.id,
    this.locale,
    this.title,
    this.description,
  });

  Translation copyWith({
    int? id,
    String? locale,
    String? title,
    String? description,
  }) =>
      Translation(
        id: id ?? this.id,
        locale: locale ?? this.locale,
        title: title ?? this.title,
        description: description ?? this.description,
      );

  factory Translation.fromJson(Map<String, dynamic> json) => Translation(
        id: json["id"],
        locale: json["locale"],
        title: json["title"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "locale": locale,
        "title": title,
        "description": description,
      };
}
