import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpodtemp/application/home/home_notifier.dart';
import 'package:riverpodtemp/application/home/home_state.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/local_storage.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/infrastructure/services/app_assets.dart';
import 'package:riverpodtemp/presentation/components/app_bars/common_app_bar2.dart';
import 'package:riverpodtemp/presentation/components/sellect_address_screen.dart';
import 'package:riverpodtemp/presentation/routes/app_router.dart';
import 'package:riverpodtemp/presentation/theme/app_style.dart';
import 'package:riverpodtemp/application/shop_order/shop_order_provider.dart';

class AppBarHome extends StatefulWidget {
  final HomeState state;
  final HomeNotifier event;

  const AppBarHome({super.key, required this.state, required this.event});

  @override
  _AppBarHomeState createState() => _AppBarHomeState();
}

class _AppBarHomeState extends State<AppBarHome> {
  late ValueNotifier<bool> _toggleNotifier;
  late ValueNotifier<bool> _alternateAppNameNotifier;

  @override
  void initState() {
    super.initState();
    _toggleNotifier = ValueNotifier<bool>(true);
    _alternateAppNameNotifier = ValueNotifier<bool>(true);

    Timer.periodic(const Duration(seconds: 3), (_) {
      _toggleNotifier.value = !_toggleNotifier.value;
    });

    Timer.periodic(const Duration(seconds: 10), (_) {
      _alternateAppNameNotifier.value = !_alternateAppNameNotifier.value;
    });
  }

  @override
  void dispose() {
    _toggleNotifier.dispose();
    _alternateAppNameNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = LocalStorage.getAppThemeMode();

    return Stack(
      children: [
        // Background color
        Positioned.fill( // Covers the entire area
          child: Image.asset(
            'assets/images/water/header.jpg', // Path to your image
            fit: BoxFit.cover, // Adjust how the image fills the space (cover, contain, etc.)
          ),
        ),
        Positioned.fill(
          child: Container(
            color: AppStyle.blue.withOpacity(0.5),
          ),
        ),
        Column(
          children: [
            CommonAppBar2(
              child: InkWell(
                onTap: () {
                  if (!LocalStorage.getToken().isNotEmpty) {
                    context.pushRoute(ViewMapRoute());
                    return;
                  }
                  AppHelpers.showCustomModalBottomSheet(
                    context: context,
                    modal: SelectAddressScreen(
                      addAddress: () async {
                        await context.pushRoute(ViewMapRoute());
                      },
                    ),
                    isDarkMode: false,
                  );
                },
                child: Consumer(
                  builder: (context, ref, child) {
                    final orders = ref.watch(shopOrderProvider).cart;
                    final bool isCartEmpty = orders == null ||
                        (orders.userCarts?.isEmpty ?? true) ||
                        ((orders.userCarts?.isEmpty ?? true)
                            ? true
                            : (orders.userCarts?.first.cartDetails?.isEmpty ?? true)) ||
                        orders.ownerId != LocalStorage.getUserId();

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ValueListenableBuilder<bool>(
                              valueListenable: _alternateAppNameNotifier,
                              builder: (context, isShowingFormattedMotto, _) {
                                return Row(
                                  children: [
                                    Image.asset(
                                      AppAssets.pngLogo2,
                                      width: 50.r,
                                      height: 50.r,
                                    ),
                                    const SizedBox(width: 3),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(width: 3),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              AppHelpers.getTranslation(TrKeys.deliveryAddress),
                              style: AppStyle.interNormal(
                                size: 12,
                                color: AppStyle.white,
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                 // width:  MediaQuery.of(context).size.width - 170.w,
                                  width: isCartEmpty ? MediaQuery.of(context).size.width - 170.w : MediaQuery.of(context).size.width - 210.w,

                                  child: Text(
                                    (LocalStorage.getAddressSelected()?.title?.isEmpty ?? true)
                                        ? LocalStorage.getAddressSelected()?.address ?? ''
                                        : LocalStorage.getAddressSelected()?.title ?? "",
                                    style: AppStyle.interBold(
                                      size: 14,
                                      color: AppStyle.white,
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                                const Icon(Icons.keyboard_arrow_down_sharp,color: AppStyle.white),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(width: 0.w),
                        TooltipTheme(
                          data: const TooltipThemeData(
                            preferBelow: true,
                            waitDuration: Duration(milliseconds: 500),
                            showDuration: Duration(seconds: 2),
                          ),
                          child: Tooltip(
                            message: 'Search',
                            child: IconButton(
                              onPressed: () {
                                context.pushRoute(SearchRoute());
                              },
                              icon: const Icon(FlutterRemix.search_line, size: 26, color: AppStyle.white),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        if (!isCartEmpty)
                          ValueListenableBuilder<bool>(
                            valueListenable: _toggleNotifier,
                            builder: (context, isShowingETA, _) {
                              return GestureDetector(
                                onTap: () {
                                  _showInfoPopup(context);
                                },
                                child: Container(
                                  width: 40.r,
                                  height: 40.r,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: isShowingETA ? AppStyle.white : AppStyle.transparent,
                                      width: 2.0,
                                    ),
                                    color: isShowingETA ? AppStyle.white : AppStyle.brandGreen,
                                  ),
                                  child: Center(
                                    child: Text(
                                      isShowingETA
                                          ? AppHelpers.getTranslation(TrKeys.ETA)
                                          : AppHelpers.getTranslation(TrKeys.ETAtime),
                                      style: AppStyle.interBold(
                                        size: 16,
                                        color: isShowingETA ? AppStyle.brandGreen : AppStyle.white,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          //  const WelcomeText(),
            8.verticalSpace,
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 16.h,
            decoration: BoxDecoration(
              color: isDarkMode ? AppStyle.mainBackDark : AppStyle.bgGrey,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showInfoPopup(BuildContext context) {
    AppHelpers.showAlertDialog(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppHelpers.getTranslation(TrKeys.TitleETA),
            style: AppStyle.interBold(
              size: 14,
              color: AppStyle.black,
            ),
          ),
          Text(
            AppHelpers.getTranslation(TrKeys.ETAtimeDialog),
            style: AppStyle.interNormal(
              size: 12,
              color: AppStyle.textGrey,
            ),
          ),
        ],
      ),
    );
  }
}

class WelcomeText extends StatelessWidget {
  const WelcomeText({super.key});

  @override
  Widget build(BuildContext context) {
    final firstName = LocalStorage.getFirstName();
    final lastName = LocalStorage.getLastName();
    String greetingText = '';
    String signedText = '';

    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      greetingText = '${AppHelpers.getTranslation(TrKeys.hello)} \u{1F44B}\n$firstName';
      signedText = AppHelpers.getTranslation(TrKeys.signedtext);
    } else {
      greetingText = '';
      signedText = '';
    }

    List<String> words = signedText.split(' ');

    String formattedSignedText = '';
    for (int i = 0; i < words.length; i++) {
      formattedSignedText += words[i];
      if ((i + 1) % 4 == 0 && i != words.length - 1) {
        formattedSignedText += '\n';
      } else {
        formattedSignedText += ' ';
      }
    }

    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      return Container(
        color: AppStyle.transparent,
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              child: Image.asset(
                'assets/images/order.png',
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  greetingText,
                  style: AppStyle.interBold(
                    size: 32,
                    letterSpacing: -0.3,
                    color: AppStyle.black,
                  ),
                ),
                Text(
                  formattedSignedText,
                  style: AppStyle.interNormal(
                    size: 16,
                    letterSpacing: -0.3,
                    color: AppStyle.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}