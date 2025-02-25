import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodyman/domain/handlers/api_result.dart';
import 'package:foodyman/domain/interface/auth.dart';
import 'package:foodyman/infrastructure/models/data/address_new_data.dart';
import 'package:foodyman/infrastructure/models/data/address_old_data.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/infrastructure/services/app_connectivity.dart';
import 'package:foodyman/app_constants.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/local_storage.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:foodyman/domain/interface/user.dart';
import '../../main/main_provider.dart';
import 'register_confirmation_state.dart';

class RegisterConfirmationNotifier
    extends StateNotifier<RegisterConfirmationState> {
  final AuthRepositoryFacade _authRepository;
  final UserRepositoryFacade _userRepositoryFacade;

  RegisterConfirmationNotifier(
    this._authRepository,
    this._userRepositoryFacade,
  ) : super(const RegisterConfirmationState());

  Timer? _timer;
  int _initialTime = 30;

  void setCode(String? code) {
    state = state.copyWith(
        confirmCode: code?.trim() ?? '',
        isCodeError: false,
        isConfirm: code.toString().length == 6);
  }

  // For phone confirmation
  Future<void> confirmCodeWithPhone({
    required BuildContext context,
    required String verificationId,
    VoidCallback? onSuccess,
    required WidgetRef ref,
  }) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isLoading: true, isSuccess: false);
      if (AppConstants.isPhoneFirebase) {
        try {
          PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: state.verificationCode.isNotEmpty
                ? state.verificationCode
                : verificationId,
            smsCode: state.confirmCode,
          );

          await FirebaseAuth.instance.signInWithCredential(credential);
          ref.read(mainProvider.notifier).resetToInitialPage();
          onSuccess?.call();
          state = state.copyWith(
              isLoading: false, isSuccess: onSuccess == null ? true : false);
        } catch (e) {
          if (context.mounted) {
            AppHelpers.showCheckTopSnackBar(
              context,
              AppHelpers.getTranslation(
                  (e as FirebaseAuthException).message ?? ""),
            );
          }
          state = state.copyWith(
              isLoading: false, isCodeError: true, isSuccess: false);
        }
      } else {
        state = state.copyWith(isLoading: true, isSuccess: false);
        final response = await _authRepository.verifyPhone(
          verifyCode: state.confirmCode,
          verifyId: state.verificationCode.isNotEmpty
              ? state.verificationCode
              : verificationId,
        );
        response.when(
          success: (data) async {
            ref.read(mainProvider.notifier).resetToInitialPage();
            state = state.copyWith(isLoading: false, isSuccess: true);
            _timer?.cancel();
            LocalStorage.setToken(data.data?.token);
            LocalStorage.setAddressSelected(AddressData(
              title: data.data?.user?.addresses?.firstWhere(
                      (element) => element.active ?? false, orElse: () {
                    return AddressNewModel();
                  }).title ??
                  "",
              address: data.data?.user?.addresses
                      ?.firstWhere((element) => element.active ?? false,
                          orElse: () {
                        return AddressNewModel();
                      })
                      .address
                      ?.address ??
                  "",
              location: LocationModel(
                longitude: data.data?.user?.addresses
                    ?.firstWhere((element) => element.active ?? false,
                        orElse: () {
                      return AddressNewModel();
                    })
                    .location
                    ?.last,
                latitude: data.data?.user?.addresses
                    ?.firstWhere((element) => element.active ?? false,
                        orElse: () {
                      return AddressNewModel();
                    })
                    .location
                    ?.first,
              ),
            ));
            onSuccess?.call();
          },
          failure: (failure, status) {
            state = state.copyWith(
                isLoading: false, isCodeError: true, isSuccess: false);
            AppHelpers.showCheckTopSnackBar(
              context,
              failure,
            );
            debugPrint('==> confirm code failure: $failure');
          },
        );
      }
    } else {
      if (context.mounted) {
        AppHelpers.showCheckTopSnackBar(
          context,
          AppHelpers.getTranslation(TrKeys.checkYourNetworkConnection),
        );
      }
    }
  }

  // For email confirmation
  Future<void> confirmCode(BuildContext context, WidgetRef ref) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isLoading: true, isSuccess: false);
      final response = await _authRepository.verifyEmail(
        verifyCode: state.confirmCode.trim(),
      );
      response.when(
        success: (data) async {
          ref.read(mainProvider.notifier).resetToInitialPage();
          state = state.copyWith(isLoading: false, isSuccess: true);
          _timer?.cancel();
        },
        failure: (failure, status) {
          state = state.copyWith(
              isLoading: false, isCodeError: true, isSuccess: false);
          AppHelpers.showCheckTopSnackBar(
            context,
            failure,
          );
          debugPrint('==> confirm code failure: $failure');
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showCheckTopSnackBar(
          context,
          AppHelpers.getTranslation(TrKeys.checkYourNetworkConnection),
        );
      }
    }
  }

  Future<void> confirmCodeResetPassword(
      BuildContext context, String email) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isLoading: true, isResetPasswordSuccess: false);
      final response = await _authRepository.forgotPasswordConfirm(
          verifyCode: state.confirmCode.trim(), email: email);
      response.when(
        success: (data) async {
          await LocalStorage.setToken(data.token);
          String? fcmToken = await FirebaseMessaging.instance.getToken();
          _userRepositoryFacade.updateFirebaseToken(fcmToken);
          state =
              state.copyWith(isLoading: false, isResetPasswordSuccess: true);
        },
        failure: (failure, status) {
          state = state.copyWith(isLoading: false, isCodeError: true);
          AppHelpers.showCheckTopSnackBar(
            context,
            AppHelpers.getTranslation(status.toString()),
          );
          debugPrint('==> confirm reset code failure: $failure');
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showCheckTopSnackBar(
          context,
          AppHelpers.getTranslation(TrKeys.checkYourNetworkConnection),
        );
      }
    }
  }

  Future<void> confirmCodeResetPasswordWithPhone(
      BuildContext context, String phone, String verificationId) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isLoading: true, isResetPasswordSuccess: false);
      if (AppConstants.isPhoneFirebase) {
        try {
          PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: state.verificationCode.isNotEmpty
                ? state.verificationCode
                : verificationId,
            smsCode: state.confirmCode,
          );

          await FirebaseAuth.instance.signInWithCredential(credential);

          final response = await _authRepository.forgotPasswordConfirmWithPhone(
              phone: phone);
          response.when(
            success: (data) async {
              await LocalStorage.setToken(data.token);
              String? fcmToken = await FirebaseMessaging.instance.getToken();
              _userRepositoryFacade.updateFirebaseToken(fcmToken);
              state = state.copyWith(
                  isLoading: false, isResetPasswordSuccess: true);
            },
            failure: (failure, status) {
              state = state.copyWith(isLoading: false, isCodeError: true);
              AppHelpers.showCheckTopSnackBar(
                context,
                AppHelpers.getTranslation(status.toString()),
              );
              debugPrint('==> confirm reset code failure: $failure');
            },
          );
        } catch (e) {
          if (context.mounted) {
            AppHelpers.showCheckTopSnackBar(
              context,
              AppHelpers.getTranslation(
                  (e as FirebaseAuthException).message ?? ""),
            );
          }
          state = state.copyWith(isLoading: false, isCodeError: true);
        }
      } else {
        state = state.copyWith(isLoading: true, isResetPasswordSuccess: false);
        final response = await _authRepository.verifyPhone(
          verifyCode: state.confirmCode,
          verifyId: state.verificationCode.isNotEmpty
              ? state.verificationCode
              : verificationId,
        );
        response.when(
          success: (data) async {
            state =
                state.copyWith(isLoading: false, isResetPasswordSuccess: true);
            _timer?.cancel();
            LocalStorage.setToken(data.data?.token);
            LocalStorage.setAddressSelected(AddressData(
              title: data.data?.user?.addresses?.firstWhere(
                      (element) => element.active ?? false, orElse: () {
                    return AddressNewModel();
                  }).title ??
                  "",
              address: data.data?.user?.addresses
                      ?.firstWhere((element) => element.active ?? false,
                          orElse: () {
                        return AddressNewModel();
                      })
                      .address
                      ?.address ??
                  "",
              location: LocationModel(
                longitude: data.data?.user?.addresses
                    ?.firstWhere((element) => element.active ?? false,
                        orElse: () {
                      return AddressNewModel();
                    })
                    .location
                    ?.last,
                latitude: data.data?.user?.addresses
                    ?.firstWhere((element) => element.active ?? false,
                        orElse: () {
                      return AddressNewModel();
                    })
                    .location
                    ?.first,
              ),
            ));
          },
          failure: (failure, status) {
            state = state.copyWith(
                isLoading: false,
                isCodeError: true,
                isResetPasswordSuccess: false);
            AppHelpers.showCheckTopSnackBar(
              context,
              failure,
            );
            debugPrint('==> confirm code failure: $failure');
          },
        );
      }
    } else {
      if (context.mounted) {
        AppHelpers.showCheckTopSnackBar(
          context,
          AppHelpers.getTranslation(TrKeys.checkYourNetworkConnection),
        );
      }
    }
  }

  Future<void> resendConfirmation(BuildContext context, String email,
      {bool isResetPassword = false}) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isResending: true);
      late ApiResult response;
      if (isResetPassword) {
        response = await _authRepository.forgotPassword(email: email.trim());
      } else {
        response = await _authRepository.sigUp(email: email.trim());
      }

      response.when(
        success: (data) async {
          state = state.copyWith(isResending: false);
        },
        failure: (failure, status) {
          state = state.copyWith(isResending: false);
          AppHelpers.showCheckTopSnackBar(
            context,
            AppHelpers.getTranslation(status.toString()),
          );
          debugPrint('==> send otp failure: $failure');
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showCheckTopSnackBar(
          context,
          AppHelpers.getTranslation(TrKeys.checkYourNetworkConnection),
        );
      }
    }
  }

  Future<void> sendCodeToNumber(
      BuildContext context, String phoneNumber) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isResending: true);
      if (AppConstants.isPhoneFirebase) {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) {},
          verificationFailed: (FirebaseAuthException e) {
            AppHelpers.showCheckTopSnackBar(
              context,
              AppHelpers.getTranslation(e.message ?? ""),
            );
            state = state.copyWith(isResending: false);
          },
          codeSent: (String verificationId, int? resendToken) {
            state = state.copyWith(
                isResending: false, verificationCode: verificationId);
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      } else {
        final response = await _authRepository.sendOtp(phone: phoneNumber);
        response.when(
          success: (success) {
            state = state.copyWith(
                isResending: false,
                verificationCode: success.data?.verifyId ?? '');
          },
          failure: (failure, status) {
            AppHelpers.showCheckTopSnackBar(context, failure);
            state = state.copyWith(isResending: false);
          },
        );
      }
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<void> resendResetConfirmation(
      BuildContext context, String phoneNumber) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isResending: true);
      if (AppConstants.isPhoneFirebase) {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) {},
          verificationFailed: (FirebaseAuthException e) {
            AppHelpers.showCheckTopSnackBar(
              context,
              AppHelpers.getTranslation(e.message ?? ""),
            );
            state = state.copyWith(isResending: false);
          },
          codeSent: (String verificationId, int? resendToken) {
            state = state.copyWith(
                isResending: false, verificationCode: verificationId);
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      } else {
        final response =
            await _authRepository.forgotPassword(email: phoneNumber);
        response.when(
          success: (success) {
            state = state.copyWith(
                isResending: false,
                verificationCode: success.data?.verifyId ?? '');
          },
          failure: (failure, status) {
            AppHelpers.showCheckTopSnackBar(context, failure);
            state = state.copyWith(isResending: false);
          },
        );
      }
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  void disposeTimer() {
    _timer?.cancel();
  }

  void startTimer() {
    _timer?.cancel();
    _initialTime = 30;
    state = state.copyWith(
      confirmCode: '',
      isCodeError: false,
    );
    if (_timer != null) {
      _initialTime = 30;
      _timer?.cancel();
    }
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_initialTime < 1) {
          _timer?.cancel();
          state = state.copyWith(
            isTimeExpired: true,
          );
        } else {
          _initialTime--;
          state = state.copyWith(
            isTimeExpired: false,
            timerText: formatHHMMSS(_initialTime),
          );
        }
      },
    );
  }

  void cancelTimer() {
    _timer?.cancel();
  }

  String formatHHMMSS(int seconds) {
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();
    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return "$minutesStr:$secondsStr";
  }
}
