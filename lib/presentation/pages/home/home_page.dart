import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:riverpodtemp/application/currency/currency_provider.dart';

import 'package:riverpodtemp/application/home/home_notifier.dart';
import 'package:riverpodtemp/application/home/home_provider.dart';
import 'package:riverpodtemp/application/home/home_state.dart';
import 'package:riverpodtemp/application/main/main_provider.dart';
import 'package:riverpodtemp/application/map/view_map_provider.dart';
import 'package:riverpodtemp/application/profile/profile_provider.dart';

import 'package:riverpodtemp/application/shop_order/shop_order_provider.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/local_storage.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
//Added the following
import 'package:riverpodtemp/presentation/pages/home_one/widget/market_one_item.dart';
import 'package:riverpodtemp/presentation/pages/home_three/banner_three.dart';
import 'package:riverpodtemp/infrastructure/models/data/user.dart';

///ends here
import 'package:riverpodtemp/presentation/components/title_icon.dart';
import 'package:riverpodtemp/presentation/pages/home/app_bar_home.dart';
import 'package:riverpodtemp/presentation/pages/home/category_screen.dart';
import 'package:riverpodtemp/presentation/pages/home_three/filter_category_shop_three.dart';
//import 'package:riverpodtemp/presentation/pages/home_two/filter_category_shop_two.dart';
import 'package:riverpodtemp/presentation/routes/app_router.dart';
import 'package:riverpodtemp/presentation/theme/theme.dart';

import 'package:riverpodtemp/presentation/pages/home_two/widget/market_two_item.dart';
import 'package:riverpodtemp/presentation/pages/home_two/shimmer/all_shop_two_shimmer.dart';
import 'package:riverpodtemp/presentation/pages/home_three/shimmer/banner_shimmer.dart';
import 'shimmer/news_shop_shimmer.dart';
import 'shimmer/recommend_shop_shimmer.dart';
import 'shimmer/shop_shimmer.dart';
import 'widgets/banner_item.dart';
import 'widgets/recommended_item.dart';
import 'package:riverpodtemp/presentation/pages/home_three/widgets/shop_bar_item_three.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late HomeNotifier event;
  late UserModel userModelInstance;
  final RefreshController _bannerController = RefreshController();
  final RefreshController _restaurantController = RefreshController();
  final RefreshController _categoryController = RefreshController();
  final RefreshController _storyController = RefreshController();
  final PageController _pageController = PageController(); //added
  late ScrollController _controller;

  @override
  void initState() {
    // userModelInstance = UserModel(); // Initialize userModelInstance
    _controller = ScrollController();
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
    _controller.addListener(listen);
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
    _pageController.dispose(); //Added
    _controller.removeListener(listen);
    super.dispose();
  }

  void listen() {
    final direction = _controller.position.userScrollDirection;
    if (direction == ScrollDirection.reverse) {
      ref.read(mainProvider.notifier).changeScrolling(true);
    } else if (direction == ScrollDirection.forward) {
      ref.read(mainProvider.notifier).changeScrolling(false);
    }
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
        : event.fetchFilterRestaurant(context,
            controller: _restaurantController, isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeProvider);

    final bool isDarkMode = LocalStorage.getAppThemeMode();
    final bool isLtr = LocalStorage.getLangLtr();
    //final bool isLoggedIn = LocalStorage.getToken().isNotEmpty; // Check if the user is logged in
    //final firstName = LocalStorage.getFirstName();
    // final lastName = LocalStorage.getLastName();

    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: isDarkMode ? AppStyle.mainBackDark : AppStyle.bgGrey,
        body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          physics: const BouncingScrollPhysics(),
          controller: _restaurantController,
          scrollController: _controller,
          header: WaterDropMaterialHeader(
            distance: 160.h,
            backgroundColor: AppStyle.white,
            color: AppStyle.textGrey,
          ),
          onLoading: () => _onLoading(),
          onRefresh: () => _onRefresh(),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(bottom: 56.h),
              child: Column(
                children: [
                  AppBarHome(state: state, event: event),
                  CategoryScreen(
                    state: state,
                    event: event,
                    categoryController: _categoryController,
                    restaurantController: _restaurantController,
                  ),
                  state.selectIndexCategory == -1
                      ? _body(state, context)
                      : FilterCategoryShopThree(
                          state: state,
                          event: event,
                          shopController: _restaurantController,
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _body(HomeState state, BuildContext context) {
    return Column(
      children: [
        state.story?.isNotEmpty ?? false
            ? SizedBox(
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
        //8.verticalSpace,
        state.isBannerLoading
            ? const BannerShimmer()
            : BannerThree(
                bannerController: _bannerController,
                pageController: _pageController,
                banners: state.banners,
                notifier: event,
              ),
        8.verticalSpace,
        state.isShopLoading
            ? ShopShimmer(
                title: AppHelpers.getTranslation(TrKeys.shops),
              )
            : state.shops.isNotEmpty
                ? Column(
                    children: [
                      TitleAndIcon(
                        // rightTitle: AppHelpers.getTranslation(TrKeys.seeAll),
                        isIcon: false,
                        title: AppHelpers.getTranslation(TrKeys.favouriteBrand),
                        onRightTap: () {
                          context.pushRoute(RecommendedRoute(isShop: true));
                        },
                      ),

                      8.verticalSpace,
                      SizedBox(
//                      height: 126.r,
                          height: 60.r, //changed
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
                      //    8.verticalSpace,
                    ],
                  )
                : const SizedBox.shrink(),

        8.verticalSpace,
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
                          context.pushRoute(RecommendedRoute());
                        },
                      ),
                      8.verticalSpace,
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
                                    child: RecommendedItem(
                                      shop: state.shopsRecommend[index],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )),
                      12.verticalSpace,
                    ],
                  )
                : const SizedBox.shrink(),

        if (state.ads.isNotEmpty)
          Column(
            children: [
              TitleAndIcon(
                title: AppHelpers.getTranslation(TrKeys.newItem),
              ),
              8.verticalSpace,
              Container(
                height: state.ads.isNotEmpty ? 120.h : 0,
                margin:
                    EdgeInsets.only(bottom: state.ads.isNotEmpty ? 30.h : 0),
                child: AnimationLimiter(
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: state.ads.length,
                    padding: EdgeInsets.only(left: 16.w),
                    itemBuilder: (context, index) =>
                        AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: state.isBannerLoading
                              ? const BannerShimmer()
                              : BannerItem(
                                  isAds: true,
                                  banner: state.ads[index],
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
                              .pushRoute(RecommendedRoute(isNewsOfPage: true));
                          //   .pushRoute(RecommendedTwoRoute(isNewsOfPage: true));
                        },
                      ),
                      8.verticalSpace,
                      SizedBox(
                          height: 240.r,
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
                                    child: MarketTwoItem(
                                      shop: state.newRestaurant[index],
                                      isSimpleShop: true,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )),
                    ],
                  )
                : const SizedBox.shrink(),

        8.verticalSpace,
        state.isRestaurantLoading
            ? const AllShopTwoShimmer()
            : Column(
                children: [
                  TitleAndIcon(
                     rightTitle: AppHelpers.getTranslation(TrKeys.seeAll),
                    isIcon: true,
                    title: AppHelpers.getTranslation(TrKeys.popularNearYou),
                   // title: "${state.restaurant.length} ${AppHelpers.getTranslation(TrKeys.popularNearYou)}",
                    onRightTap: () {
                      context.pushRoute(RecommendedTwoRoute(isPopular: true));
                    },
                  ),
                  8.verticalSpace,
                  SizedBox(
                      height: 250.r,
                      child: AnimationLimiter(
                        child: ListView.builder(
                          padding: EdgeInsets.only(left: 16.r),
                          scrollDirection: Axis.horizontal,
                          itemCount: state.restaurant.length,
                          itemBuilder: (context, index) =>
                              AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: MarketTwoItem(
                                  shop: state.restaurant[index],
                                  isSimpleShop: true,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ))
                ],
              ),
      ],
    );
  }
}
