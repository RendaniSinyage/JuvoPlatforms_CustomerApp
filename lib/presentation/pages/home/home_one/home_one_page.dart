import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodyman/presentation/pages/home/shimmer/news_shop_shimmer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:foodyman/application/currency/currency_provider.dart';
import 'package:foodyman/application/home/home_notifier.dart';
import 'package:foodyman/application/home/home_provider.dart';
import 'package:foodyman/application/home/home_state.dart';
import 'package:foodyman/application/map/view_map_provider.dart';
import 'package:foodyman/application/profile/profile_provider.dart';
import 'package:foodyman/application/shop_order/shop_order_provider.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/local_storage.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:foodyman/presentation/components/title_icon.dart';
import 'package:foodyman/presentation/pages/home/shimmer/all_shop_shimmer.dart';
import 'package:foodyman/presentation/pages/home/shimmer/recommend_shop_shimmer.dart';
import 'package:foodyman/presentation/pages/home/home_one/category_one.dart';
import 'package:foodyman/presentation/pages/home/home_one/widget/banner_one_item.dart';
import 'package:foodyman/presentation/routes/app_router.dart';
import 'package:foodyman/presentation/theme/app_style.dart';

import 'app_bar_one.dart';
import 'filter_category_one_shop.dart';
import 'widget/banner_one_shimmer.dart';
import 'widget/door_to_door.dart';
import 'widget/market_one_item.dart';
import 'widget/recommended_one_item.dart';
import 'widget/shop_bar_one_item.dart';

class HomeOnePage extends ConsumerStatefulWidget {
  const HomeOnePage({super.key});

  @override
  ConsumerState<HomeOnePage> createState() => _HomeOnePageState();
}

class _HomeOnePageState extends ConsumerState<HomeOnePage> {
  late HomeNotifier event;
  final RefreshController _bannerController = RefreshController();
  final RefreshController _restaurantController = RefreshController();
  final RefreshController _storyController = RefreshController();
  final RefreshController _categoryController = RefreshController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeProvider.notifier)
        ..setAddress()
        ..fetchBanner(context)
        ..fetchShopRecommend(context)
        ..fetchShop(context)
        ..fetchStore(context)
        ..fetchRestaurant(context)
        ..fetchRestaurantNew(context)
        ..fetchAds(context)
        ..fetchCategories(context);
      ref.read(viewMapProvider.notifier).checkAddress(context);
      ref.read(currencyProvider.notifier).fetchCurrency(context);
      if (LocalStorage.getToken().isNotEmpty) {
        ref.read(shopOrderProvider.notifier).getCart(context, () {});
        ref.read(profileProvider.notifier).fetchUser(context);
      }
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    event = ref.read(homeProvider.notifier);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bannerController.dispose();
    _categoryController.dispose();
    _restaurantController.dispose();
    _storyController.dispose();
    super.dispose();
  }

  void _onLoading() {
    if (ref.watch(homeProvider).selectIndexCategory == -1) {
      event.fetchRestaurantPage(context, _restaurantController);
    } else {
      event.fetchFilterRestaurant(context, controller: _restaurantController);
    }
  }

  void _onRefresh() {
    ref.watch(homeProvider).selectIndexCategory == -1
        ? (event
      ..fetchBannerPage(context, _restaurantController, isRefresh: true)
      ..fetchRestaurantPage(context, _restaurantController, isRefresh: true)
      ..fetchCategoriesPage(context, _restaurantController, isRefresh: true)
      ..fetchStorePage(context, _restaurantController, isRefresh: true)
      ..fetchShopPage(context, _restaurantController, isRefresh: true)
      ..fetchAds(context)
      ..fetchRestaurantPageNew(context, _restaurantController,
          isRefresh: true)
      ..fetchShopPageRecommend(context, _restaurantController,
          isRefresh: true))
        : event.fetchFilterRestaurant(context, controller: _restaurantController,isRefresh: true);
  }


  @override
  Widget build(BuildContext context) {

    final state = ref.watch(homeProvider);
    final bool isLtr = LocalStorage.getLangLtr();
    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppStyle.bgGrey,
        body: Column(
          children: [
            AppBarOne(state: state, event: event),
            Expanded(
              child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                physics: const BouncingScrollPhysics(),
                controller: _restaurantController,
                header: WaterDropMaterialHeader(
                  distance: 160.h,
                  backgroundColor: AppStyle.white,
                  color: AppStyle.textGrey,
                ),
                onLoading: () => _onLoading(),
                onRefresh: () => _onRefresh(),
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 24.r),
                  children: [
                    CategoryOne(
                        state: state,
                        event: event,
                        categoryController: _categoryController,
                        restaurantController: _restaurantController,
                       ),
                   state.selectIndexCategory == -1
                            ? _body(state, context)
                            : FilterCategoryOneShop(
                                state: state,
                                event: event,
                                shopController: _restaurantController),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _body(HomeState state, BuildContext context) {
    return Column(
      children: [
        state.isBannerLoading
            ? const BannerOneShimmer()
            : Column(
                children: [
                  Container(
                    height: state.banners.isNotEmpty ? 150.h : 0,
                    margin: EdgeInsets.only(
                        bottom: state.banners.isNotEmpty ? 30.h : 0),
                    child: SmartRefresher(
                      scrollDirection: Axis.horizontal,
                      enablePullDown: false,
                      enablePullUp: true,
                      controller: _bannerController,
                      onLoading: () async {
                        await event.fetchBannerPage(context, _bannerController);
                      },
                      child: AnimationLimiter(
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: state.banners.length,
                          padding: EdgeInsets.only(left: 16.w),
                          itemBuilder: (context, index) =>
                              AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: BannerOneItem(
                                  banner: state.banners[index],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
        state.shops.isNotEmpty
            ? Column(
                children: [
                  TitleAndIcon(
                    rightTitle: AppHelpers.getTranslation(TrKeys.seeAll),
                    isIcon: true,
                    title: AppHelpers.getTranslation(TrKeys.favouriteBrand),
                    onRightTap: () {
                      context.pushRoute(RecommendedOneRoute(isShop: true));
                    },
                  ),
                  12.verticalSpace,
                  SizedBox(
                      height: 126.r,
                      child: AnimationLimiter(
                        child: ListView.builder(
                          padding: EdgeInsets.only(left: 16.r),
                          
                          scrollDirection: Axis.horizontal,
                          itemCount: state.shops.length,
                          itemBuilder: (context, index) =>
                              AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: MarketOneItem(
                                  isShop: true,
                                  shop: state.shops[index],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )),
                  16.verticalSpace,
                ],
              )
            : const SizedBox.shrink(),
        state.story?.isNotEmpty ?? false
            ? Column(
                children: [
                  TitleAndIcon(
                    isIcon: false,
                    title: AppHelpers.getTranslation(TrKeys.stories),
                  ),
                  12.verticalSpace,
                  SizedBox(
                    height: 160.r,
                    child: SmartRefresher(
                      controller: _storyController,
                      scrollDirection: Axis.horizontal,
                      enablePullDown: false,
                      enablePullUp: true,
                      onLoading: () async {
                        await event.fetchStorePage(context, _storyController);
                      },
                      child: AnimationLimiter(
                        child: ListView.builder(
                          shrinkWrap: true,
                          
                          scrollDirection: Axis.horizontal,
                          itemCount: state.story?.length ?? 0,
                          padding: EdgeInsets.only(left: 16.w),
                          itemBuilder: (context, index) =>
                              AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 375),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: ShopBarOneItem(
                                        index: index,
                                        controller: _storyController,
                                        story: state.story?[index]?.first,
                                      ),
                                    ),
                                  )),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : const SizedBox.shrink(),
        if(AppHelpers.getParcel())
        const DoorToDoor(),
        state.isShopRecommendLoading
            ? const RecommendShopShimmer()
            : state.shopsRecommend.isNotEmpty
                ? Column(
                    children: [
                      TitleAndIcon(
                        rightTitle: AppHelpers.getTranslation(TrKeys.seeAll),
                        isIcon: true,
                        title: AppHelpers.getTranslation(TrKeys.popularNearYou),
                        onRightTap: () {
                          context.pushRoute(RecommendedOneRoute());
                        },
                      ),
                      12.verticalSpace,
                      SizedBox(
                          height: 170.h,
                          child: AnimationLimiter(
                            child: ListView.builder(
                              shrinkWrap: false,
                              
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              itemCount: state.shopsRecommend.length,
                              itemBuilder: (context, index) =>
                                  AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 375),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: RecommendedOneItem(
                                      shop: state.shopsRecommend[index],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )),
                      30.verticalSpace,
                    ],
                  )
                : const SizedBox.shrink(),
        state.isRestaurantNewLoading
            ? NewsShopShimmer(
                title: AppHelpers.getTranslation(TrKeys.newsOfWeek),
              )
            : state.newRestaurant.isNotEmpty
                ? Column(
                    children: [
                      TitleAndIcon(
                        rightTitle: AppHelpers.getTranslation(TrKeys.seeAll),
                        isIcon: true,
                        title: AppHelpers.getTranslation(TrKeys.newsOfWeek),
                        onRightTap: () {
                          context
                              .pushRoute(RecommendedOneRoute(isNewsOfPage: true));
                        },
                      ),
                      12.verticalSpace,
                      SizedBox(
                          height: 250.h,
                          child: AnimationLimiter(
                            child: ListView.builder(
                              padding: EdgeInsets.only(left: 16.r),
                              
                              scrollDirection: Axis.horizontal,
                              itemCount: state.newRestaurant.length,
                              itemBuilder: (context, index) =>
                                  AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 375),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: MarketOneItem(
                                      shop: state.newRestaurant[index],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )),
                    ],
                  )
                : const SizedBox.shrink(),
        30.verticalSpace,
        state.isRestaurantLoading
            ? const AllShopShimmer()
            : Column(
                children: [
                  TitleAndIcon(
                    title: AppHelpers.getTranslation(TrKeys.allShops),
                  ),
                  state.restaurant.isNotEmpty
                      ? AnimationLimiter(
                          child: ListView.builder(
                            padding: EdgeInsets.only(top: 6.h),
                            shrinkWrap: true,
                            
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: state.restaurant.length,
                            itemBuilder: (context, index) =>
                                AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: MarketOneItem(
                                    shop: state.restaurant[index],
                                    isSimpleShop: true,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : SvgPicture.asset(
                          "assets/svgs/empty.svg",
                          height: 100.h,
                        )
                ],
              ),
      ],
    );
  }
}
