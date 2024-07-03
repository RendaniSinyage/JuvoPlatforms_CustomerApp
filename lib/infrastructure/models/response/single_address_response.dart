

import 'package:riverpodtemp/infrastructure/models/data/address_new_data.dart';

class SingleAddressResponse {
  SingleAddressResponse({
    String? timestamp,
    bool? status,
    String? message,
    AddressNewModel? data,
  }) {
    _timestamp = timestamp;
    _status = status;
    _message = message;
    _data = data;
  }

  SingleAddressResponse.fromJson(dynamic json) {
    _timestamp = json['timestamp'];
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? AddressNewModel.fromJson(json['data']) : null;
  }

  String? _timestamp;
  bool? _status;
  String? _message;
  AddressNewModel? _data;

  SingleAddressResponse copyWith({
    String? timestamp,
    bool? status,
    String? message,
    AddressNewModel? data,
  }) =>
      SingleAddressResponse(
        timestamp: timestamp ?? _timestamp,
        status: status ?? _status,
        message: message ?? _message,
        data: data ?? _data,
      );

  String? get timestamp => _timestamp;

  bool? get status => _status;

  String? get message => _message;

  AddressNewModel? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['timestamp'] = _timestamp;
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}
