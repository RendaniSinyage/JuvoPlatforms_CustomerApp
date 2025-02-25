import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/infrastructure/services/enums.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:foodyman/infrastructure/models/data/user.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/local_storage.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:foodyman/presentation/components/app_bars/app_bar_bottom_sheet.dart';
import 'package:foodyman/presentation/components/buttons/custom_button.dart';
import 'package:foodyman/presentation/components/buttons/social_button.dart';
import 'package:foodyman/presentation/components/keyboard_dismisser.dart';
import 'package:foodyman/presentation/components/text_fields/outline_bordered_text_field.dart';
import 'package:foodyman/app_constants.dart';
import 'package:foodyman/presentation/theme/theme.dart';
import 'package:foodyman/application/auth/auth.dart';
import '../confirmation/register_confirmation_page.dart';

@RoutePage()
class RegisterPage extends ConsumerStatefulWidget {
  final bool isOnlyEmail;

  const RegisterPage({
    super.key,
    required this.isOnlyEmail,
  });

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final phoneNumKey = GlobalKey<FormState>();

  // Add local SignUpType variable to track the current state
  late SignUpType currentSignUpType;

  @override
  void initState() {
    super.initState();
    // Initialize with the global value
    currentSignUpType = AppConstants.signUpType;
  }

  // Method to toggle between phone and email sign up types
  void toggleSignUpType() {
    setState(() {
      if (currentSignUpType == SignUpType.phone) {
        currentSignUpType = SignUpType.email;
      } else {
        currentSignUpType = SignUpType.phone;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final event = ref.read(registerProvider.notifier);
    final state = ref.watch(registerProvider);
    final bool isDarkMode = LocalStorage.getAppThemeMode();
    final bool isLtr = LocalStorage.getLangLtr();
    final bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      children: [
                        AppBarBottomSheet(
                          title: AppHelpers.getTranslation(TrKeys.register),
                        ),

                        // Add segmented control for iOS
                        if (isIOS && widget.isOnlyEmail)
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 16.h),
                            child: CupertinoSegmentedControl<SignUpType>(
                              children: {
                                SignUpType.phone: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                                  child: Text(AppHelpers.getTranslation(TrKeys.phone)),
                                ),
                                SignUpType.email: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                                  child: Text(AppHelpers.getTranslation(TrKeys.email)),
                                ),
                              },
                              onValueChanged: (SignUpType value) {
                                setState(() {
                                  currentSignUpType = value;
                                });
                              },
                              groupValue: currentSignUpType,
                            ),
                          ),

                        if (widget.isOnlyEmail &&
                            currentSignUpType == SignUpType.phone)
                          Form(
                            key: phoneNumKey,
                            child: Directionality(
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
                                showCountryFlag: AppConstants.showFlag,
                                showDropdownIcon: AppConstants.showArrowIcon,
                                keyboardType: TextInputType.phone,
                                initialCountryCode: AppConstants.countryCodeISO,
                                invalidNumberMessage: AppHelpers.getTranslation(
                                    TrKeys.phoneNumberIsNotValid),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
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
                          ),
                        if (widget.isOnlyEmail &&
                            currentSignUpType != SignUpType.phone)
                          OutlinedBorderTextField(
                            label: AppHelpers.getTranslation(
                                currentSignUpType == SignUpType.both
                                    ? TrKeys.emailOrPhoneNumber
                                    : TrKeys.email)
                                .toUpperCase(),
                            textCapitalization: TextCapitalization.none,
                            onChanged: event.setEmail,
                            isError: state.isEmailInvalid,
                            descriptionText: state.isEmailInvalid
                                ? AppHelpers.getTranslation(
                                TrKeys.emailIsNotValid)
                                : null,
                          ),
                        if (!widget.isOnlyEmail)
                          Column(
                            children: [
                              (state.verificationId.isEmpty)
                                  ? 30.verticalSpace
                                  : 0.verticalSpace,
                              (state.verificationId.isEmpty)
                                  ? OutlinedBorderTextField(
                                label: AppHelpers.getTranslation(
                                    TrKeys.phoneNumber)
                                    .toUpperCase(),
                                onChanged: event.setPhone,
                              )
                                  : const SizedBox.shrink(),
                              30.verticalSpace,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width:
                                    (MediaQuery.sizeOf(context).width - 40) /
                                        2,
                                    child: OutlinedBorderTextField(
                                      label: AppHelpers.getTranslation(
                                          TrKeys.firstname)
                                          .toUpperCase(),
                                      onChanged: (name) =>
                                          event.setFirstName(name),
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                    (MediaQuery.sizeOf(context).width - 40) /
                                        2,
                                    child: OutlinedBorderTextField(
                                      label: AppHelpers.getTranslation(
                                          TrKeys.surname)
                                          .toUpperCase(),
                                      onChanged: (name) => event.setLatName(name),
                                    ),
                                  ),
                                ],
                              ),
                              30.verticalSpace,
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
                                  onPressed: () => event.toggleShowPassword(),
                                ),
                                onChanged: (name) => event.setPassword(name),
                                isError: state.isPasswordInvalid,
                                descriptionText: state.isPasswordInvalid
                                    ? AppHelpers.getTranslation(TrKeys
                                    .passwordShouldContainMinimum8Characters)
                                    : null,
                              ),
                              34.verticalSpace,
                              OutlinedBorderTextField(
                                label: AppHelpers.getTranslation(TrKeys.password)
                                    .toUpperCase(),
                                obscure: state.showConfirmPassword,
                                suffixIcon: IconButton(
                                  splashRadius: 25,
                                  icon: Icon(
                                    state.showConfirmPassword
                                        ? FlutterRemix.eye_line
                                        : FlutterRemix.eye_close_line,
                                    color: isDarkMode
                                        ? AppStyle.black
                                        : AppStyle.hintColor,
                                    size: 20.r,
                                  ),
                                  onPressed: () =>
                                      event.toggleShowConfirmPassword(),
                                ),
                                onChanged: (name) =>
                                    event.setConfirmPassword(name),
                                isError: state.isConfirmPasswordInvalid,
                                descriptionText: state.isConfirmPasswordInvalid
                                    ? AppHelpers.getTranslation(
                                    TrKeys.confirmPasswordIsNotTheSame)
                                    : null,
                              ),
                              30.verticalSpace,
                              OutlinedBorderTextField(
                                label: AppHelpers.getTranslation(TrKeys.referral)
                                    .toUpperCase(),
                                onChanged: event.setReferral,
                              ),
                            ],
                          ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 30.h),
                      child: CustomButton(
                        isLoading: state.isLoading,
                        title: AppHelpers.getTranslation(TrKeys.register),
                        onPressed: () {
                          if (widget.isOnlyEmail) {
                            if (event.checkEmail()) {
                              event.sendCode(context, () {
                                Navigator.pop(context);
                                AppHelpers.showCustomModalBottomSheet(
                                  context: context,
                                  modal: RegisterConfirmationPage(
                                      verificationId: "",
                                      userModel: UserModel(
                                          firstname: state.firstName,
                                          lastname: state.lastName,
                                          phone: state.phone,
                                          email: state.email,
                                          password: state.password,
                                          confirmPassword:
                                          state.confirmPassword)),
                                  isDarkMode: isDarkMode,
                                );
                              });
                            } else {
                              if (currentSignUpType == SignUpType.phone) {
                                if (!(phoneNumKey.currentState?.validate() ??
                                    false)) {
                                  return;
                                }
                              }
                              event.sendCodeToNumber(context, (s) {
                                Navigator.pop(context);
                                AppHelpers.showCustomModalBottomSheet(
                                  context: context,
                                  modal: RegisterConfirmationPage(
                                      verificationId: s,
                                      userModel: UserModel(
                                          firstname: state.firstName,
                                          lastname: state.lastName,
                                          phone: state.phone,
                                          email: state.email,
                                          password: state.password,
                                          confirmPassword:
                                          state.confirmPassword)),
                                  isDarkMode: isDarkMode,
                                );
                              });
                            }
                          } else {
                            if (state.verificationId.isEmpty) {
                              event.register(context);
                            } else {
                              if (AppConstants.isPhoneFirebase) {
                                event.registerWithFirebase(context);
                              } else {
                                event.registerWithPhone(context);
                              }
                            }
                          }
                        },
                      ),
                    ),
                    widget.isOnlyEmail
                        ? Column(
                      children: [
                        32.verticalSpace,
                        Row(children: <Widget>[
                          Expanded(
                            child: Divider(
                              color: AppStyle.black.withOpacity(0.5),
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(right: 12, left: 12),
                            child: Text(
                              AppHelpers.getTranslation(
                                  TrKeys.orAccessQuickly),
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
                            if (isIOS)
                              SocialButton(
                                  iconData: FlutterRemix.apple_fill,
                                  onPressed: () {
                                    event.loginWithApple(context);
                                  },
                                  title: "Apple"),
                            // Add toggle button for email/phone when on Android
                            if (!isIOS)
                              SocialButton(
                                  iconData: currentSignUpType == SignUpType.phone
                                      ? FlutterRemix.mail_fill
                                      : FlutterRemix.phone_fill,
                                  onPressed: toggleSignUpType,
                                  title: currentSignUpType == SignUpType.phone
                                      ? "Email"
                                      : "Phone"),
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
                    )
                        : SizedBox(
                      height: 32.h,
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