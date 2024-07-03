import '../data/payment_data.dart';

class PaymentsResponse {
  PaymentsResponse({List<PaymentData>? data}) {
    _data = data;
  }

  PaymentsResponse.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(PaymentData.fromJson(v));
      });
    }
  }

  List<PaymentData>? _data;

  PaymentsResponse copyWith({List<PaymentData>? data}) =>
      PaymentsResponse(data: data ?? _data);

  List<PaymentData>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
