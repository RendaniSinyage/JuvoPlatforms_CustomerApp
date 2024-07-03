import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_remix/flutter_remix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:riverpodtemp/application/currency/currency_provider.dart';
import 'package:riverpodtemp/application/home/home_notifier.dart';
import 'package:riverpodtemp/application/home/home_provider.dart';
import 'package:riverpodtemp/application/home/home_state.dart';
import 'package:riverpodtemp/application/map/view_map_provider.dart';
import 'package:riverpodtemp/application/profile/profile_provider.dart';
import 'package:riverpodtemp/application/shop_order/shop_order_provider.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/local_storage.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';

import 'package:riverpodtemp/presentation/components/text_fields/search_text_field.dart';
import 'package:riverpodtemp/presentation/components/title_icon.dart';
import 'package:riverpodtemp/presentation/pages/home_three/banner_three.dart';
import 'package:riverpodtemp/presentation/pages/home_three/widgets/door_three.dart';
import 'package:riverpodtemp/presentation/pages/home_three/widgets/market_three_item.dart';
import 'package:riverpodtemp/presentation/pages/home_three/widgets/shop_see_all.dart';
import 'package:riverpodtemp/presentation/routes/app_router.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';
import 'package:upgrader/upgrader.dart';
import 'app_bar_home_three.dart';
import 'category_screen_three.dart';
import 'filter_category_shop_three.dart';
import 'shimmer/all_shop_shimmer.dart';
import 'shimmer/banner_shimmer.dart';
import 'shimmer/news_shop_shimmer.dart';
import 'shimmer/recommend_shop_shimmer.dart';
import 'shimmer/shop_shimmer_three.dart';
import 'widgets/explore_three.dart';
import 'widgets/recommended_three_item.dart';
import 'widgets/shop_bar_item_three.dart';

class HomePageThree extends ConsumerStatefulWidget {
  const HomePageThree({super.key});

  @override
  ConsumerState<HomePageThree> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePageThree> {
  late HomeNotifier event;
  final RefreshController _bannerController = RefreshController();
  final RefreshController _restaurantController = RefreshController();
  final RefreshController _categoryController = RefreshController();
  final RefreshController _storyController = RefreshController();
  final PageController _pageController = PageController();

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
        ..fetchAds(context)
        ..fetchRestaurantNew(context)
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
    _pageController.dispose();
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
    final event = ref.read(homeProvider.notifier);
    final bool isDarkMode = LocalStorage.getAppThemeMode();
    final bool isLtr = LocalStorage.getLangLtr();
    return UpgradeAlert(
      child: Directionality(
        textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
        child: Scaffold(
          backgroundColor: isDarkMode ? AppStyle.mainBackDark : AppStyle.white,
          body: SmartRefresher(
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
              padding: EdgeInsets.only(bottom: 120.r),
              children: [
                AppBarThree(state: state, event: event),
                12.verticalSpace,
                Padding(
                  padding: REdgeInsets.symmetric(horizontal: 12),
                  child: SearchTextField(
                    isRead: true,
                    isBorder: true,
                    onTap: () {
                      context.pushRoute(SearchRoute());
                    },
                    suffixIcon: const Icon(
                      FlutterRemix.equalizer_fill,
                      color: AppStyle.black,
                    ),
                  ),
                ),
                12.verticalSpace,
                state.isBannerLoading
                    ? const BannerShimmer()
                    : BannerThree(
                        bannerController: _bannerController,
                        pageController: _pageController,
                        banners: state.banners,
                        notifier: event,
                      ),
                CategoryScreenThree(
                  state: state,
                  categoryController: _categoryController,
                  event: event,
                  restaurantController: _restaurantController,
                ),
                state.selectIndexCategory == -1
                    ? _body(state, event, context)
                    : FilterCategoryShopThree(
                        state: state,
                        event: event,
                        shopController: _restaurantController),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _body(HomeState state, HomeNotifier event, BuildContext context) {
    return Column(
      children: [
        state.isShopLoading
            ? ShopShimmerThree(
                title: AppHelpers.getTranslation(TrKeys.chooseBrand),
              )
            : state.shops.isNotEmpty
                ? Column(
                    children: [
                      Text(
                        AppHelpers.getTranslation(TrKeys.chooseBrand),
                        style: AppStyle.interNoSemi(),
                      ),
                      AnimationLimiter(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 8.r,
                            crossAxisSpacing: 8.r,
                            mainAxisExtent: 168.r,
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.r, vertical: 16),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              state.shops.length > 5 ? 6 : state.shops.length,
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: index == 5
                                      ? ShopSeeAll(
                                          brandCount: state.totalShops,
                                        )
                                      : MarketThreeItem(
                                          isShop: true,
                                          shop: state.shops[index],
                                        ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
        if(AppHelpers.getParcel())
        const DoorThree(),
        state.story?.isNotEmpty ?? false
            ? SizedBox(
                height: 224.r,
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
                                  child: ShopBarItemThree(
                                    index: index,
                                    controller: _storyController,
                                    story: state.story?[index]?.first,
                                  ),
                                ),
                              )),
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
        16.verticalSpace,
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
                          context.pushRoute(
                              RecommendedThreeRoute(isNewsOfPage: true));
                        },
                      ),
                      12.verticalSpace,
                      AnimationLimiter(
                        child: ListView.builder(
                          padding: EdgeInsets.only(bottom: 16.r),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.newRestaurant.length,
                          itemBuilder: (context, index) =>
                              AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: MarketThreeItem(
                                  shop: state.newRestaurant[index],
                                  isSimpleShop: true,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
        24.verticalSpace,
        state.isShopRecommendLoading
            ? const RecommendShopShimmer()
            : state.shopsRecommend.isNotEmpty
                ? Column(
                    children: [
                      TitleAndIcon(
                        rightTitle: AppHelpers.getTranslation(TrKeys.seeAll),
                        isIcon: true,
                        title: AppHelpers.getTranslation(TrKeys.recommended),
                        onRightTap: () {
                          context.pushRoute(RecommendedThreeRoute());
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
                                    child: RecommendedThreeItem(
                                      shop: state.shopsRecommend[index],
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
        ExploreThree(
          list: state.ads,
        ),
        12.verticalSpace,
        state.isRestaurantLoading
            ? const AllShopShimmer()
            : Column(
                children: [
                  TitleAndIcon(
                    title: AppHelpers.getTranslation(TrKeys.allRestaurants),
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
                                  child: MarketThreeItem(
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
