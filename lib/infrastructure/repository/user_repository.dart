import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';
import 'package:foodyman/domain/interface/user.dart';
import 'package:foodyman/infrastructure/models/data/address_new_data.dart';
import 'package:foodyman/infrastructure/models/data/referral_data.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/infrastructure/models/request/edit_profile.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/local_storage.dart';
import 'package:foodyman/domain/handlers/handlers.dart';

import '../models/data/user.dart';
import '../models/response/search_user_response.dart';
import '../services/app_validators.dart';

class UserRepository implements UserRepositoryFacade {
  @override
  Future<ApiResult<ProfileResponse>> getProfileDetails() async {
    try {
      final data = {
        if (LocalStorage.getSelectedCurrency() != null)
          'currency_id': LocalStorage.getSelectedCurrency()?.id,
        "lang": LocalStorage.getLanguage()?.locale ?? "en"
      };
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get('/api/v1/dashboard/user/profile/show',
          queryParameters: data);
      return ApiResult.success(
        data: ProfileResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get user details failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ReferralModel>> getReferralDetails() async {
    try {
      final data = {
        if (LocalStorage.getSelectedCurrency() != null)
          'currency_id': LocalStorage.getSelectedCurrency()?.id,
        "lang": LocalStorage.getLanguage()?.locale ?? "en"
      };

      final client = dioHttp.client(requireAuth: true);
      final response =
      await client.get('/api/v1/rest/referral', queryParameters: data);
      return ApiResult.success(
        data: ReferralModel.fromJson(response.data["data"]),
      );
    } catch (e) {
      debugPrint('==> get referral details failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<dynamic>> saveLocation({required AddressNewModel? address}) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post('/api/v1/dashboard/user/addresses',
          data: address?.toJson());
      return const ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<dynamic>> updateLocation({
    required AddressNewModel? address,
    required int? addressId
  }) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.put(
        '/api/v1/dashboard/user/addresses/$addressId',
        data: address?.toJson(),
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<dynamic>> setActiveAddress({required int id}) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post('/api/v1/dashboard/user/address/set-active/$id');
      return const ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<dynamic>> deleteAddress({required int id}) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.delete('/api/v1/dashboard/user/addresses/delete?ids[0]=$id');
      return const ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<dynamic>> deleteAccount() async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.delete(
        '/api/v1/dashboard/user/profile/delete',
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<dynamic>> logoutAccount({required String fcm}) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/auth/logout',
        data: {"firebase_token": fcm},
      );
      LocalStorage.logout();
      return const ApiResult.success(data: null);
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ProfileResponse>> editProfile({required EditProfile? user}) async {
    final data = user?.toJson();
    debugPrint('===> update general info data ${jsonEncode(data)}');
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.put(
        '/api/v1/dashboard/user/profile/update',
        data: data,
      );
      return ApiResult.success(
        data: ProfileResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> update profile details failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ProfileResponse>> updateProfileImage({
    required String firstName,
    required String imageUrl,
  }) async {
    final data = {
      'firstname': firstName,
      'images': [imageUrl],
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.put(
        '/api/v1/dashboard/user/profile/update',
        data: data,
      );
      return ApiResult.success(
        data: ProfileResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> update profile image failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ProfileResponse>> updatePassword({
    required String password,
    required String passwordConfirmation,
  }) async {
    final data = {
      'password': password,
      'password_confirmation': passwordConfirmation,
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.post(
        '/api/v1/dashboard/user/profile/password/update',
        data: data,
      );
      return ApiResult.success(
        data: ProfileResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> update password failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<WalletHistoriesResponse>> getWalletHistories(int page) async {
    final data = {
      'page': page,
      if (LocalStorage.getSelectedCurrency() != null)
        'currency_id': LocalStorage.getSelectedCurrency()?.id,
      "lang": LocalStorage.getLanguage()?.locale ?? "en"
    };
    try {
      final client = dioHttp.client(requireAuth: true);
      final response = await client.get(
        '/api/v1/dashboard/user/wallet/histories',
        queryParameters: data,
      );
      return ApiResult.success(
        data: WalletHistoriesResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get wallet histories failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<void>> updateFirebaseToken(String? token) async {
    final data = {if (token != null) 'firebase_token': token};
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/dashboard/user/profile/firebase/token/update',
        data: data,
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> update firebase token failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<dynamic> searchUser({
    required String name, // Renamed from searchTerm to name to match interface
    required int page
  }) async {
    // Only search if we have a valid email or phone
    if (name.trim().isEmpty) {
      return <UserModel>[];
    }

    // Determine if it's an email or phone
    bool isEmail = AppValidators.isValidEmail(name.trim());
    bool isPhone = name.trim().replaceAll(RegExp(r'[^0-9]'), '').length >= 7;

    if (!isEmail && !isPhone) {
      return <UserModel>[]; // Don't search if input is neither valid email nor phone
    }

    final data = {
      'page': page,
      // Use the appropriate parameter based on input type
      isEmail ? 'email' : 'phone': name.trim(),
      'currency_id': LocalStorage.getSelectedCurrency()?.id,
    };

    try {
      final client = dioHttp.client(requireAuth: true);

      debugPrint('==> Searching users with: $data');

      final response = await client.get(
        '/api/v1/dashboard/user/search-sending',
        queryParameters: data,
      );

      // Convert to your model
      final searchResponse = SearchUserResponse.fromJson(response.data);
      return searchResponse.data ?? <UserModel>[];
    } catch (e) {
      debugPrint('==> search user failure: $e');
      return AppHelpers.errorHandler(e);
    }
  }
}