import 'address_information.dart';

class AddressNewModel {
  int? id;
  bool? active;
  String? title;
  int? userId;
  AddressInformation? address;
  List? location;
  DateTime? createdAt;
  DateTime? updatedAt;

  AddressNewModel(
      {this.id,
      this.title,
      this.userId,
      this.address,
      this.location,
      this.createdAt,
      this.updatedAt,
      this.active});

  AddressNewModel copyWith(
          {int? id,
          String? title,
          int? userId,
          AddressInformation? address,
          List? location,
          DateTime? createdAt,
          DateTime? updatedAt,
          bool? active}) =>
      AddressNewModel(
          id: id ?? this.id,
          title: title ?? this.title,
          userId: userId ?? this.userId,
          address: address ?? this.address,
          location: location ?? this.location,
          createdAt: createdAt ?? this.createdAt,
          updatedAt: updatedAt ?? this.updatedAt,
          active: active ?? this.active);

  factory AddressNewModel.fromJson(Map<String, dynamic> json) =>
      AddressNewModel(
        id: json["id"],
        title: json["title"],
        userId: json["user_id"],
        active: json["active"] is int ? json["active"] == 1 : json["active"],
        address: json["address"] == null && json["address"].runtimeType == List
            ? null
            : AddressInformation.fromJson(json["address"]),
        location: json["location"] == null
            ? []
            : List.from(json["location"]!.map((x) => x)),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        if (title != null && (title?.isNotEmpty ?? false)) "title": title,
        "active": 1,
        "user_id": userId,
        "address": address?.toJson(),
        "location":
            location == null ? [] : List<dynamic>.from(location!.map((x) => x)),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
