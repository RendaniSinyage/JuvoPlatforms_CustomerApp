// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:auto_route/auto_route.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/application/main/main_notifier.dart';
import 'package:foodyman/application/profile/profile_provider.dart';
import 'package:foodyman/application/shop_order/shop_order_provider.dart';
import 'package:foodyman/infrastructure/models/data/cart_data.dart';
import 'package:foodyman/infrastructure/models/data/profile_data.dart';
import 'package:foodyman/infrastructure/models/data/remote_message_data.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:foodyman/presentation/components/buttons/animation_button_effect.dart';
import 'package:foodyman/presentation/components/custom_network_image.dart';
import 'package:foodyman/presentation/components/keyboard_dismisser.dart';
import 'package:foodyman/presentation/pages/home/home_page.dart';
import '../../../app_constants.dart';
import 'package:foodyman/presentation/pages/like/like_page.dart';
import 'package:foodyman/presentation/pages/main/widgets/bottom_navigator_three.dart';
import 'package:foodyman/presentation/pages/profile/profile_page.dart';
import 'package:foodyman/presentation/pages/search/search_page.dart';
import 'package:foodyman/presentation/pages/service/service_page.dart';
import 'package:foodyman/presentation/routes/app_router.dart';
import 'package:foodyman/presentation/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../application/home/home_provider.dart';
import '../../../application/main/main_provider.dart';
import '../../../infrastructure/models/data/shop_data.dart';
import '../../../infrastructure/services/local_storage.dart';
import '../../../utils/app_usage_service.dart';
import '../../components/blur_wrap.dart';
import '../home/home_four/home_page_four.dart';
import '../home/home_one/home_one_page.dart';
import '../home/home_three/home_page_three.dart';
import '../home/home_two/home_two_page.dart';
import 'widgets/bottom_navigator_item.dart';
import 'package:proste_indexed_stack/proste_indexed_stack.dart';

import 'widgets/bottom_navigator_one.dart';
import 'widgets/bottom_navigator_two.dart';

import 'package:remixicon/remixicon.dart';
import 'package:foodyman/presentation/pages/parcel/parcel_page.dart';
import 'package:foodyman/presentation/pages/profile/wallet_history.dart';

@RoutePage()
class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  //static const Color _blackWithOpacity = Color.fromRGBO(0, 0, 0, 0.8);
  List listPages = [
    [
      IndexedStackChild(child: HomePage(), preload: true),
      (AppHelpers.getParcel())
          ? IndexedStackChild(
          child: ParcelPage(
            isBackButton: false,
          ),
          preload: true)
          : IndexedStackChild(
        child: SearchPage(
          isBackButton: false,
        ),
      ),
      LocalStorage.getToken().isNotEmpty
          ? IndexedStackChild(
        child: WalletHistoryPage(
          isBackButton: false,
        ),
      )
          : IndexedStackChild(
          child: LikePage(
            isBackButton: false,
          )),
      IndexedStackChild(
          child: ProfilePage(
            isBackButton: false,
          ),
          preload: true),
    ],
    [
      IndexedStackChild(child: HomeOnePage(), preload: true),
      IndexedStackChild(child: ServicePage()),
    ],
    [
      IndexedStackChild(child: HomeTwoPage(), preload: true),
      IndexedStackChild(child: ServicePage()),
    ],
    [
      IndexedStackChild(child: HomePageThree(), preload: true),
      IndexedStackChild(child: ServicePage()),
    ],
    [
      IndexedStackChild(child: HomePageFour(), preload: true),
      (AppHelpers.getParcel())
          ? IndexedStackChild(
          child: ParcelPage(
            isBackButton: false,
          ),
          preload: true)
          : IndexedStackChild(
        child: SearchPage(
          isBackButton: false,
        ),
      ),
      LocalStorage.getToken().isNotEmpty
          ? IndexedStackChild(
        child: WalletHistoryPage(
          isBackButton: false,
        ),
      )
          : IndexedStackChild(
          child: LikePage(
            isBackButton: false,
          )),
      IndexedStackChild(
          child: ProfilePage(
            isBackButton: false,
          ),
          preload: true),
    ]
  ];

  @override
  void initState() {
    initDynamicLinks();

    // Record app usage if user is logged in
    if (LocalStorage.getToken().isNotEmpty) {
      debugPrint('MainPage: Recording app usage for logged in user');
      AppUsageService.recordAppUsage();
    } else {
      debugPrint('MainPage: User not logged in, skipping app usage tracking');
    }

    FirebaseMessaging.instance.requestPermission(
      sound: true,
      alert: true,
      badge: false,
    );

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      RemoteMessageData data = RemoteMessageData.fromJson(message.data);
      if (data.type == "news_publish") {
        context.router.popUntilRoot();
        await launch(
          "${AppConstants.webUrl}/blog/${message.data["uuid"]}",
          forceSafariVC: true,
          forceWebView: true,
          enableJavaScript: true,
        );
      } else {
        context.router.popUntilRoot();
        context.pushRoute(
          OrderProgressRoute(orderId: data.id),
        );
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteMessageData data = RemoteMessageData.fromJson(message.data);
      if (data.type == "news_publish") {
        AppHelpers.showCheckTopSnackBarInfoCustom(
            context, "${message.notification?.body}", onTap: () async {
          context.router.popUntilRoot();
          await launch(
            "${AppConstants.webUrl}/blog/${message.data["uuid"]}",
            forceSafariVC: true,
            forceWebView: true,
            enableJavaScript: true,
          );
        });
      } else {
        AppHelpers.showCheckTopSnackBarInfo(context,
            "${AppHelpers.getTranslation(TrKeys.id)} #${message.notification?.title} ${message.notification?.body}",
            onTap: () async {
              context.router.popUntilRoot();
              context.pushRoute(
                OrderProgressRoute(
                  orderId: data.id,
                ),
              );
            });
      }
    });
    super.initState();
  }

  Future<void> initDynamicLinks() async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      Uri link = dynamicLinkData.link;
      if (link.queryParameters.keys.contains('group')) {
        context.router.popUntilRoot();
        context.pushRoute(
          ShopRoute(
            shopId: link.pathSegments.last,
            cartId: link.queryParameters['group'],
            ownerId: int.tryParse(link.queryParameters['owner_id'] ?? ''),
          ),
        );
      } else if (!link.queryParameters.keys.contains("product") &&
          (link.pathSegments.contains("shop") ||
              link.pathSegments.contains("restaurant"))) {
        context.router.popUntilRoot();
        context.pushRoute(
          ShopRoute(
            shopId: link.pathSegments.last,
          ),
        );
      } else if (link.pathSegments.contains("shop")) {
        context.router.popUntilRoot();
        context.pushRoute(ShopRoute(
          shopId: link.pathSegments.last,
          productId: link.queryParameters['product'],
        ));
      } else if (link.pathSegments.contains("restaurant")) {
        context.router.popUntilRoot();
        context.pushRoute(ShopRoute(
          shopId: link.pathSegments.last,
          productId: link.queryParameters['product'],
        ));
      }
    }).onError((error) {
      debugPrint(error.message);
    });

    final PendingDynamicLinkData? data =
    await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;
    if (deepLink?.queryParameters.keys.contains("group") ?? false) {
      context.router.popUntilRoot();
      context.pushRoute(
        ShopRoute(
          shopId: deepLink?.pathSegments.last ?? '',
          cartId: deepLink?.queryParameters['group'],
          ownerId: int.tryParse(deepLink?.queryParameters['owner_id'] ?? ""),
        ),
      );
    } else if (!(deepLink?.queryParameters.keys.contains("product") ?? false) &&
        (deepLink?.pathSegments.contains("shop") ?? false) ||
        (deepLink?.pathSegments.contains("restaurant") ?? false)) {
      context.pushRoute(
        ShopRoute(
          shopId: deepLink?.pathSegments.last ?? "",
        ),
      );
    } else if (deepLink?.pathSegments.contains("shop") ?? false) {
      context.pushRoute(
        ShopRoute(
            shopId: deepLink?.pathSegments.last ?? "",
            productId: deepLink?.queryParameters['product']),
      );
    } else if (deepLink?.pathSegments.contains("restaurant") ?? false) {
      context.pushRoute(
        ShopRoute(
          shopId: deepLink?.pathSegments.last ?? '',
          productId: deepLink?.queryParameters['product'],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          // extendBody: true,
          body: Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final index = ref.watch(mainProvider).selectIndex;
              // If fixed is true, manually create ProsteIndexedStack with isScrolling always false
              return ProsteIndexedStack(
                index: index,
                children: listPages[AppHelpers.getType()],
              );
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: AppHelpers.getType() == 0
              ? Consumer(builder: (context, ref, child) {
            final index = ref.watch(mainProvider).selectIndex;
            final user = ref.watch(profileProvider).userData;
            final orders = ref.watch(shopOrderProvider).cart;
            final event = ref.read(mainProvider.notifier);
            return _bottom(index, ref, event, context, user, orders);
          })
              : AppHelpers.getType() == 3
              ? Consumer(builder: (context, ref, child) {
            return BottomNavigatorThree(
              currentIndex: ref.watch(mainProvider).selectIndex,
              onTap: (int value) {
                if (value == 3) {
                  if (LocalStorage.getToken().isEmpty) {
                    context.pushRoute(LoginRoute());
                    return;
                  }
                  context.pushRoute(OrderRoute());
                  return;
                }
                if (value == 2) {
                  if (LocalStorage.getToken().isEmpty) {
                    context.pushRoute(LoginRoute());
                    return;
                  }
                  context.pushRoute(ParcelRoute());
                  return;
                }
                ref.read(mainProvider.notifier).selectIndex(value);
              },
            );
          })
              : AppHelpers.getType() == 4
              ? Consumer(builder: (context, ref, child) {
            final index = ref.watch(mainProvider).selectIndex;
            final user = ref.watch(profileProvider).userData;
            final orders = ref.watch(shopOrderProvider).cart;
            final event = ref.read(mainProvider.notifier);
            return _bottom(index, ref, event, context, user, orders);
          })
              : const SizedBox(),
          bottomNavigationBar: Consumer(
            builder: (context, ref, child) {
              final index = ref.watch(mainProvider).selectIndex;
              final event = ref.read(mainProvider.notifier);
              return AppHelpers.getType() == 1
                  ? BottomNavigatorOne(
                currentIndex: index,
                onTap: (int value) {
                  if (value == 3) {
                    if (LocalStorage.getToken().isEmpty) {
                      context.pushRoute(LoginRoute());
                      return;
                    }
                    context.pushRoute(OrderRoute());
                    return;
                  }
                  if (value == 2) {
                    if (LocalStorage.getToken().isEmpty) {
                      context.pushRoute(LoginRoute());
                      return;
                    }
                    context.pushRoute(ParcelRoute());
                    return;
                  }
                  event.selectIndex(value);
                },
              )
                  : AppHelpers.getType() == 2
                  ? BottomNavigatorTwo(
                currentIndex: index,
                onTap: (int value) {
                  if (value == 3) {
                    if (LocalStorage.getToken().isEmpty) {
                      context.pushRoute(LoginRoute());
                      return;
                    }
                    context.pushRoute(OrderRoute());
                    return;
                  }
                  if (value == 2) {
                    if (LocalStorage.getToken().isEmpty) {
                      context.pushRoute(LoginRoute());
                      return;
                    }
                    context.pushRoute(ParcelRoute());
                    return;
                  }
                  event.selectIndex(value);
                },
              )
                  : const SizedBox();
            },
          ),
        ));
  }

  Widget _bottom(int index, WidgetRef ref, MainNotifier event,
      BuildContext context, ProfileData? user, Cart? orders) {
    final orders = ref.watch(shopOrderProvider).cart;
    final bool isCartEmpty = orders == null ||
        (orders.userCarts?.isEmpty ?? true) ||
        ((orders.userCarts?.isEmpty ?? true)
            ? true
            : (orders.userCarts?.first.cartDetails?.isEmpty ?? true)) ||
        orders.ownerId != LocalStorage.getUser()?.id;

    // Check if fixed navigation is enabled
    final bool isFixed = AppConstants.fixed;

    // If fixed is true, always pass false for isScrolling
    final bool isScrollingValue =
    isFixed ? false : ref.watch(mainProvider).isScrolling;

    // Get shop name from the homeProvider state
    String? shopName;
    if (!isCartEmpty && isFixed && orders.shopId != null) {
      // Look for the shop in all the loaded shop lists from homeProvider
      final homeState = ref.read(homeProvider);
      final int shopId = orders.shopId!;

      // Try to find the shop in any of the loaded shop lists
      final shop = homeState.shops.firstWhere(
            (s) => s.id == shopId,
        orElse: () => homeState.restaurant.firstWhere(
              (s) => s.id == shopId,
          orElse: () => homeState.newRestaurant.firstWhere(
                (s) => s.id == shopId,
            orElse: () => homeState.shopsRecommend.firstWhere(
                  (s) => s.id == shopId,
              orElse: () => homeState.filterShops.firstWhere(
                    (s) => s.id == shopId,
                orElse: () => ShopData(), // Default empty shop data
              ),
            ),
          ),
        ),
      );

      // If we found the shop, get its name
      if (shop.id != null) {
        shopName = shop.translation?.title;
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Cart info bar - only show when fixed is true and cart has items
        if (isFixed && !isCartEmpty)
          GestureDetector(
            onTap: () {
              if (LocalStorage.getToken().isEmpty) {
                context.pushRoute(LoginRoute());
                return;
              }
              context.pushRoute(OrderRoute());
            },
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                // Main container
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  margin: EdgeInsets.only(
                      bottom: 16.h), // Extra margin for the tooltip pointer
                  padding:
                  EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: AppStyle.primary.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      // In the cart info bar
                      Expanded(
                        child: Text(
                          '${AppHelpers.getTranslation(TrKeys.shopping)} ${_getCartShopName(orders, ref)}',
                          style: AppStyle.interRegular(
                            size: 14,
                            color: AppStyle.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          // Check if currency is loaded
                          final isLoading =
                              ref.watch(shopOrderProvider).isLoading;
                          final totalPrice =
                              ref.watch(shopOrderProvider).cart?.totalPrice;
                          final currency = LocalStorage.getSelectedCurrency();

                          if (isLoading) {
                            return CupertinoActivityIndicator(
                              color: AppStyle.white,
                              radius: 10.r,
                            );
                          } else if (currency == null) {
                            // If currency is not loaded yet, show a placeholder
                            return Text(
                              AppHelpers.numberFormat(number: totalPrice),
                              style: AppStyle.interSemi(
                                size: 16,
                                color: AppStyle.white,
                              ),
                            );
                          } else {
                            // Currency is loaded, format properly
                            return Text(
                              AppHelpers.numberFormat(number: totalPrice),
                              style: AppStyle.interSemi(
                                size: 16,
                                color: AppStyle.white,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),

                // Tooltip pointer (triangle)
                Positioned(
                  bottom: 6.h,
                  right: 20.w, // Position near the cart icon
                  child: ClipPath(
                    clipper: TriangleClipper(),
                    child: Container(
                      width: 16.h,
                      height: 10.h,
                      color: AppStyle.primary.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Main bottom navigation row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlurWrap(
              radius: BorderRadius.circular(100.r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                decoration: BoxDecoration(
                    color: AppStyle.bottomNavigationBarColor.withOpacity(0.3),
                    borderRadius: BorderRadius.all(Radius.circular(100.r))),
                height: 60.r,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.r),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      BottomNavigatorItem(
                        isScrolling: index == 3 ? false : isScrollingValue,
                        selectItem: () {
                          event.changeScrolling(false);
                          event.selectIndex(0);
                        },
                        index: 0,
                        currentIndex: index,
                        selectIcon: FlutterRemix.store_fill,
                        unSelectIcon: FlutterRemix.store_line,
                        label: AppHelpers.getTranslation(TrKeys.stores),
                      ),
                      BottomNavigatorItem(
                        isScrolling: index == 3 ? false : isScrollingValue,
                        selectItem: () {
                          event.changeScrolling(false);
                          event.selectIndex(1);
                        },
                        currentIndex: index,
                        index: 1,
                        label: (AppHelpers.getParcel())
                            ? AppHelpers.getTranslation(TrKeys.send)
                            : AppHelpers.getTranslation(TrKeys.search),
                        selectIcon: (AppHelpers.getParcel())
                            ? Remix.instance_fill
                            : FlutterRemix.search_fill,
                        unSelectIcon: (AppHelpers.getParcel())
                            ? Remix.instance_line
                            : FlutterRemix.search_line,
                      ),
                      BottomNavigatorItem(
                        isScrolling: index == 3 ? false : isScrollingValue,
                        selectItem: () {
                          event.changeScrolling(false);
                          event.selectIndex(2);
                        },
                        currentIndex: index,
                        index: 2,
                        label: LocalStorage.getToken().isNotEmpty
                            ? AppHelpers.getTranslation(TrKeys.wallet)
                            : AppHelpers.getTranslation(TrKeys.liked),
                        selectIcon: LocalStorage.getToken().isNotEmpty
                            ? FlutterRemix.wallet_2_fill
                            : FlutterRemix.heart_fill,
                        unSelectIcon: LocalStorage.getToken().isNotEmpty
                            ? FlutterRemix.wallet_2_line
                            : FlutterRemix.heart_line,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (event.checkGuest()) {
                            event.selectIndex(0);
                            event.changeScrolling(false);
                            context.replaceRoute(LoginRoute());
                          } else {
                            event.changeScrolling(false);
                            event.selectIndex(3);
                          }
                        },
                        child: Container(
                          width: 40.r,
                          height: 40.r,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: index == 3
                                      ? AppStyle.primary
                                      : AppStyle.transparent,
                                  width: 2.w),
                              shape: BoxShape.circle),
                          child: CustomNetworkImage(
                            profile: true,
                            url: user?.img ?? LocalStorage.getUser()?.img,
                            height: 40.r,
                            width: 40.r,
                            radius: 20.r,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Cart button - keep the icon when fixed=false to maintain original behavior
            (AppConstants.fixed == false && isCartEmpty)
                ? const SizedBox.shrink()
                : AnimationButtonEffect(
              child: GestureDetector(
                onTap: () {
                  if (LocalStorage.getToken().isEmpty) {
                    context.pushRoute(LoginRoute());
                    return;
                  }
                  context.pushRoute(OrderRoute());
                },
                child: Container(
                  margin: EdgeInsets.only(left: 8.w),
                  width: 56.r,
                  height: 56.r,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(0, 0, 0, 0.8),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        FlutterRemix.shopping_basket_2_fill,
                        color: AppStyle.white,
                      ),
                      Positioned(
                        top: 9,
                        right: 8,
                        child: Badge(
                          label: Text(
                            isCartEmpty
                                ? "0"
                                : (ref
                                .watch(shopOrderProvider)
                                .cart
                                ?.userCarts
                                ?.first
                                .cartDetails
                                ?.length ??
                                0)
                                .toString(),
                            style: const TextStyle(color: AppStyle.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}

// Helper method to get shop name from cart
String _getCartShopName(Cart? cart, WidgetRef ref) {
  if (cart == null || cart.shopId == null) return "";

  // Use the shopId from the cart, not the current shop being viewed
  final shopId = cart.shopId;
  final homeState = ref.read(homeProvider);

  // Look for the shop in homeState
  final shop = homeState.shops.firstWhere(
        (s) => s.id == shopId,
    orElse: () => homeState.restaurant.firstWhere(
          (s) => s.id == shopId,
      orElse: () => homeState.newRestaurant.firstWhere(
            (s) => s.id == shopId,
        orElse: () => homeState.shopsRecommend.firstWhere(
              (s) => s.id == shopId,
          orElse: () => homeState.filterShops.firstWhere(
                (s) => s.id == shopId,
            orElse: () => ShopData(),
          ),
        ),
      ),
    ),
  );

  return shop.translation?.title ?? "";
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