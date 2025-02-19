import 'package:flutter/material.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';
import 'package:foodyman/infrastructure/models/data/login.dart';
import 'package:foodyman/infrastructure/models/data/user.dart';
import 'package:foodyman/infrastructure/models/request/sign_up_request.dart';
import 'package:foodyman/domain/handlers/handlers.dart';
import 'package:foodyman/domain/interface/auth.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/app_validators.dart';
import '../models/models.dart';

class AuthRepository implements AuthRepositoryFacade {
  @override
  Future<ApiResult<LoginResponse>> login({
    required String email,
    required String password,
  }) async {
    final data =
        LoginModel(email: email.replaceAll('+', ""), password: password)
            .toJson();
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.post(
        '/api/v1/auth/login',
        data: data,
      );
      return ApiResult.success(
        data: LoginResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> login failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<LoginResponse>> loginWithGoogle(
      {required String email,
      required String displayName,
      required String id,
      required String avatar}) async {
    final data = {
      'email': email,
      'name': displayName,
      'id': id,
      "avatar": avatar
    };
    debugPrint('===> login request $data');
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.post(
        '/api/v1/auth/google/callback',
        queryParameters: data,
      );
      return ApiResult.success(data: LoginResponse.fromJson(response.data));
    } catch (e) {
      debugPrint('==> login with google failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<RegisterResponse>> sendOtp({required String phone}) async {
    final data = {'phone': phone.replaceAll('+', "")};
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.post(
        '/api/v1/auth/register',
        data: data,
      );
      return ApiResult.success(data: RegisterResponse.fromJson(response.data));
    } catch (e) {
      debugPrint('==> send otp failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<VerifyPhoneResponse>> verifyEmail({
    required String verifyCode,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/v1/auth/verify/$verifyCode',
      );
      return ApiResult.success(
          data: VerifyPhoneResponse.fromJson(response.data));
    } catch (e) {
      debugPrint('==> verify email failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<VerifyPhoneResponse>> verifyPhone({
    required String verifyCode,
    required String verifyId,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.post(
        '/api/v1/auth/verify/phone',
        queryParameters: {
          "verifyId": verifyId,
          "verifyCode": verifyCode,
        },
      );
      return ApiResult.success(
          data: VerifyPhoneResponse.fromJson(response.data));
    } catch (e) {
      debugPrint('==> verify email failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<RegisterResponse>> forgotPassword({
    required String email,
  }) async {
    final data = {
      if (AppValidators.isValidEmail(email)) "email": email,
      if (!AppValidators.isValidEmail(email))
        "phone": email.replaceAll('+', ""),
    };
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.post(
        AppValidators.isValidEmail(email)
            ? '/api/v1/auth/forgot/email-password'
            : '/api/v1/auth/forgot/password',
        queryParameters: data,
      );
      return ApiResult.success(data: RegisterResponse.fromJson(response.data));
    } catch (e) {
      debugPrint('==> forgot password failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<VerifyData>> forgotPasswordConfirm({
    required String verifyCode,
    required String email,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.post(
        '/api/v1/auth/forgot/email-password/$verifyCode?email=${email.replaceAll('+', "")}',
      );

      return ApiResult.success(
        data: VerifyData.fromJson(response.data["data"]),
      );
    } catch (e) {
      debugPrint('==> forgot password confirm failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<VerifyData>> forgotPasswordConfirmWithPhone({
    required String phone,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.post('/api/v1/auth/forgot/password/confirm',
          data: {"phone": phone.replaceAll('+', ""), "type": "firebase"});

      return ApiResult.success(
        data: VerifyData.fromJson(response.data["data"]),
      );
    } catch (e) {
      debugPrint('==> forgot password confirm failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<dynamic>> sigUp({
    required String email,
  }) async {
    final data = SignUpRequest(
      email: email.replaceAll('+', ""),
    );
    try {
      final client = dioHttp.client(requireAuth: false);
      await client.post(
        '/api/v1/auth/register',
        queryParameters: data.toJson(),
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
  Future<ApiResult<VerifyData>> sigUpWithData({required UserModel user}) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      var res = await client.post(
        '/api/v1/auth/after-verify',
        data: user.toJsonForSignUp(),
      );
      return ApiResult.success(
        data: VerifyData.fromJson(res.data["data"]),
      );
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<VerifyData>> sigUpWithPhone(
      {required UserModel user}) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      var res = await client.post(
        '/api/v1/auth/verify/phone',
        data: user.toJsonForSignUp(typeFirebase: true),
      );
      return ApiResult.success(
        data: VerifyData.fromJson(res.data["data"]),
      );
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}
