// ignore_for_file: unused_result
//import 'dart:io';
import 'dart:async';

import 'package:auto_route/auto_route.dart';
//import 'package:flutter/foundation.dart'; // For Platform
import 'package:flutter/material.dart'; // For Icons
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:http/http.dart' as http;
import 'package:riverpodtemp/application/home/home_provider.dart';
import 'package:riverpodtemp/application/language/language_provider.dart';
import 'package:riverpodtemp/application/notification/notification_provider.dart';
import 'package:riverpodtemp/application/orders_list/orders_list_provider.dart';
import 'package:riverpodtemp/application/parcels_list/parcel_list_provider.dart';
import 'package:riverpodtemp/application/profile/profile_provider.dart';
import 'package:riverpodtemp/application/shop_order/shop_order_provider.dart';
import 'package:riverpodtemp/infrastructure/services/app_constants.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/local_storage.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/app_bars/common_app_bar.dart';
import 'package:riverpodtemp/presentation/components/badges.dart';
import 'package:riverpodtemp/presentation/components/buttons/pop_button.dart';
import 'package:riverpodtemp/presentation/components/custom_network_image.dart';
import 'package:riverpodtemp/presentation/components/loading.dart';
import 'package:riverpodtemp/application/like/like_provider.dart';
import 'package:riverpodtemp/presentation/pages/profile/delete_screen.dart';
import 'package:riverpodtemp/presentation/routes/app_router.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';
//import 'package:url_launcher/url_launcher.dart';
//import 'package:riverpodtemp/presentation/components/web_view.dart'; //added
import 'package:riverpodtemp/presentation/components/buttons/button_item.dart';
import 'package:riverpodtemp/presentation/pages/policy_term/policy_page.dart';
import 'package:riverpodtemp/presentation/pages/policy_term/term_page.dart';
import 'widgets/about_page.dart';
import 'widgets/delivery_page.dart';
//import 'edit_profile_page.dart';
//import '../../../../application/edit_profile/edit_profile_provider.dart';
//import 'language_page.dart';
//import 'widgets/profile_item.dart';
//import 'package:device_info_plus/device_info_plus.dart'; // Import device_info_plus
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpodtemp/presentation/pages/profile/widgets/my_account.dart';
import 'reservation_shops.dart';



@RoutePage()
class ProfilePage extends ConsumerStatefulWidget {
  final bool isBackButton;


  const ProfilePage({
    super.key,
    this.isBackButton = true,
  });

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage>
    with SingleTickerProviderStateMixin {
  late RefreshController refreshController;
  late Timer time;

  Future<bool> checkApiStatus() async {
    final response = await http.get(Uri.parse('${AppConstants.baseUrl}/api/v1/rest/status'));
    return response.statusCode == 200;
  }

  @override
  void initState() {
    refreshController = RefreshController();
    if (LocalStorage.getToken().isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(profileProvider.notifier).fetchUser(context);
        ref.read(ordersListProvider.notifier).fetchActiveOrders(context);
        ref.read(parcelListProvider.notifier).fetchActiveOrders(context);
      });
      time = Timer.periodic(AppConstants.timeRefresh, (timer) {
        ref.read(notificationProvider.notifier).fetchCount(context);
      });
    }

    super.initState();
  }

  getAllInformation() {
    ref.read(homeProvider.notifier)
      ..setAddress()
      ..fetchBanner(context)
      ..fetchRestaurant(context)
      ..fetchShopRecommend(context)
      ..fetchShop(context)
      ..fetchStore(context)
      ..fetchRestaurantNew(context)
      ..fetchRestaurant(context)
      ..fetchCategories(context);
    ref.read(shopOrderProvider.notifier).getCart(context, () {});

    ref.read(likeProvider.notifier).fetchLikeShop(context);

    ref.read(profileProvider.notifier).fetchUser(context);
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = LocalStorage.getAppThemeMode();
    final bool isLtr = LocalStorage.getLangLtr();
    final state = ref.watch(profileProvider);
    // final stateNotification = ref.watch(notificationProvider);
    ref.listen(languageProvider, (previous, next) {
      if (next.isSuccess && next.isSuccess != previous!.isSuccess) {
        getAllInformation();
      }
    });

    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: isDarkMode ? AppStyle.mainBackDark : AppStyle.bgGrey,
        body: state.isLoading
            ? const Loading()
            : Column(
          children: [
            CommonAppBar(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 40.r,
                          width: 40.r,
                          child: CustomNetworkImage(
                            profile: true,
                            url: state.userData?.img ?? "",
                            height: 40.r,
                            width: 40.r,
                            radius: 30.r,
                          ),
                        ),
                        12.horizontalSpace,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width:
                              MediaQuery.of(context).size.width - 280.w,
                              child: Text(
                                state.userData?.firstname != null &&
                                    state.userData!.firstname!.length > 10
                                    ? "${state.userData!.firstname![0]}."
                                    : state.userData?.firstname ?? "",
                                style: AppStyle.interBold(
                                  size: 16.sp,
                                  color: AppStyle.black,
                                ),
                                maxLines: 1,
                              ),
                            ),
                            //  20.verticalSpace,
                            SizedBox(
                              width:
                              MediaQuery.of(context).size.width - 280.w,
                              child: Text(
                                state.userData?.lastname ?? "",   // ${state.userData?.lastname ?? ""}",
                                style: AppStyle.interBold(
                                  size: 16.sp,
                                  color: AppStyle.black,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        context.pushRoute(LikeRoute());
                      },
                      icon: Badge(
                        label: Text(
                          (ref.watch(likeProvider).likedShopsCount)
                              .toString(),
                        ),
                        child: const Icon(
                          FlutterRemix.heart_3_line,
                          color: AppStyle.black,
                          size: 20,
                        ),
                      ),),
                    IconButton(
                      onPressed: () {
                        context.pushRoute(const NotificationListRoute());
                      },
                      icon: Badge(
                        label: Text(
                          (ref.watch(notificationProvider).countOfNotifications?.notification ?? 0)
                              .toString(),
                        ),
                        child: const Icon(
                          FlutterRemix.notification_line,
                          color: AppStyle.black,
                          size: 20,
                        ),
                      ),),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MyAccount(
                              isBackButton: false,
                            )),

                          );
                        },
                        icon: const Icon(FlutterRemix.settings_3_line,
                          color: AppStyle.black,
                          // size: 22
                        )
                    ),
                    IconButton(
                        onPressed: () {
                          AppHelpers.showAlertDialog(
                              context: context,
                              child: DeleteScreen(
                                onDelete: () => time.cancel(),
                              ));
                        },
                        icon: const Icon(FlutterRemix.logout_circle_r_line,
                          color: AppStyle.black,
                          //size: 22
                        ))

                  ],
                )),
            Expanded(
              child: SmartRefresher(
                onRefresh: () {
                  ref.read(profileProvider.notifier).fetchUser(context,
                      refreshController: refreshController);
                  ref
                      .read(ordersListProvider.notifier)
                      .fetchActiveOrders(context);
                },
                controller: refreshController,
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                      top: 24.h, right: 16.w, left: 16.w, bottom: 120.h),
                  child: Column(
                    children: [

                      Container(
                        width: MediaQuery.of(context).size.width - 40.w,
                        height: MediaQuery.of(context).size.width - 200.h,
                        decoration: BoxDecoration(
                          color: AppStyle.blue.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppHelpers.getTranslation(TrKeys.plan),
                                style: AppStyle.interBold(
                                  size: 24,
                                  color: AppStyle.black,
                                ),
                              ),
                              5.verticalSpace,
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const ComingSoonDialog();
                                    },
                                  );
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      AppHelpers.getTranslation(TrKeys.benefits),
                                      style: AppStyle.interNormal(
                                        size: 16,
                                        color: AppStyle.black,
                                      ),
                                    ),
                                    const Icon(Icons.keyboard_arrow_right_sharp),
                                  ],
                                ),
                              ),
                              //   1.verticalSpace,
                              Row(
                                  children: [Text(
                                    AppHelpers.getTranslation(TrKeys.expire),
                                    style: AppStyle.interNormal(
                                      size: 12,
                                      color: AppStyle.textGrey,
                                    ),
                                  ),
                                    Text(" 20.12.2026",
                                      style: AppStyle.interNormal(
                                        size: 12,
                                        color: AppStyle.textGrey,
                                      ),
                                    ),]),
                              10.verticalSpace,
                              Row(
                                children: [
                                  const Icon(FlutterRemix.wallet_3_line),
                                  TextButton(
                                    onPressed: () {
                                      context.pushRoute(const WalletHistoryRoute());
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppStyle.black, // Set the color of the text
                                      textStyle: AppStyle.interNoSemi(size: 16),


                                    ),
                                    child: Text(
                                      "${AppHelpers.getTranslation(TrKeys.wallet)}: ${AppHelpers.numberFormat(number: state.userData?.wallet?.price)}",
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),10.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.pushRoute(const ShareReferralRoute());
                            },
                            child: Row(
                              children: [
                                // Uncomment if needed
                                // const Icon(Icons.FlutterRemix.money_dollar_circle_line),

                                Text(
                                  AppHelpers.getTranslation(TrKeys.inviteFriend),
                                  style: AppStyle.interNormal(
                                    size: 16,
                                    color: AppStyle.black,
                                  ),
                                ),   20.verticalSpace,
                                const Icon(Icons.keyboard_arrow_right_sharp),



                              ],
                            ),
                          ),10.horizontalSpace,

                        ],
                      ),
                      10.verticalSpace,
                      //account

                      /*   ButtonItem(
                              isLtr: isLtr,
                              title: AppHelpers.getTranslation(
                                  TrKeys.profileSettings),
                              icon: FlutterRemix.user_settings_line,
                              onTap: () {
                                ref.refresh(editProfileProvider);
                                AppHelpers.showCustomModalBottomDragSheet(
                                  context: context,
                                  modal: (c) => EditProfileScreen(
                                    controller: c,
                                  ),
                                  isDarkMode: isDarkMode,
                                );
                              },
                            ), */
                      //if (widget.isBackButton)

                      /*   ButtonItem(
                              isLtr: isLtr,
                              title: AppHelpers.getTranslation(
                                  TrKeys.deliveryTo),
                              icon: FlutterRemix.user_location_line,
                              onTap: () {
                                context.pushRoute(const AddressListRoute());
                              },
                            ), */
                      /*  AppHelpers.getReferralActive()
                                ? ButtonItem(
                              isLtr: isLtr,
                              title: AppHelpers.getTranslation(
                                  TrKeys.inviteFriend),
                              icon: FlutterRemix.money_dollar_circle_line,
                              onTap: () {
                                context.pushRoute(
                                    const ShareReferralRoute());
                              },
                            )
                                : const SizedBox.shrink(), */

                      //   12.verticalSpace,
                      //finance

                      /*     ButtonItem(
                              isLtr: isLtr,
                              title: AppHelpers.getTranslation(
                                  TrKeys.chatWithAdmin),
                              icon: FlutterRemix.chat_1_line,
                              onTap: () {
                                context.pushRoute(
                                    ChatRoute(roleId: "admin", name: "Admin"));
                              },
                            ), */

//other2
                      if (AppHelpers.getReservationEnable())
                        ButtonItem(
                          isLtr: isLtr,
                          title: AppHelpers.getTranslation(
                              TrKeys.reservation),
                          icon: FlutterRemix.reserved_line,
                          onTap: () async {
                            AppHelpers.showAlertDialog(
                              context: context,
                              child: const SizedBox(
                                  child: ReservationShops()),
                            );
                          },
                        ),

                      ButtonItem(
                        isLtr: isLtr,
                        title: AppHelpers.getTranslation(
                            TrKeys.becomeSeller),
                        icon: FlutterRemix.user_star_line,
                        onTap: () {
                          context.pushRoute(const CreateShopRoute());
                        },
                      ),
                      ButtonItem(
                        isLtr: isLtr,
                        title: AppHelpers.getTranslation(
                            TrKeys.signUpToDeliver),
                        icon: FlutterRemix.external_link_line,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                const DeliveryPage()),
                          );
                        },
                      ),
                      ButtonItem(
                        isLtr: isLtr,
                        title: AppHelpers.getTranslation(TrKeys.help),
                        icon: FlutterRemix.question_line,
                        onTap: () {
                          context.pushRoute(const HelpRoute());
                        },
                      ),
                      ButtonItem(
                        isLtr: isLtr,
                        title: AppHelpers.getTranslation(
                            TrKeys.deleteAccount),
                        icon: FlutterRemix.logout_box_r_line,
                        onTap: () {
                          AppHelpers.showAlertDialog(
                            context: context,
                            child: DeleteScreen(
                              isDeleteAccount: true,
                              onDelete: () {
                                time.cancel();
                              },
                            ),
                          );
                        },
                      ),

                      Container(
                        decoration: BoxDecoration(
                          color: AppStyle.transparent,
                          borderRadius: BorderRadius.circular(10.0), // Adjust the value as needed
                        ),
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [

                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const AboutPage()),
                                        );
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            AppHelpers.getTranslation(TrKeys.about),
                                            style: const TextStyle(color: AppStyle.black,
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          const Icon(Icons.circle_rounded,
                                              color: AppStyle.black,
                                              size: 7),
                                        ],
                                      ),
                                    ),

                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const TermPage()),
                                        );
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            AppHelpers.getTranslation(TrKeys.terms),
                                            style: const TextStyle(color: AppStyle.black,
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          const Icon(Icons.circle_rounded,
                                              color: AppStyle.black,
                                              size: 7),
                                        ],
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const PolicyPage()),
                                        );
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            AppHelpers.getTranslation(TrKeys.privacyPolicy),
                                            style: const TextStyle(color: AppStyle.black,
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                          //  const SizedBox(width: 2),
                                          //   const Icon(Icons.circle_rounded, size: 7),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppHelpers.getAppName() ?? "",
                                      style: AppStyle.interBold(color: AppStyle.brandGreen),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      FlutterRemix.checkbox_blank_circle_fill,
                                      size: 8,
                                      color: AppStyle.black,
                                    ),
                                    FutureBuilder<bool>(
                                      future: checkApiStatus(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          bool isOnline = snapshot.data!;
                                          return Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              FutureBuilder<PackageInfo>(
                                                future: PackageInfo.fromPlatform(),
                                                builder: (context, packageSnapshot) {
                                                  if (packageSnapshot.hasData) {
                                                    return Text(
                                                      " App Version ${packageSnapshot.data!.version}",
                                                      style: AppStyle.interNormal(color: AppStyle.black),
                                                    );
                                                  } else {
                                                    return const SizedBox.shrink();
                                                  }
                                                },
                                              ),
                                              const SizedBox(width: 8),
                                              Icon(
                                                FlutterRemix.checkbox_blank_circle_fill,
                                                size: 20,
                                                color: isOnline ? Colors.green : Colors.red,
                                              ),
                                              Text(
                                                isOnline ? 'Online' : 'Offline',
                                                style: TextStyle(color: isOnline ? Colors.green : Colors.red),
                                              ),
                                            ],
                                          );
                                        } else {
                                          return const SizedBox.shrink();
                                        }
                                      },
                                    ),

                                  ],
                                ),
                              ],
                            ),

                            /*       FutureBuilder<AndroidDeviceInfo>(
                              future: DeviceInfoPlugin().androidInfo,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,  // Center horizontally
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.center,  // Center vertically
                                          children: [
                                           Icon(Platform.isAndroid ? Icons.android : FlutterRemix.apple_fill,
                                             size: 30.0,color: AppStyle.brandGreen,),
                                            Text(Platform.isAndroid ?
								"Android ${snapshot.data!.version.release}" : "Apple iOS ${snapshot.data!.version.release}",
                                              style: AppStyle.interNormal(color: AppStyle.brandGreen),),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                            ), */
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: widget.isBackButton
            ? Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: const PopButton(),
        )
            : const SizedBox.shrink(),
      ),
    );
  }
}
