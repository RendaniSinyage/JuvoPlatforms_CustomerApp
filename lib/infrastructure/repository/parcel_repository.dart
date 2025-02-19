import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';
import 'package:foodyman/domain/interface/parcel.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/infrastructure/models/response/parcel_paginate_response.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/local_storage.dart';
import 'package:foodyman/domain/handlers/handlers.dart';

class ParcelRepository implements ParcelRepositoryFacade {
  @override
  Future<ApiResult<void>> addReview(
    num orderId, {
    required double rating,
    required String comment,
  }) async {
    final data = {'rating': rating, if (comment != "") 'comment': comment};
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/dashboard/user/parcel-orders/deliveryman-review/$orderId',
        data: data,
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> add parcel review failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ParcelTypeResponse>> getTypes() async {
    final data = {'lang': LocalStorage.getLanguage()?.locale};
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/v1/rest/parcel-order/types',
        queryParameters: data,
      );
      return ApiResult.success(
        data: ParcelTypeResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get parcel type failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ParcelCalculateResponse>> getCalculate({
    required int typeId,
    required LocationModel from,
    required LocationModel to,
  }) async {
    final data = {
      'lang': LocalStorage.getLanguage()?.locale,
      'type_id': typeId,
      'currency_id': LocalStorage.getSelectedCurrency()?.id,
      'address_from[latitude]': from.latitude,
      'address_from[longitude]': from.longitude,
      'address_to[latitude]': to.latitude,
      'address_to[longitude]': to.longitude,
    };
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
          '/api/v1/rest/parcel-order/calculate-price',
          queryParameters: data);
      return ApiResult.success(
        data: ParcelCalculateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get parcel type failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult> orderParcel(
      {required int typeId,
      required LocationModel from,
      required String fromTitle,
      required LocationModel to,
      required String toTitle,
      required String time,
      required String note,
      required String phoneFrom,
      required String phoneTo,
      required String usernameTo,
      required String floorTo,
      required String floorFrom,
      required String houseFrom,
      required String houseTo,
      required String value,
      required String comment,
      required String instruction,
      required bool notify,
      required String usernameFrom}) async {
    final data = {
      'lang': LocalStorage.getLanguage()?.locale,
      'type_id': typeId,
      'currency_id': LocalStorage.getSelectedCurrency()?.id,
      "address_from": {
        "address": fromTitle,
        "latitude": from.latitude,
        "longitude": from.longitude,
        if (floorFrom.isNotEmpty) 'stage': floorFrom,
        if (houseFrom.isNotEmpty) 'house': houseFrom,
      },
      "address_to": {
        "address": toTitle,
        "latitude": to.latitude,
        "longitude": to.longitude,
        if (floorTo.isNotEmpty) 'stage': floorTo,
        if (houseTo.isNotEmpty) 'house': houseTo,
      },
      'rate': LocalStorage.getSelectedCurrency()?.rate,
      'delivery_date': DateFormat("yyyy-MM-dd").format(DateTime.now()),
      'delivery_time': time,
      if (comment.isNotEmpty) 'note': comment,
      if (instruction.isNotEmpty) 'instruction': instruction,
      if (note.isNotEmpty) 'description': note,
      if (value.isNotEmpty) 'qr_value': value,
      'phone_from': phoneFrom,
      'phone_to': phoneTo,
      'notify': notify ? 1 : 0,
      'username_from': usernameFrom,
      'username_to': usernameTo,
    };
    try {
      final client = dioHttp.client(requireAuth: true);

      final res =
          await client.post('/api/v1/dashboard/user/parcel-orders', data: data);
      return ApiResult.success(data: res.data["data"]["id"]);
    } catch (e) {
      debugPrint('==> get parcel order failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ParcelPaginateResponse>> getActiveParcel(int page) async {
    final data = {
      if (LocalStorage.getSelectedCurrency() != null)
        'currency_id': LocalStorage.getSelectedCurrency()?.id,
      'lang': LocalStorage.getLanguage()?.locale,
      'page': page,
      'statuses[0]': "new",
      "statuses[1]": "accepted",
      "statuses[2]": "ready",
      "statuses[3]": "on_a_way",
      "order_statuses": true,
      "perPage": 10
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/dashboard/user/parcel-orders',
        queryParameters: data,
      );
      return ApiResult.success(
        data: ParcelPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get open parcel failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ParcelPaginateResponse>> getHistoryParcel(int page) async {
    final data = {
      if (LocalStorage.getSelectedCurrency() != null)
        'currency_id': LocalStorage.getSelectedCurrency()?.id,
      'lang': LocalStorage.getLanguage()?.locale,
      'statuses[0]': "delivered",
      "statuses[1]": "canceled",
      "order_statuses": true,
      "perPage": 10,
      "page": page
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/dashboard/user/parcel-orders',
        queryParameters: data,
      );
      return ApiResult.success(
        data: ParcelPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get canceled parcel failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ParcelOrder>> getSingleParcel(num orderId) async {
    final data = {
      if (LocalStorage.getSelectedCurrency() != null)
        'currency_id': LocalStorage.getSelectedCurrency()?.id,
      'lang': LocalStorage.getLanguage()?.locale
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/dashboard/user/parcel-orders/$orderId',
        queryParameters: data,
      );
      return ApiResult.success(
        data: ParcelOrder.fromJson(response.data["data"]),
      );
    } catch (e) {
      debugPrint('==> get single parcel failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<String>> process(num orderId, String name) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      var res = await client.get(
        '/api/v1/dashboard/user/order-$name-process?parcel_id=$orderId',
      );
      return ApiResult.success(data: res.data["data"]["data"]["url"]);
    } catch (e) {
      debugPrint('==> add order review failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<TransactionsResponse>> createTransaction({
    required int orderId,
    required int paymentId,
  }) async {
    final data = {'payment_sys_id': paymentId};
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/payments/parcel-order/$orderId/transactions',
        data: data,
      );
      return ApiResult.success(
        data: TransactionsResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> create transaction failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}
