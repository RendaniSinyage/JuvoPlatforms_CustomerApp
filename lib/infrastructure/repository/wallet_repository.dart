import 'package:flutter/material.dart';
import 'package:foodyman/domain/handlers/handlers.dart';
import 'package:foodyman/domain/interface/wallet.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/local_storage.dart';

import '../models/data/user.dart';
import '../models/data/wallet_data.dart';

class WalletRepository implements WalletRepositoryFacade {
  @override
  Future<ApiResult<List<UserModel>>> searchSending(Map<String, dynamic> params) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/dashboard/user/search-sending',
        queryParameters: params,
      );

      return ApiResult.success(
        data: (response.data['data'] as List)
            .map((e) => UserModel.fromJson(e))
            .toList(),
      );
    } catch (e) {
      debugPrint('==> search sending failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<WalletHistoryData>> sendWalletBalance(
      String userUuid,
      double amount,
      ) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/dashboard/user/wallet/send',
        data: {
          'uuid': userUuid,
          'price': amount,
          'currency_id': LocalStorage.getSelectedCurrency()?.id ?? 1,
        },
      );

      return ApiResult.success(
        data: WalletHistoryData.fromJson(response.data['data']),
      );
    } catch (e) {
      debugPrint('==> send wallet balance failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

}