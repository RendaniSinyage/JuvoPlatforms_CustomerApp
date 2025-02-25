import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodyman/application/home/home_notifier.dart';
import 'package:foodyman/application/home/home_state.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/local_storage.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:foodyman/infrastructure/services/app_assets.dart';
import 'package:foodyman/presentation/components/app_bars/common_app_bar2.dart';
import 'package:foodyman/presentation/components/sellect_address_screen.dart';
import 'package:foodyman/presentation/routes/app_router.dart';
import 'package:foodyman/presentation/theme/app_style.dart';
import 'package:foodyman/application/shop_order/shop_order_provider.dart';
import 'package:flutter/gestures.dart';
import '../../../../app_constants.dart';
import '../../../../application/orders_list/orders_list_provider.dart';

class AppBarHome extends ConsumerStatefulWidget {
  final HomeState state;
  final HomeNotifier event;

  const AppBarHome({super.key, required this.state, required this.event});

  @override
  ConsumerState<AppBarHome> createState() => _AppBarHomeState();
}

class _AppBarHomeState extends ConsumerState<AppBarHome> with SingleTickerProviderStateMixin {
  late StreamController<bool> _toggleStreamController;
  late StreamController<bool> _alternateAppNameController;
  late UniqueKey _welcomeTextKey;
  late AnimationController _tooltipAnimationController;
  late Animation<double> _tooltipAnimation;
  Timer? _tooltipTimer;

  @override
  void initState() {
    super.initState();
    _toggleStreamController = StreamController<bool>.broadcast();
    _alternateAppNameController = StreamController<bool>.broadcast();
    _welcomeTextKey = UniqueKey();

    // Animation controller for tooltip
    _tooltipAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _tooltipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _tooltipAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _startAlternating();
    _alternateAppName();

    // Show tooltip briefly when using default coordinates after 5 seconds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(const Duration(seconds: 5), () {
        _showTemporaryTooltip();
      });
    });
  }

  void _showTemporaryTooltip() {
    // Only show if using default coordinates
    if (AppHelpers.isUsingDefaultCoordinates()) {
      _tooltipAnimationController.forward();

      // Cancel any existing timer
      _tooltipTimer?.cancel();

      // Hide tooltip after 5 seconds
      _tooltipTimer = Timer(const Duration(seconds: 15), () {
        _tooltipAnimationController.reverse();
      });
    }
  }

  @override
  void dispose() {
    _toggleStreamController.close();
    _alternateAppNameController.close();
    _tooltipAnimationController.dispose();
    _tooltipTimer?.cancel();
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

    final addressData = LocalStorage.getAddressSelected();
    final currentLat = addressData?.location?.latitude;
    final currentLng = addressData?.location?.longitude;
    final defaultLat = AppConstants.demoLatitude;
    final defaultLng = AppConstants.demoLongitude;

    debugPrint("Current coordinates: $currentLat, $currentLng");
    debugPrint("Default coordinates: $defaultLat, $defaultLng");
    debugPrint("Difference lat: ${(currentLat ?? 0) - defaultLat}, lng: ${(currentLng ?? 0) - defaultLng}");
    debugPrint("Address title: ${addressData?.title}");
    debugPrint("Address text: ${addressData?.address}");

    // Check if using default coordinates
    final bool isUsingDefaultCoordinates = AppHelpers.isUsingDefaultCoordinates();
    debugPrint("Using default coordinates: $isUsingDefaultCoordinates");

    return Stack(
      children: [
        // Background
        Positioned.fill(
          child: Container(
            color: AppStyle.primary.withOpacity(0.28),
          ),
        ),

        // Main content
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
                        orders.ownerId != LocalStorage.getUser()?.id;

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

            Stack(
              children: [
                // Welcome text and other content
                Column(
                  children: [
                    WelcomeText(key: _welcomeTextKey),
                    8.verticalSpace,
                  ],
                ),

                // Positioned tooltip that you can easily adjust
                if (isUsingDefaultCoordinates)
                  Positioned(
                    top: 0, // Adjust this value to move up/down
                    left: 16.w, // Adjust this value to move left/right
                    right: 16.w,
                    child: AnimatedBuilder(
                      animation: _tooltipAnimation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _tooltipAnimation.value,
                          child: Transform.translate(
                            offset: Offset(0, 10 * (1 - _tooltipAnimation.value)),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                // Main container
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                                  decoration: BoxDecoration(
                                    color: AppStyle.primary,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Text(
                                    AppHelpers.getTranslation(TrKeys.usingDefaultLocation),
                                    style: AppStyle.interRegular(
                                      size: 14,
                                      color: AppStyle.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                                // Triangle pointer
                                Positioned(
                                  top: -5.h,
                                  left: 70.w, // Position under the address text
                                  child: Transform.rotate(
                                    angle: 3.14159,
                                    child: ClipPath(
                                      clipper: TriangleClipper(),
                                      child: Container(
                                        width: 10.h,
                                        height: 6.h,
                                        color: AppStyle.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ],
        ),

        // Bottom part
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
            AppHelpers.getTranslation(TrKeys.titleETA),
            style: AppStyle.interBold(
              size: 14,
              color: AppStyle.black,
            ),
          ),
          Text(
            AppHelpers.getTranslation(TrKeys.etaTimeDialog),
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
    final firstName = LocalStorage.getUser()?.firstname ?? "";
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
                          color: AppStyle.primary,
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
                          color: AppStyle.primary,
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
// Custom clipper for creating the triangle pointer
class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, size.height);
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}