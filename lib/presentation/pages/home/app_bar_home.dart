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
  late StreamController<bool> _toggleStreamController;
  late StreamController<bool> _alternateAppNameController;

  @override
  void initState() {
    super.initState();
    _toggleStreamController = StreamController<bool>();
    _alternateAppNameController = StreamController<bool>();
    _startAlternating();
    _alternateAppName();
  }

  @override
  void dispose() {
    _toggleStreamController.close();
    _alternateAppNameController.close();
    super.dispose();
  }

  void _startAlternating() async {
    while (true) {
      await Future.delayed(const Duration(seconds: 3)); // Delay for 3 seconds
      _toggleStreamController.add(true); // Emit true to show ETA
      await Future.delayed(const Duration(seconds: 3)); // Delay for another 3 seconds
      _toggleStreamController.add(false); // Emit false to show ETAtime
    }
  }

  void _alternateAppName() async {
    while (true) {
      await Future.delayed(const Duration(seconds: 10)); // Delay for 10 seconds
      _alternateAppNameController.add(true); // Emit true to show formattedMotto
      await Future.delayed(const Duration(seconds: 10)); // Delay for another 10 seconds
      _alternateAppNameController.add(false); // Emit false to show AppName
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = LocalStorage.getAppThemeMode();

    return Stack(
      children: [
        // Background color
        Positioned.fill(
          child: Container(
            color: AppStyle.brandGreen.withOpacity(0.28),
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
                        Container(
                          child: Row(
                            children: [
                              StreamBuilder<bool>(
                                stream: _alternateAppNameController.stream,
                                initialData: true, // Initially show formattedMotto
                                builder: (context, snapshot) {
                                  final isShowingFormattedMotto = snapshot.data ?? true;
                                  return Row(
                                    children: [
                                      Image.asset(
                                        isShowingFormattedMotto ? AppAssets.pngLogo : AppAssets.pngMotto,
                                        width: 50.r,
                                        height: 50.r,
                                      ),
                                      const SizedBox(width: 3), // Adding some space between the image and text
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 3), // Use SizedBox for spacing
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              AppHelpers.getTranslation(TrKeys.deliveryAddress),
                              style: AppStyle.interNormal(
                                size: 12,
                                color: AppStyle.textGrey,
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: isCartEmpty ? MediaQuery.of(context).size.width - 300.w : MediaQuery.of(context).size.width - 210.w,
                                  child: Text(
                                    (LocalStorage.getAddressSelected()?.title?.isEmpty ?? true)
                                        ? LocalStorage.getAddressSelected()?.address ?? ''
                                        : LocalStorage.getAddressSelected()?.title ?? "",
                                    style: AppStyle.interBold(
                                      size: 14,
                                      color: AppStyle.black,
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                                const Icon(Icons.keyboard_arrow_down_sharp),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(width: isCartEmpty ? 130.w : 0.w),
                        if(!isCartEmpty)
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
                                icon: const Icon(FlutterRemix.search_line, size: 26),
                              ),
                            ),
                          ),
                        SizedBox(width: 8.w), // Add space between search icon and ETA rectangle
                        if (!isCartEmpty)
                          StreamBuilder<bool>(
                            stream: _toggleStreamController.stream,
                            initialData: true, // Initially show ETA
                            builder: (context, snapshot) {
                              final isShowingETA = snapshot.data ?? true;
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
                                      color: isShowingETA ? AppStyle.brandGreen : AppStyle.transparent,
                                      width: 2.0,
                                    ),
                                    color: isShowingETA ? AppStyle.transparent : AppStyle.brandGreen,
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
            const WelcomeText(),
            8.verticalSpace,
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 16.h, // Adjust this height as needed
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
      greetingText = '${AppHelpers.getTranslation(TrKeys.hello)} \u{1F44B}\n$firstName'; //\n$lastName';
      signedText = AppHelpers.getTranslation(TrKeys.signedtext);
    } else {
      greetingText = '';
      signedText = '';
    }

    // Split the signedText into words
    List<String> words = signedText.split(' ');

    // Add line breaks after the fifth word
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
      return const SizedBox(); // or any other fallback widget or null if nothing should be rendered
    }
  }
}
