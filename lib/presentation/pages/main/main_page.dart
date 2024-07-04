// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:auto_route/auto_route.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpodtemp/application/main/main_notifier.dart';
import 'package:riverpodtemp/application/profile/profile_provider.dart';
import 'package:riverpodtemp/application/shop_order/shop_order_provider.dart';
import 'package:riverpodtemp/infrastructure/models/data/cart_data.dart';
import 'package:riverpodtemp/infrastructure/models/data/profile_data.dart';
import 'package:riverpodtemp/infrastructure/models/data/remote_message_data.dart';
import 'package:riverpodtemp/infrastructure/services/app_constants.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/buttons/animation_button_effect.dart';
import 'package:riverpodtemp/presentation/components/custom_network_image.dart';
import 'package:riverpodtemp/presentation/components/keyboard_dismisser.dart';
import 'package:riverpodtemp/presentation/pages/home/home_page.dart';
import 'package:riverpodtemp/presentation/pages/home_one/home_one_page.dart';
import 'package:riverpodtemp/presentation/pages/home_three/home_page_three.dart';
import 'package:riverpodtemp/presentation/pages/home_two/home_two_page.dart';
import 'package:riverpodtemp/presentation/pages/like/like_page.dart';
import 'package:riverpodtemp/presentation/pages/main/widgets/bottom_navigator_three.dart';
import 'package:riverpodtemp/presentation/pages/profile/profile_page.dart';
import 'package:riverpodtemp/presentation/pages/search/search_page.dart';
import 'package:riverpodtemp/presentation/pages/service/service_page.dart';
import 'package:riverpodtemp/presentation/routes/app_router.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../application/main/main_provider.dart';
import '../../../infrastructure/services/local_storage.dart';
import '../../components/blur_wrap.dart';
import 'widgets/bottom_navigator_item.dart';
import 'package:proste_indexed_stack/proste_indexed_stack.dart';

import 'widgets/bottom_navigator_one.dart';
import 'widgets/bottom_navigator_two.dart';

import 'package:remixicon/remixicon.dart';
import 'package:riverpodtemp/presentation/pages/parcel/parcel_page.dart';
import 'package:riverpodtemp/presentation/pages/order/orders_main.dart';
import 'package:riverpodtemp/application/orders_list/orders_list_provider.dart';
import 'package:riverpodtemp/presentation/pages/shop/shop_page.dart';
import 'package:riverpodtemp/presentation/pages/profile/wallet_history.dart';

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
  static const Color _blackWithOpacity = Color.fromRGBO(0, 0, 0, 0.8);
  List listPages = [
    [
      IndexedStackChild(child:   HomePage(), preload: true),

        (AppHelpers.getParcel()) ?
      IndexedStackChild(
          child:  ParcelPage(

            isBackButton: false,
          ),
          preload: true
      ) :
  IndexedStackChild(
  child:   SearchPage(
  isBackButton: false,
  ),
  ),

      LocalStorage.getToken().isNotEmpty ?
      IndexedStackChild(
          child:  WalletHistoryPage(
            isBackButton: false,
          ),
      ) :
      IndexedStackChild(
          child:    LikePage(
            isBackButton: false,
          )
      ),



      IndexedStackChild(
          child:   ProfilePage(
            isBackButton: false,
          ),
          preload: true),
    ],
    [
      IndexedStackChild(child:   HomeOnePage(), preload: true),
      IndexedStackChild(child:   ServicePage()),
    ],
    [
      IndexedStackChild(child:   HomeTwoPage(), preload: true),
      IndexedStackChild(child:   ServicePage()),
    ],
    [
      IndexedStackChild(child:   HomePageThree(), preload: true),
      IndexedStackChild(child:   ServicePage()),
    ]
  ];

  @override
  void initState() {
    initDynamicLinks();
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
      if (link.queryParameters.keys.contains('g')) {
        context.router.popUntilRoot();
        context.pushRoute(
          ShopRoute(
            shopId: link.pathSegments.last,
            cartId: link.queryParameters['g'],
            ownerId: int.tryParse(link.queryParameters['o'] ?? ''),
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
    if (deepLink?.queryParameters.keys.contains("g") ?? false) {
      context.router.popUntilRoot();
      context.pushRoute(
        ShopRoute(
          shopId: deepLink?.pathSegments.last ?? '',
          cartId: deepLink?.queryParameters['g'],
          ownerId: int.tryParse(deepLink?.queryParameters['o'] ?? ""),
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
                    context.pushRoute(  LoginRoute());
                    return;
                  }
                  context.pushRoute(  OrderRoute());
                  return;
                }
                if (value == 2) {
                  if (LocalStorage.getToken().isEmpty) {
                    context.pushRoute(  LoginRoute());
                    return;
                  }
                  context.pushRoute(  ParcelRoute());
                  return;
                }
                ref.read(mainProvider.notifier).selectIndex(value);
              },
            );
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
                      context.pushRoute(  LoginRoute());
                      return;
                    }
                    context.pushRoute(  OrderRoute());
                    return;
                  }
                  if (value == 2) {
                    if (LocalStorage.getToken().isEmpty) {
                      context.pushRoute(  LoginRoute());
                      return;
                    }
                    context.pushRoute(  ParcelRoute());
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
                      context.pushRoute(  LoginRoute());
                      return;
                    }
                    context.pushRoute(  OrderRoute());
                    return;
                  }
                  if (value == 2) {
                    if (LocalStorage.getToken().isEmpty) {
                      context.pushRoute(  LoginRoute());
                      return;
                    }
                    context.pushRoute(  ParcelRoute());
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
        orders.ownerId != LocalStorage.getUserId();

    return Row(
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
                    isScrolling: index == 3
                        ? false
                        : ref.watch(mainProvider).isScrolling,
                    selectItem: () {
                      event.changeScrolling(false);
                      event.selectIndex(0);
                    },
                    index: 0,
                    currentIndex: index,
                    //  selectIcon: FlutterRemix.restaurant_fill,
                    // unSelectIcon: FlutterRemix.restaurant_line,
                    selectIcon: FlutterRemix.store_fill, //changed
                    unSelectIcon: FlutterRemix.store_line, //changed
                    label: AppHelpers.getTranslation(TrKeys.stores),
                    //label: 'Home',
                  ),


                  BottomNavigatorItem(
                    isScrolling: index == 3
                        ? false
                        : ref.watch(mainProvider).isScrolling,
                    selectItem: () {
                      event.changeScrolling(false);
                      event.selectIndex(1);
                    },
                    currentIndex: index,
                    index: 1,
                    label:  (AppHelpers.getParcel()) ? AppHelpers.getTranslation(TrKeys.send) : AppHelpers.getTranslation(TrKeys.search),
                    selectIcon:  (AppHelpers.getParcel()) ? Remix.instance_fill : FlutterRemix.search_fill,
                    unSelectIcon:  (AppHelpers.getParcel()) ? Remix.instance_line : FlutterRemix.search_line,

                  ),
                  // if(AppHelpers.getParcel())

                        BottomNavigatorItem(
                          isScrolling: index == 3
                              ? false
                              : ref.watch(mainProvider).isScrolling,
                          selectItem: () {
                            event.changeScrolling(false);
                            event.selectIndex(2);
                          },
                          currentIndex: index,
                          index: 2,
                          label:  LocalStorage.getToken().isNotEmpty ? AppHelpers.getTranslation(TrKeys.wallet) : AppHelpers.getTranslation(TrKeys.liked),
                          selectIcon:  LocalStorage.getToken().isNotEmpty ? FlutterRemix.wallet_2_fill : FlutterRemix.heart_fill,
                          unSelectIcon: LocalStorage.getToken().isNotEmpty ? FlutterRemix.wallet_2_line : FlutterRemix.heart_line,

                        ),




                  GestureDetector(
                    onTap: () {
                      if (event.checkGuest()) {
                        event.selectIndex(0);
                        event.changeScrolling(false);
                        context.replaceRoute(  LoginRoute());
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
                                  ? AppStyle.brandGreen
                                  : AppStyle.transparent,
                              width: 2.w),
                          shape: BoxShape.circle),
                      child: CustomNetworkImage(
                        profile: true,
                        url: user?.img ?? LocalStorage.getProfileImage(),
                        height: 40.r,
                        width: 40..r,
                        radius: 20.r,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        orders == null ||
            (orders.userCarts?.isEmpty ?? true) ||
            ((orders.userCarts?.isEmpty ?? true)
                ? true
                : (orders.userCarts?.first.cartDetails?.isEmpty ?? true)) ||
            orders.ownerId != LocalStorage.getUserId()
            ? const SizedBox.shrink()
            : AnimationButtonEffect(
          child: GestureDetector(
            onTap: () {
              context.pushRoute(  OrderRoute());
            },
            child: Container(
                margin: EdgeInsets.only(left: 8.w),
                width: 56.r,
                height: 56.r,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: _blackWithOpacity),
                //  child: const Icon(FlutterRemix.shopping_bag_3_line),

                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(FlutterRemix.shopping_basket_2_fill, color: AppStyle.white),
                    Positioned(
                      top: 9,
                      right: 8,
                      child: Badge(
                        label: Text(
                          //(ref.watch(shopOrderProvider).cart?.toString() ?? 0)
                          (ref.watch(shopOrderProvider).cart?.userCarts?.first.cartDetails?.length ?? 0)
                          // (ref.watch(shopOrderProvider).cart?.userCarts?.first.cartDetails?[index].quantity ?? 0)
                              .toString(),
                          style: const TextStyle(color: AppStyle.white),
                        ),
                      ),
                    ),
                  ],
                )
              //const Icon(FlutterRemix.shopping_basket_2_fill, color: AppStyle.white,), //changed
            ),
          ),
        )
      ],
    );
  }
}
