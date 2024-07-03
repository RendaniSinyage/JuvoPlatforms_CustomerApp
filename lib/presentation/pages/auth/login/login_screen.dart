import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/local_storage.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/app_bars/app_bar_bottom_sheet.dart';
import 'package:riverpodtemp/presentation/components/buttons/custom_button.dart';
import 'package:riverpodtemp/presentation/components/buttons/forgot_text_button.dart';
import 'package:riverpodtemp/presentation/components/buttons/social_button.dart';
import 'package:riverpodtemp/presentation/components/keyboard_dismisser.dart';
import 'package:riverpodtemp/presentation/components/text_fields/outline_bordered_text_field.dart';
import 'package:riverpodtemp/presentation/pages/auth/reset/reset_password_page.dart';

import '../../../theme/app_style.dart';
import '../../../../application/login/login_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    final event = ref.read(loginProvider.notifier);
    final state = ref.watch(loginProvider);
    final bool isDarkMode = LocalStorage.getAppThemeMode();
    final bool isLtr = LocalStorage.getLangLtr();
    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: KeyboardDismisser(
        child: Container(
          margin: MediaQuery.of(context).viewInsets,
          decoration: BoxDecoration(
              color: AppStyle.bgGrey.withOpacity(0.96),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              )),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Form(
                    key: key,
                    child: Column(
                      children: [
                        AppBarBottomSheet(
                          title: AppHelpers.getTranslation(TrKeys.login),
                        ),
                        OutlinedBorderTextField(
                          label:
                              AppHelpers.getTranslation(TrKeys.emailOrPhoneNumber)
                                  .toUpperCase(),
                          onChanged: event.setEmail,
                          isError: state.isEmailNotValid,
                          validation: (s){
                            if(s?.isEmpty ?? true){
                              return AppHelpers.getTranslation(TrKeys.emailIsNotValid);
                            }
                            return null;
                          },
                          descriptionText: state.isEmailNotValid
                              ? AppHelpers.getTranslation(TrKeys.emailIsNotValid)
                              : null,
                        ),
                        34.verticalSpace,
                        OutlinedBorderTextField(
                          label: AppHelpers.getTranslation(TrKeys.password)
                              .toUpperCase(),
                          obscure: state.showPassword,
                          suffixIcon: IconButton(
                            splashRadius: 25,
                            icon: Icon(
                              state.showPassword
                                  ? FlutterRemix.eye_line
                                  : FlutterRemix.eye_close_line,
                              color: isDarkMode ? AppStyle.black : AppStyle.hintColor,
                              size: 20.r,
                            ),
                            onPressed: () =>
                                event.setShowPassword(!state.showPassword),
                          ),
                          onChanged: event.setPassword,
                          isError: state.isPasswordNotValid,
                          descriptionText: state.isPasswordNotValid
                              ? AppHelpers.getTranslation(
                                  TrKeys.passwordShouldContainMinimum8Characters)
                              : null,
                        ),
                        30.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: 20.h,
                                  width: 20.w,
                                  child: Checkbox(
                                    side: BorderSide(
                                      color: AppStyle.black,
                                      width: 2.r,
                                    ),
                                    activeColor: AppStyle.black,
                                    value: state.isKeepLogin,
                                    onChanged: (value) =>
                                        event.setKeepLogin(value!),
                                  ),
                                ),
                                8.horizontalSpace,
                                Text(
                                  AppHelpers.getTranslation(TrKeys.keepLogged),
                                  style: AppStyle.interNormal(
                                    size: 12.sp,
                                    color: AppStyle.black,
                                  ),
                                ),
                              ],
                            ),
                            ForgotTextButton(
                              title: AppHelpers.getTranslation(
                                TrKeys.forgotPassword,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                AppHelpers.showCustomModalBottomSheet(
                                  context: context,
                                  modal: const ResetPasswordPage(),
                                  isDarkMode: isDarkMode,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      CustomButton(
                        isLoading: state.isLoading,
                        title: 'Login',
                        onPressed: () {
                          if(key.currentState?.validate() ?? false){
                            event.login(context);
                          }

                        },
                      ),
                      32.verticalSpace,
                      Row(children: <Widget>[
                        Expanded(
                            child: Divider(
                          color: AppStyle.black.withOpacity(0.5),
                        )),
                        Padding(
                          padding: const EdgeInsets.only(right: 12, left: 12),
                          child: Text(
                            AppHelpers.getTranslation(TrKeys.orAccessQuickly),
                            style: AppStyle.interNormal(
                              size: 12.sp,
                              color: AppStyle.textGrey,
                            ),
                          ),
                        ),
                        Expanded(
                            child: Divider(
                          color: AppStyle.black.withOpacity(0.5),
                        )),
                      ]),
                      22.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SocialButton(
                              iconData: FlutterRemix.apple_fill,
                              onPressed: () {
                                event.loginWithApple(context);
                              },
                              title: "Apple"),
                          SocialButton(
                              iconData: FlutterRemix.facebook_fill,
                              onPressed: () {
                                event.loginWithFacebook(context);
                              },
                              title: "Facebook"),
                          SocialButton(
                              iconData: FlutterRemix.google_fill,
                              onPressed: () {
                                event.loginWithGoogle(context);
                              },
                              title: "Google"),
                        ],
                      ),
                      22.verticalSpace,
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
