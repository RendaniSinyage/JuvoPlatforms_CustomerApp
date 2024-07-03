import 'package:riverpodtemp/infrastructure/models/data/parcel_order.dart';

import '../data/meta.dart';

class ParcelPaginateResponse {
  ParcelPaginateResponse({
    List<ParcelOrder>? data,
    Meta? meta,
  }) {
    _data = data;
    _meta = meta;
  }

  ParcelPaginateResponse.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(ParcelOrder.fromJson(v));
      });
    }
    _meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }

  List<ParcelOrder>? _data;
  Meta? _meta;

  ParcelPaginateResponse copyWith({
    List<ParcelOrder>? data,
    Meta? meta,
  }) =>
      ParcelPaginateResponse(
        data: data ?? _data,
        meta: meta ?? _meta,
      );

  List<ParcelOrder>? get data => _data;

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