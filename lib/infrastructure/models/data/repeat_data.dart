import 'dart:convert';

class RepeatData {
  int? id;
  int? orderId;
  String? from;
  String? to;
  String? createdAt;
  String? updatedAt;

  RepeatData({
    this.id,
    this.orderId,
    this.from,
    this.to,
    this.createdAt,
    this.updatedAt,
  });

  RepeatData copyWith({
    int? id,
    int? orderId,
    String? from,
    String? to,
    String? createdAt,
    String? updatedAt,
  }) =>
      RepeatData(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        from: from ?? this.from,
        to: to ?? this.to,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory RepeatData.fromRawJson(String str) => RepeatData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RepeatData.fromJson(Map<String, dynamic> json) => RepeatData(
    id: json["id"],
    orderId: json["order_id"],
    from: json["from"],
    to: json["to"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_id": orderId,
    "from": from,
    "to": to,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
