import 'package:foodyman/infrastructure/models/data/shop_data.dart';
import 'package:flutter/foundation.dart';
import '../../../utils/banner_text_cache.dart';
import '../data/meta.dart';
import '../data/translation.dart';

class BannersPaginateResponse {
  BannersPaginateResponse({List<BannerData>? data, Meta? meta}) {
    _data = data;
    _meta = meta;
  }

  BannersPaginateResponse.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(BannerData.fromJson(v));
      });
    }
    _meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }

  List<BannerData>? _data;
  Meta? _meta;

  BannersPaginateResponse copyWith({List<BannerData>? data, Meta? meta}) =>
      BannersPaginateResponse(data: data ?? _data, meta: meta ?? _meta);

  List<BannerData>? get data => _data;

  Meta? get meta => _meta;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    if (_meta != null) {
      map['meta'] = _meta?.toJson();
    }
    return map;
  }
}

class BannerData {
  BannerData({
    int? id,
    int? shopId,
    String? url,
    List<ShopData>? shops,
    String? img,
    bool? active,
    bool? clickable,
    int? likes,
    String? createdAt,
    String? updatedAt,
    Translation? translation,
    String? buttonText, // Added parameter
  }) {
    _id = id;
    _shopId = shopId;
    _url = url;
    _shops = shops;
    _img = img;
    _active = active;
    _clickable = clickable;
    _likes = likes;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _translation = translation;
    _buttonText = buttonText; // Store button text

    if (kDebugMode) {
      print(
        "CONSTRUCTOR DEBUG: Created BannerData with ID: $id, buttonText: '$buttonText'");
    }
  }

  BannerData.fromJson(dynamic json) {
    if (kDebugMode) {
      print(
        "FROM_JSON DEBUG: Starting to parse BannerData from JSON for ID: ${json['id']}");
    }

    _id = json['id'];
    _shopId = json['shop_id'];
    _url = json['url'];
    if (json['shops'] != null) {
      _shops = [];
      json['shops'].forEach((v) {
        _shops?.add(ShopData.fromJson(v));
      });
    }
    _img = json['img'];
    if (json['active'] != null) {
      if (json['active'] is bool) {
        _active = json['active'];
      } else if (json['active'] is int) {
        _active = json['active'] == 1;
      } else if (json['active'] is String) {
        _active =
            json['active'] == '1' || json['active'].toLowerCase() == 'true';
      } else {
        _active = false;
      }
    } else {
      _active = null;
    }
    if (json['clickable'] != null) {
      if (json['clickable'] is bool) {
        _clickable = json['clickable'];
      } else if (json['clickable'] is int) {
        _clickable = json['clickable'] == 1;
      } else if (json['clickable'] is String) {
        _clickable = json['clickable'] == '1' ||
            json['clickable'].toLowerCase() == 'true';
      } else {
        _clickable = false;
      }
    } else {
      _clickable = null;
    }
    _likes = json['likes'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];

    if (kDebugMode) {
      print(
        "TRANSLATION DEBUG: Translation object in JSON: ${json['translation']}");
    }
    _translation = json['translation'] != null
        ? Translation.fromJson(json['translation'])
        : null;

    // Extract and store button text directly
    _buttonText = json['translation']?['button_text'];
    // Store in cache if found
    if (_buttonText != null) {
      BannerTextCache.storeButtonText(json['id'], _buttonText);
    } else {
      // Try to get from cache if not found in this response
      _buttonText = BannerTextCache.getButtonText(json['id']);
    }

    if (kDebugMode) {
      print("BUTTON_TEXT DEBUG: Final button_text: '$_buttonText' for banner ID: ${json['id']}");
    }
  }

  int? _id;
  int? _shopId;
  String? _url;
  List<ShopData>? _shops;
  String? _img;
  bool? _active;
  bool? _clickable;
  int? _likes;
  String? _createdAt;
  String? _updatedAt;
  String? _buttonText;
  Translation? _translation;

  BannerData copyWith({
    int? id,
    int? shopId,
    String? url,
    List<ShopData>? shops,
    String? img,
    bool? active,
    bool? clickable,
    int? likes,
    String? createdAt,
    String? updatedAt,
    Translation? translation,
    String? buttonText, // Added parameter
  }) =>
      BannerData(
        id: id ?? _id,
        shopId: shopId ?? _shopId,
        url: url ?? _url,
        shops: shops ?? _shops,
        img: img ?? _img,
        active: active ?? _active,
        clickable: clickable ?? _clickable,
        likes: likes ?? _likes,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        translation: translation ?? _translation,
        buttonText: buttonText ?? _buttonText, // Include in copyWith
      );

  int? get id => _id;

  int? get shopId => _shopId;

  String? get url => _url;

  List<ShopData>? get shops => _shops;

  String? get img => _img;

  bool? get active => _active;

  bool? get clickable => _clickable;

  int? get likes => _likes;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  Translation? get translation => _translation;

  String? get buttonText {
    if (_buttonText != null) return _buttonText;

    // Try to get from cache
    return BannerTextCache.getButtonText(_id);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['shop_id'] = _shopId;
    map['url'] = _url;
    map['shops'] = _shops;
    map['img'] = _img;
    map['active'] = _active;
    map['likes'] = _likes;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    if (_translation != null) {
      map['translation'] = _translation?.toJson();
    }
    map['button_text'] = _buttonText; // Include in toJson
    return map;
  }
}