import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/infrastructure/services/enums.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/local_storage.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:foodyman/presentation/components/app_bars/app_bar_bottom_sheet.dart';
import 'package:foodyman/presentation/components/buttons/custom_button.dart';
import 'package:foodyman/presentation/components/buttons/forgot_text_button.dart';
import 'package:foodyman/presentation/components/buttons/social_button.dart';
import 'package:foodyman/presentation/components/keyboard_dismisser.dart';
import 'package:foodyman/presentation/components/text_fields/outline_bordered_text_field.dart';
import 'package:foodyman/presentation/pages/auth/reset/reset_password_page.dart';
import 'package:foodyman/app_constants.dart';
import 'package:foodyman/presentation/theme/app_style.dart';
import 'package:foodyman/application/auth/auth.dart';

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
                        if (AppConstants.signUpType == SignUpType.phone)
                          Directionality(
                            textDirection:
                                isLtr ? TextDirection.ltr : TextDirection.rtl,
                            child: IntlPhoneField(
                              onChanged: (phoneNum) {
                                event.setEmail(phoneNum.completeNumber);
                              },
                              disableLengthCheck:
                                  !AppConstants.isNumberLengthAlwaysSame,
                              validator: (s) {
                                if (AppConstants.isNumberLengthAlwaysSame &&
                                    (s?.isValidNumber() ?? true)) {
                                  return AppHelpers.getTranslation(
                                      TrKeys.phoneNumberIsNotValid);
                                }
                                return null;
                              },
                              keyboardType: TextInputType.phone,
                              initialCountryCode: AppConstants.countryCodeISO,
                              invalidNumberMessage: AppHelpers.getTranslation(
                                  TrKeys.phoneNumberIsNotValid),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              showCountryFlag: AppConstants.showFlag,
                              showDropdownIcon: AppConstants.showArrowIcon,
                              autovalidateMode:
                                  AppConstants.isNumberLengthAlwaysSame
                                      ? AutovalidateMode.onUserInteraction
                                      : AutovalidateMode.disabled,
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                counterText: '',
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.merge(
                                        const BorderSide(
                                            color: AppStyle.differBorderColor),
                                        const BorderSide(
                                            color:
                                                AppStyle.differBorderColor))),
                                errorBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.merge(
                                        const BorderSide(
                                            color: AppStyle.differBorderColor),
                                        const BorderSide(
                                            color:
                                                AppStyle.differBorderColor))),
                                border: const UnderlineInputBorder(),
                                focusedErrorBorder:
                                    const UnderlineInputBorder(),
                                disabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.merge(
                                        const BorderSide(
                                            color: AppStyle.differBorderColor),
                                        const BorderSide(
                                            color:
                                                AppStyle.differBorderColor))),
                                focusedBorder: const UnderlineInputBorder(),
                              ),
                            ),
                          ),
                        if (AppConstants.signUpType == SignUpType.both)
                          OutlinedBorderTextField(
                            textCapitalization: TextCapitalization.none,
                            label: AppHelpers.getTranslation(
                                    TrKeys.emailOrPhoneNumber)
                                .toUpperCase(),
                            onChanged: event.setEmail,
                            isError: state.isEmailNotValid,
                            validation: (s) {
                              if (s?.isEmpty ?? true) {
                                return AppHelpers.getTranslation(
                                    TrKeys.emailIsNotValid);
                              }
                              return null;
                            },
                            descriptionText: state.isEmailNotValid
                                ? AppHelpers.getTranslation(
                                    TrKeys.emailIsNotValid)
                                : null,
                          ),
                        if (AppConstants.signUpType == SignUpType.email)
                          OutlinedBorderTextField(
                            textCapitalization: TextCapitalization.none,
                            label: AppHelpers.getTranslation(TrKeys.email)
                                .toUpperCase(),
                            onChanged: event.setEmail,
                            isError: state.isEmailNotValid,
                            validation: (s) {
                              if (s?.isEmpty ?? true) {
                                return AppHelpers.getTranslation(
                                    TrKeys.emailIsNotValid);
                              }
                              return null;
                            },
                            descriptionText: state.isEmailNotValid
                                ? AppHelpers.getTranslation(
                                    TrKeys.emailIsNotValid)
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
                              color: isDarkMode
                                  ? AppStyle.black
                                  : AppStyle.hintColor,
                              size: 20.r,
                            ),
                            onPressed: () =>
                                event.setShowPassword(!state.showPassword),
                          ),
                          onChanged: event.setPassword,
                          isError: state.isPasswordNotValid,
                          descriptionText: state.isPasswordNotValid
                              ? AppHelpers.getTranslation(TrKeys
                                  .passwordShouldContainMinimum8Characters)
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
                          if (key.currentState?.validate() ?? false) {
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (Theme.of(context).platform == TargetPlatform.iOS)
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
                      if (AppConstants.isDemo)
                        Column(
                          children: [
                            InkWell(
                              // onTap: () {
                              //   email.text = AppConstants.demoSellerLogin;
                              //   password.text = AppConstants.demoSellerPassword;
                              // },
                              child: Row(
                                children: [
                                  const Spacer(),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          text:
                                          '${AppHelpers.getTranslation(TrKeys.login)}:',
                                          style: AppStyle.interNormal(
                                              letterSpacing: -0.3),
                                          children: [
                                            TextSpan(
                                              text:
                                              ' ${AppConstants.demoUserLogin}',
                                              style: AppStyle.interRegular(
                                                letterSpacing: -0.3,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      6.verticalSpace,
                                      RichText(
                                        text: TextSpan(
                                          text:
                                          '${AppHelpers.getTranslation(TrKeys.password)}:',
                                          style: AppStyle.interNormal(
                                              letterSpacing: -0.3),
                                          children: [
                                            TextSpan(
                                              text:
                                              ' ${AppConstants.demoUserPassword}',
                                              style: AppStyle.interRegular(
                                                letterSpacing: -0.3,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
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
