import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:riverpodtemp/application/register/register_provider.dart';
import 'package:riverpodtemp/infrastructure/models/data/user.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/local_storage.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/app_bars/app_bar_bottom_sheet.dart';
import 'package:riverpodtemp/presentation/components/buttons/custom_button.dart';
import 'package:riverpodtemp/presentation/components/keyboard_dismisser.dart';
import 'package:riverpodtemp/presentation/components/text_fields/outline_bordered_text_field.dart';
import 'package:riverpodtemp/presentation/pages/auth/confirmation/register_confirmation_page.dart';
import 'package:riverpodtemp/presentation/theme/app_style.dart';

import '../../../infrastructure/services/app_constants.dart';

class PhoneVerify extends ConsumerWidget {
  const PhoneVerify({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final event = ref.read(registerProvider.notifier);
    final state = ref.watch(registerProvider);
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      AppBarBottomSheet(
                        title: AppHelpers.getTranslation(TrKeys.phoneNumber),
                      ),
                      if (AppConstants.isSpecificNumberEnabled)
                        Directionality(
                          textDirection:
                              isLtr ? TextDirection.ltr : TextDirection.rtl,
                          child: IntlPhoneField(
                            onChanged: (phoneNum) {
                              event.setEmail(phoneNum.completeNumber);
                            },
                            disableLengthCheck: !AppConstants.isNumberLengthAlwaysSame,
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
                                          color: AppStyle.differBorderColor))),
                              errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.merge(
                                      const BorderSide(
                                          color: AppStyle.differBorderColor),
                                      const BorderSide(
                                          color: AppStyle.differBorderColor))),
                              border: const UnderlineInputBorder(),
                              focusedErrorBorder: const UnderlineInputBorder(),
                              disabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.merge(
                                      const BorderSide(
                                          color: AppStyle.differBorderColor),
                                      const BorderSide(
                                          color: AppStyle.differBorderColor))),
                              focusedBorder: const UnderlineInputBorder(),
                            ),
                          ),
                        ),
                      if (!AppConstants.isSpecificNumberEnabled)
                        OutlinedBorderTextField(
                          label: AppHelpers.getTranslation(TrKeys.phoneNumber)
                              .toUpperCase(),
                          onChanged: event.setEmail,
                          isError: state.isEmailInvalid,
                          descriptionText: state.isEmailInvalid
                              ? AppHelpers.getTranslation(
                                  TrKeys.emailIsNotValid)
                              : null,
                        )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30.h),
                    child: CustomButton(
                      background: !state.email.trim().isNotEmpty
                          ? AppStyle.textGrey
                          : AppStyle.brandGreen,
                      isLoading: state.isLoading,
                      title: AppHelpers.getTranslation(TrKeys.next),
                      onPressed: () {
                        if (state.email.trim().isNotEmpty) {
                          event.sendCodeToNumber(context, (s) {
                            Navigator.pop(context);
                            AppHelpers.showCustomModalBottomSheet(
                              context: context,
                              modal: RegisterConfirmationPage(
                                  verificationId: s,
                                  editPhone: true,
                                  userModel: UserModel(
                                      firstname: state.firstName,
                                      lastname: state.lastName,
                                      phone: state.phone,
                                      email: state.email,
                                      password: state.password,
                                      confirmPassword: state.confirmPassword)),
                              isDarkMode: isDarkMode,
                            );
                          });
                        }
                      },
                    ),
                  ),
                  32.verticalSpace
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
