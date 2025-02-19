import 'package:foodyman/infrastructure/models/data/user.dart';
import 'package:foodyman/infrastructure/models/models.dart';

import 'package:foodyman/domain/handlers/handlers.dart';

abstract class AuthRepositoryFacade {
  Future<ApiResult<LoginResponse>> login({
    required String email,
    required String password,
  });

  Future<ApiResult<LoginResponse>> loginWithGoogle(
      {required String email,
      required String displayName,
      required String id,
      required String avatar});

  Future<ApiResult<dynamic>> sigUp({
    required String email,
  });

  Future<ApiResult<VerifyData>> sigUpWithData({
    required UserModel user,
  });

  Future<ApiResult<VerifyData>> sigUpWithPhone({
    required UserModel user,
  });

  Future<ApiResult<RegisterResponse>> sendOtp({required String phone});

  Future<ApiResult<RegisterResponse>> forgotPassword({required String email});

  Future<ApiResult<VerifyPhoneResponse>> verifyEmail({
    required String verifyCode,
  });

  Future<ApiResult<VerifyPhoneResponse>> verifyPhone({
    required String verifyCode,
    required String verifyId,
  });

  Future<ApiResult<VerifyData>> forgotPasswordConfirm({
    required String verifyCode,
    required String email,
  });

  Future<ApiResult<VerifyData>> forgotPasswordConfirmWithPhone({
    required String phone,
  });
}
