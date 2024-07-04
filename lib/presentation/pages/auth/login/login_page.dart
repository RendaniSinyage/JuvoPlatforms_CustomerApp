// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/application/language/language_provider.dart';
import 'package:riverpodtemp/application/main/main_provider.dart';
import 'package:riverpodtemp/infrastructure/services/app_constants.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/local_storage.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/buttons/custom_button.dart';
import 'package:riverpodtemp/presentation/pages/auth/register/register_page.dart';
import 'package:riverpodtemp/presentation/routes/app_router.dart';
import '../../profile/language_page.dart';
import 'login_screen.dart';
import '../../../../application/login/login_provider.dart';

import '../../../theme/app_style.dart';
import 'package:riverpodtemp/presentation/components/buttons/second_button.dart';
import 'package:riverpodtemp/infrastructure/services/app_assets.dart';
import 'package:riverpodtemp/presentation/pages/intro/intro_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:riverpodtemp/presentation/pages/profile/help_policy_term/policy_page.dart';
//import 'package:riverpodtemp/presentation/pages/profile/help_policy_term/term_page.dart';
import 'package:riverpodtemp/presentation/pages/policy_term/policy_page.dart';
import 'package:riverpodtemp/presentation/pages/policy_term/term_page.dart';

@RoutePage()
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool _showIntro = false;
  late IntroPage _introPage;
  final FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(loginProvider.notifier).checkLanguage(context);
    });
    initDynamicLinks();
    // Initialize IntroPage
    _introPage = const IntroPage();
    super.initState();
  }

  Future<void> initDynamicLinks() async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      String link = dynamicLinkData.link
          .toString()
          .substring(dynamicLinkData.link.toString().indexOf("shop") + 4);
      if (link.toString().contains("product") ||
          link.toString().contains("shop") ||
          link.toString().contains("restaurant")) {
        if (AppConstants.isDemo) {
          context.replaceRoute(UiTypeRoute());
          return;
        }
        context.replaceRoute(const MainRoute());
      }
    }).onError((error) {
      debugPrint(error.message);
    });

    final PendingDynamicLinkData? data =
    await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink.toString().contains("product") ||
        deepLink.toString().contains("shop") ||
        deepLink.toString().contains("restaurant")) {
      if (AppConstants.isDemo) {
        context.replaceRoute(UiTypeRoute());
        return;
      }
      context.replaceRoute(const MainRoute());
    }
  }

  void selectLanguage() {
    AppHelpers.showCustomModalBottomSheet(
        isDismissible: false,
        isDrag: false,
        context: context,
        modal: LanguageScreen(
          onSave: () {
            Navigator.pop(context);
          },
        ),
        isDarkMode: false);
  }
  void _showIntroPage() {
    setState(() {
      _showIntro = true;
    });
  }

  void _closeIntroPage() {
    setState(() {
      _showIntro = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    ref.watch(languageProvider);
    ref.listen(loginProvider, (previous, next) {
      if (!next.isSelectLanguage &&
          !((previous?.isSelectLanguage ?? false) == next.isSelectLanguage)) {
        selectLanguage();
      }
    });

    final bool isDarkMode = LocalStorage.getAppThemeMode();
    final bool isLtr = LocalStorage.getLangLtr();
    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor:
        isDarkMode ? AppStyle.dontHaveAnAccBackDark : AppStyle.white,
        body: _showIntro
            ? _introPage // Show preloaded IntroPage if _showIntro is true
            : Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/splash.png",
                ),
                fit: BoxFit.fill,
              )),
          child: SafeArea(
            child: Padding(
              padding: REdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        AppAssets.pngLogo,
                        width: 50.r,
                        height: 50.r,
                      ),
                      Expanded(
                        child: Text(
                          AppHelpers.getAppName() ?? "",
                          style: AppStyle.interSemi(color: AppStyle.brandGreen),
                        ),
                      ),
                      8.horizontalSpace,
                      const Spacer(),
                      const Spacer(),
                      SecondButton(
                        onTap: _showIntroPage, // Show IntroPage when Skip is tapped
                        title: AppHelpers.getTranslation(TrKeys.skip),
                        bgColor: AppStyle.brandGreen,
                        titleColor: AppStyle.white,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      CustomButton(
                        title: AppHelpers.getTranslation(TrKeys.login),
                        onPressed: () {
                          AppHelpers.showCustomModalBottomSheet(
                            context: context,
                            modal: const LoginScreen(),
                            isDarkMode: isDarkMode,
                          );
                        },
                      ),
                      10.verticalSpace,
                      CustomButton(
                        title: AppHelpers.getTranslation(TrKeys.register),
                        onPressed: () {
                          AppHelpers.showCustomModalBottomSheet(
                            context: context,
                            modal: RegisterPage(isOnlyEmail: true),
                            isDarkMode: isDarkMode,
                            paddingTop: MediaQuery.of(context).padding.top,
                          );
                        },
                        background: AppStyle.transparent,
                        textColor: AppStyle.white,
                        borderColor: AppStyle.white,
                      ),
                      5.verticalSpace,
                      Container(
                        decoration: BoxDecoration(
                          color: AppStyle.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
                        ),
                        padding: EdgeInsets.all(16), // Adjust the padding as needed
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Text(
                              "By using ${AppHelpers.getAppName() ?? ""}'s services, you acknowledge that you have read and accepted the",
                              style: TextStyle(color: AppStyle.black), // Make text color white for visibility
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const TermPage(),
                                  ),
                                );
                              },
                              child: Text(
                                AppHelpers.getTranslation(TrKeys.terms),
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: AppStyle.black, // Optional: Different color for links
                                ),
                              ),
                            ),
                            const Text(
                              " & ",
                              style: TextStyle(color: AppStyle.black), // Make text color white for visibility
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PolicyPage(),
                                  ),
                                );
                              },
                              child: Text(
                                AppHelpers.getTranslation(TrKeys.privacyPolicy),
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: AppStyle.black, // Optional: Different color for links
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      20.verticalSpace,

                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
