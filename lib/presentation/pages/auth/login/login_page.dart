// ignore_for_file: use_build_context_synchronously
import 'package:auto_route/auto_route.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/application/language/language_provider.dart';
import 'package:foodyman/application/main/main_provider.dart';
import '../../../../app_constants.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/local_storage.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:foodyman/presentation/components/buttons/custom_button.dart';
import 'package:foodyman/presentation/pages/auth/register/register_page.dart';
import 'package:foodyman/presentation/routes/app_router.dart';
import '../../../../application/auth/login/login_provider.dart';
import '../../profile/language_page.dart';
import 'login_screen.dart';

import 'package:foodyman/presentation/theme/theme.dart';
import 'package:foodyman/presentation/components/buttons/second_button.dart';
import 'package:foodyman/infrastructure/services/app_assets.dart';
import 'package:foodyman/presentation/pages/intro/intro_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodyman/presentation/pages/policy_term/policy_page.dart';
import 'package:foodyman/presentation/pages/policy_term/term_page.dart';

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
  late String splashImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(loginProvider.notifier).checkLanguage(context);
    });
    initDynamicLinks();
    // Initialize IntroPage
    _introPage = const IntroPage();

    // Determine which splash image to use based on the current date
    DateTime now = DateTime.now();
    DateTime startDate = DateTime(2024, 9, 1);
    DateTime endDate = DateTime(2024, 9, 10, 23, 59);

    if (now.isBefore(startDate)) {
      splashImage = "assets/images/splash1.png";
    } else if (now.isBefore(endDate)) {
      splashImage = "assets/images/splash2.png";
    } else {
      splashImage = "assets/images/splash.png"; // Default image
    }
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
        // Only show language selection if we have more than one language
        final languageState = ref.read(languageProvider);
        if (languageState.list.length > 1) {
          selectLanguage();
        } else if (languageState.list.length == 1) {
          // If there's only one language, auto-select it
          ref.read(languageProvider.notifier).makeSelectedLang(context);
        }
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
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  splashImage,
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
                     /* Image.asset(
                        AppAssets.pngLogo,
                        width: 50.r,
                        height: 50.r,
                      ),*/
                      AppHelpers.getAppName() != null
                          ? RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: AppHelpers.getAppName(),
                              style: AppStyle.logoFontBoldItalic(color: AppStyle.white, size: 35.sp),
                            ),
                            WidgetSpan(
                              child: Transform.translate(
                                offset: Offset(0, -15), // Move up by 15 pixels, adjust as needed
                                child: Text(
                                  "®",
                                  style: AppStyle.logoFontBoldItalic(color: AppStyle.white, size: 12.sp),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                          : SizedBox.shrink(),
                      8.horizontalSpace,
                      const Spacer(),
                      const Spacer(),
                      SecondButton(
                        onTap: _showIntroPage, // Show IntroPage when Skip is tapped
                        title: AppHelpers.getTranslation(TrKeys.skip),
                        bgColor: AppStyle.primary,
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
                              paddingTop: MediaQuery.paddingOf(context).top);
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
                        padding: const EdgeInsets.all(16), // Adjust the padding as needed
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Text(
                              "By using ${AppHelpers.getAppName() ?? ""}'s services, you acknowledge that you have read and accepted the",
                              style: const TextStyle(color: AppStyle.black), // Make text color white for visibility
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
