
// ignore_for_file: file_names

class ParcelCalculateResponse {
  DateTime? timestamp;
  bool? status;
  String? message;
  Data? data;

  ParcelCalculateResponse({
    this.timestamp,
    this.status,
    this.message,
    this.data,
  });

  ParcelCalculateResponse copyWith({
    DateTime? timestamp,
    bool? status,
    String? message,
    Data? data,
  }) =>
      ParcelCalculateResponse(
        timestamp: timestamp ?? this.timestamp,
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory ParcelCalculateResponse.fromJson(Map<String, dynamic> json) => ParcelCalculateResponse(
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
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
  num? price;
  num? km;

  Data({
    this.price,
    this.km,
  });

  Data copyWith({
    num? price,
    num? km,
  }) =>
      Data(
        price: price ?? this.price,
        km: km ?? this.km,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    price: json["price"],
    km: json["km"],
  );

  Map<String, dynamic> toJson() => {
    "price": price,
    "km": km,
  };
}
