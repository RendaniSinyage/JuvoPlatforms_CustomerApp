// ignore_for_file: prefer_null_aware_operators

class DeliveryResponse {
  String? timestamp;
  bool? status;
  String? message;
  Data? data;

  DeliveryResponse({this.timestamp, this.status, this.message, this.data});

  DeliveryResponse.fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['timestamp'] = timestamp;
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  int? userId;
  String? typeOfTechnique;
  String? brand;
  String? model;
  String? number;
  String? color;
  String? width;
  String? height;
  String? kg;
  String? length;
  String? price;
  String? pricePerKm;
  bool? online;
  Location? location;
  String? createdAt;
  String? updatedAt;
  DeliveryMan? deliveryMan;
  List<Galleries>? galleries;

  Data(
      {this.id,
      this.userId,
      this.typeOfTechnique,
      this.brand,
      this.model,
      this.number,
      this.color,
      this.width,
      this.height,
      this.kg,
      this.length,
      this.price,
      this.pricePerKm,
      this.online,
      this.location,
      this.createdAt,
      this.updatedAt,
      this.deliveryMan,
      this.galleries});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    typeOfTechnique = json['type_of_technique'];
    brand = json['brand'];
    model = json['model'];
    number = json['number'];
    color = json['color'];
    width = json['width'] == null ? null : json['width'].toString();
    height = json['height'] == null ? null : json['height'].toString();
    kg = json['kg'] == null ? null : json['kg'].toString();
    length = json['length'] == null ? null : json['length']?.toString();
    price = json['price'];
    pricePerKm = json['price_per_km'];
    online = json['online'].runtimeType == int
        ? json['online'] == 1
        : json['online'];
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deliveryMan = json['deliveryMan'] != null
        ? DeliveryMan.fromJson(json['deliveryMan'])
        : null;
    if (json['galleries'] != null) {
      galleries = <Galleries>[];
      json['galleries'].forEach((v) {
        galleries!.add(Galleries.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['type_of_technique'] = typeOfTechnique;
    data['brand'] = brand;
    data['model'] = model;
    data['width'] = width;
    data['height'] = height;
    data['length'] = length;
    data['kg'] = kg;
    data['number'] = number;
    data['color'] = color;
    data['online'] = online;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (deliveryMan != null) {
      data['deliveryMan'] = deliveryMan!.toJson();
    }
    if (galleries != null) {
      data['galleries'] = galleries!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Location {
  String? latitude;
  String? longitude;

  Location({this.latitude, this.longitude});

  Location.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'].toString();
    longitude = json['longitude'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}

class DeliveryMan {
  int? id;
  String? uuid;
  String? firstname;
  String? lastname;
  String? email;
  String? phone;
  bool? active;
  String? img;
  String? role;
  String? emailVerifiedAt;
  String? registeredAt;

  DeliveryMan(
      {this.id,
      this.uuid,
      this.firstname,
      this.lastname,
      this.email,
      this.phone,
      this.active,
      this.img,
      this.role,
      this.emailVerifiedAt,
      this.registeredAt});

  DeliveryMan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    phone = json['phone'];
    active = json['active'].runtimeType == int
        ? (json['active'] == 1)
        : json['active'];
    img = json['img'];
    role = json['role'];
    emailVerifiedAt = json['email_verified_at'];
    registeredAt = json['registered_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uuid'] = uuid;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['email'] = email;
    data['phone'] = phone;
    data['active'] = active;
    data['img'] = img;
    data['role'] = role;
    data['email_verified_at'] = emailVerifiedAt;
    data['registered_at'] = registeredAt;
    return data;
  }
}

class Galleries {
  int? id;
  String? title;
  String? type;
  String? loadableType;
  int? loadableId;
  String? path;
  String? basePath;

  Galleries(
      {this.id,
      this.title,
      this.type,
      this.loadableType,
      this.loadableId,
      this.path,
      this.basePath});

  Galleries.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    loadableType = json['loadable_type'];
    loadableId = json['loadable_id'];
    path = json['path'];
    basePath = json['base_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['type'] = type;
    data['loadable_type'] = loadableType;
    data['loadable_id'] = loadableId;
    data['path'] = path;
    data['base_path'] = basePath;
    return data;
  }
}
