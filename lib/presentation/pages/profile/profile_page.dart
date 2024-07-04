import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:http/http.dart' as http;
import 'package:remixicon/remixicon.dart';
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
import 'package:riverpodtemp/presentation/pages/profile/help_page.dart';
import 'package:riverpodtemp/presentation/routes/app_router.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';
import 'package:riverpodtemp/presentation/pages/policy_term/policy_page.dart';
import 'package:riverpodtemp/presentation/pages/policy_term/term_page.dart';
import '../../components/buttons/second_button.dart';
import 'widgets/about_page.dart';
import 'widgets/delivery_page.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpodtemp/presentation/pages/profile/widgets/my_account.dart';
import 'reservation_shops.dart';

const String userRole = "member";

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
    final response =
        await http.get(Uri.parse('${AppConstants.baseUrl}/api/v1/rest/status'));
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
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width - 280.w,
                                child: Text(
                                  state.userData?.lastname ?? "",
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
                            Remix.heart_3_line,
                            color: AppStyle.black,
                            size: 20,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          context.pushRoute(const NotificationListRoute());
                        },
                        icon: Badge(
                          label: Text(
                            (ref
                                        .watch(notificationProvider)
                                        .countOfNotifications
                                        ?.notification ??
                                    0)
                                .toString(),
                          ),
                          child: const Icon(
                            Remix.notification_line,
                            color: AppStyle.black,
                            size: 20,
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyAccount(
                                        isBackButton: false,
                                      )),
                            );
                          },
                          icon: const Icon(
                            Remix.settings_3_line,
                            color: AppStyle.black,
                          )),
                      IconButton(
                          onPressed: () {
                            AppHelpers.showAlertDialog(
                                context: context,
                                child: DeleteScreen(
                                  onDelete: () => time.cancel(),
                                ));
                          },
                          icon: const Icon(
                            Remix.logout_circle_r_line,
                            color: AppStyle.black,
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
                            if (state.userData?.role == userRole)
                              Column(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width -
                                        40.w,
                                    decoration: BoxDecoration(
                                      color:
                                          AppStyle.brandGreen.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppHelpers.getTranslation(
                                                TrKeys.plan),
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
                                                builder:
                                                    (BuildContext context) {
                                                  return const ComingSoonDialog();
                                                },
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  AppHelpers.getTranslation(
                                                      TrKeys.benefits),
                                                  style: AppStyle.interNormal(
                                                    size: 16,
                                                    color: AppStyle.black,
                                                  ),
                                                ),
                                                const Icon(Icons
                                                    .keyboard_arrow_right_sharp),
                                              ],
                                            ),
                                          ),
                                          Row(children: [
                                            Text(
                                              AppHelpers.getTranslation(
                                                  TrKeys.expire),
                                              style: AppStyle.interNormal(
                                                size: 12,
                                                color: AppStyle.textGrey,
                                              ),
                                            ),
                                            Text(
                                              " 20.12.2026",
                                              style: AppStyle.interNormal(
                                                size: 12,
                                                color: AppStyle.textGrey,
                                              ),
                                            ),
                                          ]),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          10.h), // Add this line for spacing
                                ],
                              ),
                            Container(
                              width: MediaQuery.of(context).size.width - 40.w,
                              decoration: BoxDecoration(
                                color: AppStyle.brandGreen.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Remix.wallet_3_line),
                                        TextButton(
                                          onPressed: () {
                                            context.pushRoute(
                                                WalletHistoryRoute());
                                          },
                                          style: TextButton.styleFrom(
                                            foregroundColor: AppStyle.black,
                                            textStyle:
                                                AppStyle.interNoSemi(size: 16),
                                          ),
                                          child: Text(
                                            "${AppHelpers.getTranslation(TrKeys.wallet)}: ${AppHelpers.numberFormat(number: state.userData?.wallet?.price)}",
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        SecondButton(
                                          title: AppHelpers.getTranslation(TrKeys.send),
                                          bgColor: AppStyle.brandGreen,
                                          titleColor: AppStyle.white,
                                          onTap: () {
                                            /*AppHelpers.showCustomModalBottomSheet(
                                              context: context,
                                              modal: ProviderScope(
                                                child: Consumer(
                                                  builder: (context, ref, _) => const SenPriceScreen(
                                                   // colors: AppStyle.brandGreen,
                                                  ),
                                                ),
                                              ),
                                              isDarkMode: false,
                                            );*/
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return const ComingSoonDialog();
                                              },
                                            );
                                          },
                                        ),
                                        const SizedBox(width: 8),
                                        SecondButton(
                                          title: AppHelpers.getTranslation(
                                              TrKeys.add),
                                          bgColor: AppStyle.brandGreen,
                                          titleColor: AppStyle.white,
                                          onTap: () {
                                            /*AppHelpers.showCustomModalBottomSheet(
                                              context: context,
                                              modal: ProviderScope(
                                                child: Consumer(
                                                  builder: (context, ref, _) => const FillWalletScreen(
                                                   // colors: AppStyle.brandGreen,
                                                  ),
                                                ),
                                              ),
                                              isDarkMode: false,
                                            );*/
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return const ComingSoonDialog();
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            15.verticalSpace,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildSquareButton(
                                  context,
                                  icon: Remix.instance_line,
                                  title:
                                      AppHelpers.getTranslation(TrKeys.parcels),
                                  onTap: () => context
                                      .pushRoute(const ParcelListRoute()),
                                  badgeText: ref
                                      .watch(parcelListProvider)
                                      .totalActiveCount
                                      .toString(),
                                ),
                                _buildSquareButton(
                                  context,
                                  icon: Remix.file_list_3_line,
                                  title:
                                      AppHelpers.getTranslation(TrKeys.order),
                                  onTap: () => context
                                      .pushRoute(const OrdersListRoute()),
                                  badgeText: ref
                                      .watch(ordersListProvider)
                                      .totalActiveCount
                                      .toString(),
                                ),
                                _buildSquareButton(
                                  context,
                                  icon: Remix.hand_coin_line,
                                  title: AppHelpers.getTranslation(
                                      TrKeys.inviteFriend),
                                  onTap: () => context
                                      .pushRoute(const ShareReferralRoute()),
                                ),
                              ],
                            ),
                            10.verticalSpace,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildSquareButton(
                                  context,
                                  icon: Remix.walk_line,
                                  title: AppHelpers.getTranslation(
                                      TrKeys.signUpToDeliver),
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const DeliveryPage(),
                                    ),
                                  ),
                                ),
                                _buildSquareButton(
                                  context,
                                  icon: Remix.store_fill,
                                  title: AppHelpers.getTranslation(
                                      TrKeys.becomeSeller),
                                  onTap: () => context
                                      .pushRoute(const CreateShopRoute()),
                                ),
                                _buildSquareButton(
                                  context,
                                  icon: Remix.lightbulb_flash_fill,
                                  iconColor: AppStyle.starColor,
                                  title:
                                      AppHelpers.getTranslation(TrKeys.about),
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AboutPage(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            10.verticalSpace,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if (state.userData?.role != userRole)
                                  _buildSquareButton(
                                    context,
                                    icon: Remix.questionnaire_line,
                                    title:
                                        AppHelpers.getTranslation(TrKeys.help),
                                    onTap: () =>
                                        context.pushRoute(const HelpRoute()),
                                  ),
                                if (state.userData?.role != userRole)
                                  _buildSquareButton(
                                    context,
                                    icon: Remix.contract_fill,
                                    title:
                                        AppHelpers.getTranslation(TrKeys.terms),
                                    onTap: () => context.pushRoute(
                                        const TermPage() as PageRouteInfo),
                                  ),
                                if (state.userData?.role != userRole)
                                  _buildSquareButton(
                                    context,
                                    icon: Remix.mail_forbid_fill,
                                    // iconColor: AppStyle.starColor,
                                    title: AppHelpers.getTranslation(
                                        TrKeys.privacyPolicy),
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const PolicyPage(),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            10.verticalSpace,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                AppHelpers.getReservationEnable()
                                    ? _buildSquareButton(
                                        context,
                                        icon: Remix.reserved_line,
                                        title: AppHelpers.getTranslation(
                                            TrKeys.reservation),
                                        onTap: () {
                                          AppHelpers.showAlertDialog(
                                            context: context,
                                            child: const SizedBox(
                                                child: ReservationShops()),
                                          );
                                        },
                                      )
                                    : _buildSquareButton(
                                        context,
                                        borderColor: AppStyle.white,
                                        backgroundColor: Colors.transparent,
                                      ),
                                AppHelpers.getReservationEnable()
                                    ? _buildSquareButton(
                                        context,
                                        icon: Remix.logout_box_r_line,
                                        title: AppHelpers.getTranslation(
                                            TrKeys.deleteAccount),
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
                                        backgroundColor: Colors.pink[50],
                                        iconColor: Colors.red,
                                        textColor: Colors.pink[700],
                                      )
                                    : _buildSquareButton(
                                        context,
                                        borderColor: AppStyle.white,
                                        backgroundColor: Colors.transparent,
                                      ),
                                AppHelpers.getReservationEnable()
                                    ? _buildSquareButton(
                                        context,
                                        borderColor: AppStyle.white,
                                        backgroundColor: Colors.transparent,
                                      )
                                    : _buildSquareButton(
                                        context,
                                        icon: Remix.logout_box_r_line,
                                        title: AppHelpers.getTranslation(
                                            TrKeys.deleteAccount),
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
                                        backgroundColor: Colors.pink[50],
                                        iconColor: Colors.red,
                                        textColor: Colors.pink[700],
                                      ),
                              ],
                            ),
                            10.verticalSpace,
                            Container(
                              decoration: BoxDecoration(
                                color: AppStyle.transparent,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      if (state.userData?.role == userRole)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const HelpPage()),
                                                );
                                              },
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    AppHelpers.getTranslation(
                                                        TrKeys.help),
                                                    style: const TextStyle(
                                                      color: AppStyle.black,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  const Icon(
                                                      Icons.circle_rounded,
                                                      color: AppStyle.black,
                                                      size: 7),
                                                ],
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const TermPage()),
                                                );
                                              },
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    AppHelpers.getTranslation(
                                                        TrKeys.terms),
                                                    style: const TextStyle(
                                                      color: AppStyle.black,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  const Icon(
                                                      Icons.circle_rounded,
                                                      color: AppStyle.black,
                                                      size: 7),
                                                ],
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const PolicyPage()),
                                                );
                                              },
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    AppHelpers.getTranslation(
                                                        TrKeys.privacyPolicy),
                                                    style: const TextStyle(
                                                      color: AppStyle.black,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            AppHelpers.getAppName() ?? "",
                                            style: AppStyle.interBold(
                                                color: AppStyle.brandGreen),
                                          ),
                                          const SizedBox(width: 4),
                                          const Icon(
                                            Remix.checkbox_blank_circle_fill,
                                            size: 8,
                                            color: AppStyle.black,
                                          ),
                                          FutureBuilder<bool>(
                                            future: checkApiStatus(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                bool isOnline = snapshot.data!;
                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    FutureBuilder<PackageInfo>(
                                                      future: PackageInfo
                                                          .fromPlatform(),
                                                      builder: (context,
                                                          packageSnapshot) {
                                                        if (packageSnapshot
                                                            .hasData) {
                                                          String versionDisplay;
                                                          if (kDebugMode) {
                                                            // This code runs in debug mode
                                                            versionDisplay =
                                                                " App Version ${packageSnapshot.data!.version}+${packageSnapshot.data!.buildNumber}";
                                                          } else {
                                                            // This code runs in release mode
                                                            versionDisplay =
                                                                " App Version ${packageSnapshot.data!.version}";
                                                          }

                                                          return Text(
                                                            versionDisplay,
                                                            style: AppStyle
                                                                .interNormal(
                                                                    color: AppStyle
                                                                        .black),
                                                          );
                                                        } else {
                                                          return const SizedBox
                                                              .shrink();
                                                        }
                                                      },
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Icon(
                                                      Remix
                                                          .checkbox_blank_circle_fill,
                                                      size: 20,
                                                      color: isOnline
                                                          ? Colors.green
                                                          : Colors.red,
                                                    ),
                                                    Text(
                                                      isOnline
                                                          ? 'Online'
                                                          : 'Offline',
                                                      style: TextStyle(
                                                          color: isOnline
                                                              ? Colors.green
                                                              : Colors.red),
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

  Widget _buildSquareButton(
    BuildContext context, {
    IconData? icon,
    String? title,
    VoidCallback? onTap,
    Color? backgroundColor,
    Color? iconColor,
    Color? textColor,
    Color? borderColor,
    String? badgeText,
    double width = 100,
    double height = 100,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width.w,
        height: height.w,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppStyle.white,
          borderRadius: BorderRadius.circular(20.r),
          border: borderColor != null ? Border.all(color: borderColor) : null,
          boxShadow: [
            if (backgroundColor != Colors.transparent)
              BoxShadow(
                color: AppStyle.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: (icon != null || title != null)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null)
                    Badge(
                      isLabelVisible: badgeText != null,
                      label: Text(badgeText ?? ''),
                      child: Icon(icon,
                          size: 30.r, color: iconColor ?? AppStyle.black),
                    ),
                  if (icon != null && title != null) 8.verticalSpace,
                  if (title != null)
                    Text(
                      title,
                      style: AppStyle.interNormal(
                          size: 14.sp, color: textColor ?? AppStyle.black),
                      textAlign: TextAlign.center,
                    ),
                ],
              )
            : null, // If no icon or title, don't create the Column
      ),
    );
  }
}
