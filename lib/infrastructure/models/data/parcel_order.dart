// To parse this JSON data, do
//
//     final parcelOrder = parcelOrderFromJson(jsonString);

import 'package:riverpodtemp/infrastructure/models/data/review_data.dart';
import 'package:riverpodtemp/infrastructure/models/data/user.dart';
import 'package:riverpodtemp/infrastructure/models/response/parcel_response.dart';

class ParcelOrder {
  int? id;
  int? userId;
  num? totalPrice;
  num? rate;
  String? status;
  String? phoneTo;
  String? usernameTo;
  String? note;
  Address? addressFrom;
  Address? addressTo;
  int? typeId;
  num? deliveryFee;
  DateTime? deliveryDate;
  String? deliveryTime;
  String? phoneFrom;
  String? usernameFrom;
  bool? current;
  DateTime? createdAt;
  DateTime? updatedAt;
  num? km;
  dynamic deliveryman;
  Currency? currency;
  UserModel? user;
  ReviewData? review;
  dynamic transaction;
  TypeModel? type;

  ParcelOrder({
    this.id,
    this.userId,
    this.totalPrice,
    this.rate,
    this.status,
    this.phoneTo,
    this.usernameTo,
    this.note,
    this.addressFrom,
    this.addressTo,
    this.typeId,
    this.deliveryFee,
    this.deliveryDate,
    this.deliveryTime,
    this.phoneFrom,
    this.review,
    this.usernameFrom,
    this.current,
    this.createdAt,
    this.updatedAt,
    this.km,
    this.deliveryman,
    this.currency,
    this.user,
    this.transaction,
    this.type,
  });

  ParcelOrder copyWith({
    int? id,
    int? userId,
    num? totalPrice,
    num? rate,
    String? status,
    String? phoneTo,
    String? note,
    String? usernameTo,
    Address? addressFrom,
    Address? addressTo,
    int? typeId,
    num? deliveryFee,
    DateTime? deliveryDate,
    String? deliveryTime,
    String? phoneFrom,
    String? usernameFrom,
    ReviewData? review,
    bool? current,
    DateTime? createdAt,
    DateTime? updatedAt,
    num? km,
    dynamic deliveryman,
    Currency? currency,
    UserModel? user,
    dynamic transaction,
    TypeModel? type,
  }) =>
      ParcelOrder(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        totalPrice: totalPrice ?? this.totalPrice,
        rate: rate ?? this.rate,
        status: status ?? this.status,
        note: note ?? this.note,
        phoneTo: phoneTo ?? this.phoneTo,
        usernameTo: usernameTo ?? this.usernameTo,
        addressFrom: addressFrom ?? this.addressFrom,
        addressTo: addressTo ?? this.addressTo,
        typeId: typeId ?? this.typeId,
        deliveryFee: deliveryFee ?? this.deliveryFee,
        deliveryDate: deliveryDate ?? this.deliveryDate,
        deliveryTime: deliveryTime ?? this.deliveryTime,
        phoneFrom: phoneFrom ?? this.phoneFrom,
        usernameFrom: usernameFrom ?? this.usernameFrom,
        review: review ?? this.review,
        current: current ?? this.current,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        km: km ?? this.km,
        deliveryman: deliveryman ?? this.deliveryman,
        currency: currency ?? this.currency,
        user: user ?? this.user,
        transaction: transaction ?? this.transaction,
        type: type ?? this.type,
      );

  factory ParcelOrder.fromJson(Map<String, dynamic> json) {
    return ParcelOrder(
      id: json["id"],
      userId: json["user_id"],
      totalPrice: json["total_price"],
      rate: json["rate"],
      status: json["status"],
      note: json["note"],
      phoneTo: json["phone_to"],
      usernameTo: json["username_to"],
      addressFrom: json["address_from"] == null
          ? null
          : Address.fromJson(json["address_from"]),
      addressTo: json["address_to"] == null
          ? null
          : Address.fromJson(json["address_to"]),
      review:
          json["review"] == null ? null : ReviewData.fromJson(json["review"]),
      typeId: json["type_id"],
      deliveryFee: json["delivery_fee"],
      deliveryDate: json["delivery_date"] == null
          ? null
          : DateTime.parse(json["delivery_date"]),
      deliveryTime: json["delivery_time"],
      phoneFrom: json["phone_from"],
      usernameFrom: json["username_from"],
      current: json["current"],
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]).toLocal(),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]).toLocal(),
      km: json["km"]?.toDouble(),
      deliveryman: json["deliveryman"],
      currency:
          json["currency"] == null ? null : Currency.fromJson(json["currency"]),
      user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
      transaction: json["transaction"],
      type: json["type"] == null ? null : TypeModel.fromJson(json["type"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "total_price": totalPrice,
        "rate": rate,
        "status": status,
        "note": note,
        "phone_to": phoneTo,
        "username_to": usernameTo,
        "address_from": addressFrom?.toJson(),
        "address_to": addressTo?.toJson(),
        "type_id": typeId,
        "delivery_fee": deliveryFee,
        "delivery_date":
            "${deliveryDate!.year.toString().padLeft(4, '0')}-${deliveryDate!.month.toString().padLeft(2, '0')}-${deliveryDate!.day.toString().padLeft(2, '0')}",
        "delivery_time": deliveryTime,
        "phone_from": phoneFrom,
        "username_from": usernameFrom,
        "current": current,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "km": km,
        "deliveryman": deliveryman,
        "currency": currency?.toJson(),
        "user": user?.toJson(),
        "transaction": transaction,
        "type": type?.toJson(),
      };
}

class Address {
  String? address;
  double? latitude;
  double? longitude;

  Address({
    this.address,
    this.latitude,
    this.longitude,
  });

  Address copyWith({
    String? address,
    double? latitude,
    double? longitude,
  }) =>
      Address(
        address: address ?? this.address,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
      );

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        address: json["address"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
      };
}

class Currency {
  int? id;
  String? symbol;
  String? title;
  num? rate;
  bool? currencyDefault;
  String? position;
  bool? active;
  DateTime? createdAt;
  DateTime? updatedAt;

  Currency({
    this.id,
    this.symbol,
    this.title,
    this.rate,
    this.currencyDefault,
    this.position,
    this.active,
    this.createdAt,
    this.updatedAt,
  });

  Currency copyWith({
    int? id,
    String? symbol,
    String? title,
    num? rate,
    bool? currencyDefault,
    String? position,
    bool? active,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Currency(
        id: id ?? this.id,
        symbol: symbol ?? this.symbol,
        title: title ?? this.title,
        rate: rate ?? this.rate,
        currencyDefault: currencyDefault ?? this.currencyDefault,
        position: position ?? this.position,
        active: active ?? this.active,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        id: json["id"],
        symbol: json["symbol"],
        title: json["title"],
        rate: json["rate"],
        currencyDefault: json["default"],
        position: json["position"],
        active: json["active"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "symbol": symbol,
        "title": title,
        "rate": rate,
        "default": currencyDefault,
        "position": position,
        "active": active,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
