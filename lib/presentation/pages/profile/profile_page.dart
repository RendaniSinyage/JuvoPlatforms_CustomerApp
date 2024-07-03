// ignore_for_file: unused_result

import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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
import 'package:riverpodtemp/presentation/components/buttons/pop_button.dart';
import 'package:riverpodtemp/presentation/components/custom_network_image.dart';
import 'package:riverpodtemp/presentation/components/loading.dart';
import 'package:riverpodtemp/application/like/like_provider.dart';
import 'package:riverpodtemp/presentation/pages/profile/currency_page.dart';
import 'package:riverpodtemp/presentation/pages/profile/delete_screen.dart';
import 'package:riverpodtemp/presentation/routes/app_router.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'edit_profile_page.dart';
import '../../../../application/edit_profile/edit_profile_provider.dart';
import 'language_page.dart';
import 'reservation_shops.dart';
import 'widgets/profile_item.dart';

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
    final stateNotification = ref.watch(notificationProvider);
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
                                    MediaQuery.of(context).size.width - 150.w,
                                child: Text(
                                  "${state.userData?.firstname ?? ""} ${state.userData?.lastname ?? ""}",
                                  style: AppStyle.interNormal(
                                    size: 14,
                                    color: AppStyle.black,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width - 150.w,
                                child: Text(
                                  state.userData?.email ?? " ",
                                  style: AppStyle.interRegular(
                                    size: 12.sp,
                                    color: AppStyle.textGrey,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      IconButton(
                          onPressed: () {
                            AppHelpers.showAlertDialog(
                                context: context,
                                child: DeleteScreen(
                                  onDelete: () => time.cancel(),
                                ));
                          },
                          icon: const Icon(FlutterRemix.logout_circle_r_line))
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
                            if (AppConstants.isDemo)
                              ProfileItem(
                                isLtr: isLtr,
                                title: AppHelpers.getTranslation(TrKeys.uiType),
                                icon: FlutterRemix.typhoon_line,
                                onTap: () {
                                  context.pushRoute(UiTypeRoute(isBack: true));
                                },
                              ),
                            ProfileItem(
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
                            ),
                            ProfileItem(
                              isLtr: isLtr,
                              title:
                                  "${AppHelpers.getTranslation(TrKeys.wallet)}: ${AppHelpers.numberFormat(number: state.userData?.wallet?.price)}",
                              icon: FlutterRemix.wallet_3_line,
                              onTap: () {
                                context.pushRoute(const WalletHistoryRoute());
                              },
                            ),
                            AppHelpers.getReferralActive()
                                ? ProfileItem(
                                    isLtr: isLtr,
                                    title: AppHelpers.getTranslation(
                                        TrKeys.inviteFriend),
                                    icon: FlutterRemix.money_dollar_circle_line,
                                    onTap: () {
                                      context.pushRoute(
                                          const ShareReferralRoute());
                                    },
                                  )
                                : const SizedBox.shrink(),
                            ProfileItem(
                              isLtr: isLtr,
                              title: AppHelpers.getTranslation(TrKeys.order),
                              icon: FlutterRemix.history_line,
                              isCount: true,
                              count: ref
                                  .watch(ordersListProvider)
                                  .totalActiveCount
                                  .toString(),
                              onTap: () {
                                context.pushRoute(const OrdersListRoute());
                              },
                            ),
                            if (AppHelpers.getParcel())
                              ProfileItem(
                                isLtr: isLtr,
                                title:
                                    AppHelpers.getTranslation(TrKeys.parcels),
                                icon: FlutterRemix.archive_line,
                                isCount: true,
                                count: ref
                                    .watch(parcelListProvider)
                                    .totalActiveCount
                                    .toString(),
                                onTap: () {
                                  context.pushRoute(const ParcelListRoute());
                                },
                              ),
                            ProfileItem(
                              isLtr: isLtr,
                              title: AppHelpers.getTranslation(
                                  TrKeys.notifications),
                              icon: FlutterRemix.notification_2_line,
                              isCount: true,
                              count: (stateNotification
                                          .countOfNotifications?.notification ??
                                      0)
                                  .toString(),
                              onTap: () {
                                context
                                    .pushRoute(const NotificationListRoute());
                              },
                            ),
                            if (AppHelpers.getReservationEnable())
                              ProfileItem(
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
                            ProfileItem(
                              isLtr: isLtr,
                              title: AppHelpers.getTranslation(
                                  TrKeys.deliveryAddress),
                              icon: FlutterRemix.user_location_line,
                              onTap: () {
                                context.pushRoute(const AddressListRoute());
                              },
                            ),
                            if (widget.isBackButton)
                              ProfileItem(
                                isLtr: isLtr,
                                title: AppHelpers.getTranslation(TrKeys.liked),
                                icon: FlutterRemix.heart_3_line,
                                onTap: () {
                                  context.pushRoute(LikeRoute());
                                },
                              ),
                            ProfileItem(
                              isLtr: isLtr,
                              title: AppHelpers.getTranslation(
                                  TrKeys.becomeSeller),
                              icon: FlutterRemix.user_star_line,
                              onTap: () {
                                context.pushRoute(const CreateShopRoute());
                              },
                            ),
                            ProfileItem(
                              isLtr: isLtr,
                              title: AppHelpers.getTranslation(
                                  TrKeys.chatWithAdmin),
                              icon: FlutterRemix.chat_1_line,
                              onTap: () {
                                context.pushRoute(
                                    ChatRoute(roleId: "admin", name: "Admin"));
                              },
                            ),
                            ProfileItem(
                              isLtr: isLtr,
                              title: AppHelpers.getTranslation(TrKeys.language),
                              icon: FlutterRemix.global_line,
                              onTap: () {
                                AppHelpers.showCustomModalBottomSheet(
                                  isDismissible: false,
                                  context: context,
                                  modal: LanguageScreen(
                                    onSave: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  isDarkMode: isDarkMode,
                                );
                              },
                            ),
                            ProfileItem(
                              isLtr: isLtr,
                              title:
                                  AppHelpers.getTranslation(TrKeys.currencies),
                              icon: FlutterRemix.bank_card_line,
                              onTap: () {
                                AppHelpers.showCustomModalBottomSheet(
                                  context: context,
                                  modal: const CurrencyScreen(),
                                  isDarkMode: isDarkMode,
                                );
                              },
                            ),
                            ProfileItem(
                              isLtr: isLtr,
                              title: AppHelpers.getTranslation(
                                  TrKeys.notification),
                              icon: FlutterRemix.settings_4_line,
                              onTap: () {
                                context.pushRoute(const SettingRoute());
                              },
                            ),
                            ProfileItem(
                              isLtr: isLtr,
                              title: AppHelpers.getTranslation(TrKeys.help),
                              icon: FlutterRemix.question_line,
                              onTap: () {
                                context.pushRoute(const HelpRoute());
                              },
                            ),
                            ProfileItem(
                              isLtr: isLtr,
                              title: AppHelpers.getTranslation(TrKeys.about),
                              icon: FlutterRemix.bill_line,
                              onTap: () async {
                                // ignore: deprecated_member_use
                                await launch(
                                  "${AppConstants.webUrl}/about",
                                  enableJavaScript: true,
                                );
                              },
                            ),
                            ProfileItem(
                              isLtr: isLtr,
                              title: AppHelpers.getTranslation(TrKeys.careers),
                              icon: FlutterRemix.empathize_line,
                              onTap: () async {
                                // ignore: deprecated_member_use
                                await launch(
                                  "${AppConstants.webUrl}/careers",
                                  enableJavaScript: true,
                                );
                              },
                            ),
                            ProfileItem(
                              isLtr: isLtr,
                              title: AppHelpers.getTranslation(TrKeys.blogs),
                              icon: FlutterRemix.article_line,
                              onTap: () async {
                                // ignore: deprecated_member_use
                                await launch(
                                  "${AppConstants.webUrl}/blog",
                                  enableJavaScript: true,
                                );
                              },
                            ),
                            ProfileItem(
                              isLtr: isLtr,
                              title: AppHelpers.getTranslation(
                                  TrKeys.privacyPolicy),
                              icon: FlutterRemix.information_line,
                              onTap: () async {
                                context.pushRoute(const PolicyRoute());
                              },
                            ),
                            ProfileItem(
                              isLtr: isLtr,
                              title: AppHelpers.getTranslation(TrKeys.terms),
                              icon: FlutterRemix.file_info_line,
                              onTap: () async {
                                context.pushRoute(const TermRoute());
                              },
                            ),
                            // ProfileItem(
                            //   isLtr: isLtr,
                            //   title: AppHelpers.getTranslation(
                            //       TrKeys.signUpToDeliver),
                            //   icon: FlutterRemix.external_link_line,
                            //   onTap: () {
                            //     context.pushRoute(const HelpRoute());
                            //   },
                            // ),
                            ProfileItem(
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
                          ],
                        ),
                      ),
                    ),
                  )
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
