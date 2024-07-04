import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/infrastructure/services/local_storage.dart';
import 'package:riverpodtemp/presentation/components/buttons/pop_button.dart';
//import 'package:riverpodtemp/presentation/pages/auth/reset/set_password_page.dart';
import 'package:riverpodtemp/presentation/routes/app_router.dart';
import 'package:riverpodtemp/presentation/theme/app_style.dart';
//import '../../../../application/edit_profile/edit_profile_provider.dart';
import 'package:riverpodtemp/presentation/components/buttons/button_item.dart';
import 'package:riverpodtemp/presentation/pages/profile/edit_profile_page.dart';
//import 'package:riverpodtemp/application/profile/profile_provider.dart';
//import 'package:riverpodtemp/presentation/components/app_bars/common_app_bar.dart';
//import 'package:riverpodtemp/infrastructure/services/local_storage.dart';
import 'package:riverpodtemp/presentation/pages/auth/reset/reset_password_page.dart';
import 'package:riverpodtemp/presentation/pages/profile/currency_page.dart';
import 'package:riverpodtemp/presentation/pages/profile/language_page.dart';
//import 'package:riverpodtemp/application/like/like_provider.dart';
class MyAccount extends StatelessWidget {
  final bool isBackButton;


  const MyAccount({ super.key,
    this.isBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = LocalStorage.getAppThemeMode();
    final bool isLtr = LocalStorage.getLangLtr();
    return Directionality(
        textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
        child:  Scaffold(backgroundColor: isDarkMode ? AppStyle.mainBackDark : AppStyle.bgGrey,
      body:
        Column(
          children: [
            Row(
              children: [
               // const PopButton(),
                const SizedBox(width: 20, height: 120),
             //  CommonAppBar( child:
                SafeArea(child:
               Text(
                  AppHelpers.getTranslation(TrKeys.account),
                  style: AppStyle.interNoSemi(
                    color: Colors.black,
                    size: 18,
                  ),
                ),),
                const Spacer(),

              ],
            ),
            const SizedBox(height: 24),
            ButtonItem(
              isLtr: isLtr,
              
              icon: FlutterRemix.edit_2_line,
              title: AppHelpers.getTranslation(TrKeys.editAccount),
              onTap: () {
              //  ref.refresh(editProfileProvider);
                AppHelpers.showCustomModalBottomDragSheet(
                  context: context,
                  modal: (c) => EditProfileScreen(
                    controller: c,
                  ),
                  isDarkMode: isDarkMode,
                );
              },
            ),
            ButtonItem(
              isLtr: isLtr,
              icon: FlutterRemix.lock_2_line,
              title: AppHelpers.getTranslation(TrKeys.changePassword),
              onTap:  () {
            Navigator.pop(context);
            AppHelpers.showCustomModalBottomSheet(
            context: context,
            modal: const ResetPasswordPage(),
            isDarkMode: isDarkMode,
            );
            },
            ),
            ButtonItem(
              isLtr: isLtr,
              icon: FlutterRemix.hotel_line,
              title: AppHelpers.getTranslation(TrKeys.deliveryTo),
              onTap: () {
                context.pushRoute(const AddressListRoute());
              },
            ),
            ButtonItem(
              isLtr: isLtr,
              icon: FlutterRemix.settings_3_line,
              title: AppHelpers.getTranslation(TrKeys.notifications),
              onTap: () {
                context.pushRoute(const SettingRoute());
              },
            ),
            ButtonItem(
              isLtr: isLtr,
              title: AppHelpers.getTranslation(
                  TrKeys.language),
              icon: FlutterRemix.global_line,
              onTap: () {
                AppHelpers.showCustomModalBottomSheet(
                  isDismissible: false,
                  context: context,
                  modal: LanguageScreen(
                    onSave: () {
                      Navigator.pop(context);

                    },
                  ),
                  isDarkMode: isDarkMode,
                );
              },
            ),
            ButtonItem(
              isLtr: isLtr,
              title: AppHelpers.getTranslation(
                  TrKeys.currencies),
              icon: FlutterRemix.bank_card_line,
              onTap: () {
                AppHelpers.showCustomModalBottomSheet(
                  context: context,
                  modal: const CurrencyScreen(),
                  isDarkMode: isDarkMode,
                );
              },
            ),

          ],
        ),

      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: //isBackButton ?
       Padding(
        padding: EdgeInsets.only(left: 16.w),
        child: const PopButton(),
      )
         // : const SizedBox.shrink(),
    ),);
  }
}