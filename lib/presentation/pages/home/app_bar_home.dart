import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:flutter/gestures.dart';
import '../../../application/orders_list/orders_list_provider.dart';
import '../../components/badges.dart';

class AppBarHome extends ConsumerStatefulWidget {
  final HomeState state;
  final HomeNotifier event;

  const AppBarHome({super.key, required this.state, required this.event});

  @override
  ConsumerState<AppBarHome> createState() => _AppBarHomeState();
}

class _AppBarHomeState extends ConsumerState<AppBarHome> {
  late StreamController<bool> _toggleStreamController;
  late StreamController<bool> _alternateAppNameController;
  late UniqueKey _welcomeTextKey;

  @override
  void initState() {
    super.initState();
    _toggleStreamController = StreamController<bool>.broadcast();
    _alternateAppNameController = StreamController<bool>.broadcast();
    _welcomeTextKey = UniqueKey();
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
      await Future.delayed(const Duration(seconds: 3));
      if (!_toggleStreamController.isClosed) {
        _toggleStreamController.add(true);
      }
      await Future.delayed(const Duration(seconds: 3));
      if (!_toggleStreamController.isClosed) {
        _toggleStreamController.add(false);
      }
    }
  }

  void _alternateAppName() async {
    while (true) {
      await Future.delayed(const Duration(seconds: 10));
      if (!_alternateAppNameController.isClosed) {
        _alternateAppNameController.add(true);
      }
      await Future.delayed(const Duration(seconds: 10));
      if (!_alternateAppNameController.isClosed) {
        _alternateAppNameController.add(false);
      }
    }
  }

  void _refreshWelcomeText() {
    setState(() {
      _welcomeTextKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = LocalStorage.getAppThemeMode();
    final ordersState = ref.watch(ordersListProvider);
    final mostRecentOrder = ordersState.activeOrders.isNotEmpty ? ordersState.activeOrders.first : null;

    return Stack(
      children: [
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
                        Row(
                          children: [
                            StreamBuilder<bool>(
                              stream: _alternateAppNameController.stream,
                              initialData: true,
                              builder: (context, snapshot) {
                                final isShowingFormattedMotto = snapshot.data ?? true;
                                return Row(
                                  children: [
                                    Image.asset(
                                      isShowingFormattedMotto ? AppAssets.pngLogo : AppAssets.pngMotto,
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
                                color: AppStyle.textGrey,
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width - 120.w,
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
                      ],
                    );
                  },
                ),
              ),
            ),

            WelcomeText(key: _welcomeTextKey),
              const UpComingList(),

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
    final isLoggedIn = LocalStorage.getToken().isNotEmpty;
    final firstName = LocalStorage.getFirstName();
    String greetingText = '';
    String signedText = '';

    if (isLoggedIn && firstName.isNotEmpty) {
      greetingText = '${AppHelpers.getTranslation(TrKeys.hello)} \u{1F44B}\n$firstName';
      signedText = '${AppHelpers.getTranslation(TrKeys.signedtext)}\n';
    } else {
      greetingText = '${AppHelpers.getTranslation(TrKeys.hey)} \u{1F44B}\n${AppHelpers.getTranslation(TrKeys.there)}';
      signedText = 'login or signup ${AppHelpers.getTranslation(TrKeys.signtext)}';
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
              if (isLoggedIn)
                Text(
                  formattedSignedText,
                  style: AppStyle.interNormal(
                    size: 16,
                    letterSpacing: -0.3,
                    color: AppStyle.black,
                  ),
                )
              else
                RichText(
                  text: TextSpan(
                    style: AppStyle.interNormal(
                      size: 16,
                      letterSpacing: -0.3,
                      color: AppStyle.black,
                    ),
                    children: [
                      TextSpan(
                        text: 'login',
                        style: const TextStyle(
                          color: AppStyle.brandGreen,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.router.push(const LoginRoute());
                          },
                      ),
                      const TextSpan(text: ' or '),
                      TextSpan(
                        text: 'signup',
                        style: const TextStyle(
                          color: AppStyle.brandGreen,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.router.push(const LoginRoute());
                          },
                      ),
                      TextSpan(text: ' ${AppHelpers.getTranslation(TrKeys.signtext)}\n${AppHelpers.getTranslation(TrKeys.signtext2)}'),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}