import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:riverpodtemp/infrastructure/models/response/categories_paginate_response.dart';
import 'package:riverpodtemp/presentation/pages/auth/login/login_page.dart';
import 'package:riverpodtemp/presentation/pages/auth/confirmation/register_confirmation_page.dart';
import 'package:riverpodtemp/presentation/pages/auth/register/register_page.dart';
import 'package:riverpodtemp/presentation/pages/auth/reset/reset_password_page.dart';
import 'package:riverpodtemp/presentation/pages/generate_image/generate_image_page.dart';
import 'package:riverpodtemp/presentation/pages/home/filter/result_filter.dart';
import 'package:riverpodtemp/presentation/pages/home_one/widget/recommended_one_screen.dart';
import 'package:riverpodtemp/presentation/pages/home_three/widgets/recommended_three_screen.dart';
import 'package:riverpodtemp/presentation/pages/home_two/widget/recommended_two_screen.dart';
import 'package:riverpodtemp/presentation/pages/initial/no_connection/no_connection_page.dart';
import 'package:riverpodtemp/presentation/pages/initial/splash/splash_page.dart';
import 'package:riverpodtemp/presentation/pages/initial/ui_type/ui_type_page.dart';
import 'package:riverpodtemp/presentation/pages/like/like_page.dart';
import 'package:riverpodtemp/presentation/pages/main/main_page.dart';
import 'package:riverpodtemp/presentation/pages/order/order_screen/order_screen.dart';
import 'package:riverpodtemp/presentation/pages/order/orders_page.dart';
import 'package:riverpodtemp/presentation/pages/parcel/parcel_list_page.dart';
import 'package:riverpodtemp/presentation/pages/parcel/parcel_order_page.dart';
import 'package:riverpodtemp/presentation/pages/parcel/widgets/info_screen.dart';
import 'package:riverpodtemp/presentation/pages/policy_term/policy_page.dart';
import 'package:riverpodtemp/presentation/pages/policy_term/term_page.dart';
import 'package:riverpodtemp/presentation/pages/profile/address_list.dart';
import 'package:riverpodtemp/presentation/pages/profile/notification_page.dart';
import 'package:riverpodtemp/presentation/pages/profile/profile_page.dart';
import 'package:riverpodtemp/presentation/pages/profile/share_referral_faq.dart';
import 'package:riverpodtemp/presentation/pages/search/search_page.dart';
import 'package:riverpodtemp/presentation/pages/service/service_two_category_page.dart';
import 'package:riverpodtemp/presentation/pages/setting/setting_page.dart';
import 'package:riverpodtemp/presentation/pages/shop/shop_detail.dart';
import 'package:riverpodtemp/presentation/pages/shop/shop_page.dart';
import 'package:riverpodtemp/presentation/pages/view_map/map_search_page.dart';
import 'package:riverpodtemp/presentation/pages/view_map/view_map_page.dart';

import '../../infrastructure/models/data/address_new_data.dart';
import '../../infrastructure/models/data/shop_data.dart';
import '../../infrastructure/models/data/user.dart';
import '../pages/chat/chat/chat_page.dart';
import '../pages/home/widgets/shops_banner_page.dart';
import '../pages/order/order_screen/order_progress_screen.dart';
import '../pages/parcel/parcel_page.dart';
import '../pages/profile/become_seller/create_shop.dart';
import '../pages/profile/help_page.dart';
import '../pages/home/widgets/recommended_screen.dart';
import '../pages/profile/share_referral_page.dart';
import '../pages/profile/wallet_history.dart';
import '../pages/shop/sub_category_screen.dart';
import '../pages/story_page/story_page.dart';


part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
    MaterialRoute(path: '/', page: SplashRoute.page),
    MaterialRoute(path: '/no-connection', page: NoConnectionRoute.page),
    MaterialRoute(path: '/login', page: LoginRoute.page),
    MaterialRoute(path: '/ui-type', page: UiTypeRoute.page),
    MaterialRoute(path: '/reset', page: ResetPasswordRoute.page),
    MaterialRoute(
        path: '/register-confirmation', page: RegisterConfirmationRoute.page),
    MaterialRoute(path: '/register', page: RegisterRoute.page),
    MaterialRoute(path: '/main', page: MainRoute.page),
    MaterialRoute(path: '/shop', page: ShopRoute.page),
    MaterialRoute(path: '/order', page: OrdersListRoute.page),
    MaterialRoute(path: '/setting', page: SettingRoute.page),
    MaterialRoute(path: '/orderScreen', page: OrderRoute.page),
    MaterialRoute(path: '/searchPage', page: SearchRoute.page),
    MaterialRoute(path: '/ProfilePage', page: ProfileRoute.page),
    MaterialRoute(path: '/map', page: ViewMapRoute.page),
    MaterialRoute(path: "/storyList", page: StoryListRoute.page),
    MaterialRoute(path: '/recommended', page: RecommendedRoute.page),
    MaterialRoute(path: '/recommended_one', page: RecommendedOneRoute.page),
    MaterialRoute(path: '/recommended_two', page: RecommendedTwoRoute.page),
    MaterialRoute(path: '/map_search', page: MapSearchRoute.page),
    MaterialRoute(path: '/help', page: HelpRoute.page),
    MaterialRoute(path: '/order_progress', page: OrderProgressRoute.page),
    MaterialRoute(path: '/result_filter', page: ResultFilterRoute.page),
    MaterialRoute(path: '/wallet_history', page: WalletHistoryRoute.page),
    MaterialRoute(path: '/create_shop', page: CreateShopRoute.page),
    MaterialRoute(path: '/shops_banner', page: ShopsBannerRoute.page),
    MaterialRoute(path: '/shops_detail', page: ShopDetailRoute.page),
    MaterialRoute(path: '/share_referral', page: ShareReferralRoute.page),
    MaterialRoute(path: '/share_referral_faq', page: ShareReferralFaqRoute.page),
    MaterialRoute(path: '/chat', page: ChatRoute.page),
    MaterialRoute(path: '/generate_image', page: GenerateImageRoute.page),
    MaterialRoute(
        path: '/notification_list_page', page: NotificationListRoute.page),
    MaterialRoute(
      path: '/service_two_category_page',
      page: ServiceTwoCategoryRoute.page,
    ),
    MaterialRoute(path: '/recommended_three', page: RecommendedThreeRoute.page),
    MaterialRoute(path: '/parcel_page', page: ParcelRoute.page),
    MaterialRoute(path: '/info_screen', page: InfoRoute.page),
    MaterialRoute(path: '/like_page', page: LikeRoute.page),
    MaterialRoute(path: '/parcel_list_page', page: ParcelListRoute.page),
    MaterialRoute(
        path: '/parcel_progress_page', page: ParcelProgressRoute.page),
    MaterialRoute(path: '/sub_category_page', page: SubCategoryRoute.page),
    MaterialRoute(path: '/address_list_page', page: AddressListRoute.page),
    MaterialRoute(path: '/term', page: TermRoute.page),
    MaterialRoute(path: '/policy', page: PolicyRoute.page),
  ];
}

