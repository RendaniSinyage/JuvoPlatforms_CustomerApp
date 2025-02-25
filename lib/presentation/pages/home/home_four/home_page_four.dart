import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../application/currency/currency_provider.dart';
import '../../../../application/home/home_notifier.dart';
import '../../../../application/home/home_provider.dart';
import '../../../../application/home/home_state.dart';
import '../../../../application/main/main_provider.dart';
import '../../../../application/map/view_map_provider.dart';
import '../../../../application/profile/profile_provider.dart';
import '../../../../application/shop_order/shop_order_provider.dart';
import '../../../../infrastructure/services/app_helpers.dart';
import '../../../../infrastructure/services/local_storage.dart';
import '../../../../infrastructure/services/tr_keys.dart';
import '../../../../infrastructure/models/data/user.dart';
import '../../../components/title_icon.dart';
import 'app_bar_home.dart';
import 'category_screen.dart';
import '../../../theme/theme.dart';
import 'package:remixicon/remixicon.dart';
import '../../../../infrastructure/models/data/product_data.dart';
import 'widgets/market_one_item.dart';
import 'banner_three.dart';
import 'filter_category_shop_three.dart';
import 'shimmer/banner_shimmer.dart';
import 'widgets/recommended_four_screen.dart';
import 'widgets/recommended_screen.dart';
import 'widgets/shop_bar_item_three.dart';
import 'shimmer/all_shop_two_shimmer.dart';
import 'widgets/discounted_products_section.dart';
import 'widgets/market_two_item.dart';
import 'shimmer/recommend_shop_shimmer.dart';
import 'shimmer/shop_shimmer.dart';
import 'widgets/banner_item.dart';
import 'widgets/recommended_item.dart';

class HomePageFour extends ConsumerStatefulWidget {
  const HomePageFour({
    super.key,
  });

  @override
  ConsumerState<HomePageFour> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePageFour> {
  late HomeNotifier event;
  late UserModel userModelInstance;
  final RefreshController _bannerController = RefreshController();
  final RefreshController _restaurantController = RefreshController();
  final RefreshController _categoryController = RefreshController();
  final RefreshController _storyController = RefreshController();
  final PageController _pageController = PageController();
  late ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final notifier = ref.read(homeProvider.notifier);

      // Initialize address and basic data
      notifier.setAddress();

      // Load data in sequence, with discount products (and hence brands) last
      await Future.wait([
        Future(() => notifier.fetchBanner(context)),
        Future(() => notifier.fetchShopRecommend(context)),
        Future(() => notifier.fetchShop(context)),
        Future(() => notifier.fetchStore(context)),
        Future(() => notifier.fetchRestaurant(context)),
        Future(() => notifier.fetchRestaurantNew(context)),
        Future(() => notifier.fetchAds(context)),
        Future(() => notifier.fetchCategories(context)),
      ]);

      // Now fetch discount products which will also load brands
      await Future(() => notifier.fetchDiscountProducts(context));

      // Map and user data
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
    _pageController.dispose();
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
          ..fetchDiscountProducts(context)
          ..fetchRestaurantPageNew(context, _restaurantController,
              isRefresh: true)
          ..fetchShopPageRecommend(context, _restaurantController,
              isRefresh: true))
        : event.fetchFilterRestaurant(context,
            controller: _restaurantController, isRefresh: true);
  }

  // Helper method to reorder products to avoid consecutive items from the same shop
  List<ProductData> _reorderProductsToAvoidConsecutiveShops(
      List<ProductData> products) {
    if (products.length <= 1) {
      return products;
    }

    // Group products by shop
    final Map<int?, List<ProductData>> shopGroups = {};

    for (var product in products) {
      final shopId = product.shopId;
      if (shopId == null) continue;

      if (!shopGroups.containsKey(shopId)) {
        shopGroups[shopId] = [];
      }
      shopGroups[shopId]!.add(product);
    }

    // Count number of shops
    final shopIds = shopGroups.keys.toList();

    // If only one shop, we can't avoid consecutive products
    if (shopIds.length <= 1) {
      debugPrint(
          "Only products from one shop, can't avoid consecutive display");
      return products;
    }

    // Apply a maximum limit for reasonable horizontal scrolling
    const int maxProducts = 15;

    // Now alternate between shops as much as possible
    final List<ProductData> result = [];
    int currentShopIndex = 0;

    // Remove empty shop groups and make a copy for manipulation
    final Map<int?, List<ProductData>> workingGroups = {};
    for (var shopId in shopIds) {
      if (shopGroups[shopId]!.isNotEmpty) {
        workingGroups[shopId] = List<ProductData>.from(shopGroups[shopId]!);
      }
    }

    final List<int?> nonEmptyShopIds = workingGroups.keys.toList();

    // While there are still products to distribute and we haven't hit the max
    while (result.length < products.length && result.length < maxProducts) {
      // If all groups are now empty, break
      if (nonEmptyShopIds.isEmpty) break;

      final currentShopId = nonEmptyShopIds[currentShopIndex];

      // If this shop still has products
      if (workingGroups[currentShopId]!.isNotEmpty) {
        // Take one product from current shop
        result.add(workingGroups[currentShopId]!.removeAt(0));
      }

      // If this shop is now empty, remove it from rotation
      if (workingGroups[currentShopId]!.isEmpty) {
        nonEmptyShopIds.remove(currentShopId);
        if (nonEmptyShopIds.isEmpty) break;

        // Adjust current index if needed
        if (currentShopIndex >= nonEmptyShopIds.length) {
          currentShopIndex = 0;
        }
      } else {
        // Move to next shop
        currentShopIndex = (currentShopIndex + 1) % nonEmptyShopIds.length;
      }
    }

    debugPrint(
        "Reordered products: Original count=${products.length}, After reordering=${result.length}, Max=$maxProducts");

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeProvider);
    final bool isDarkMode = LocalStorage.getAppThemeMode();
    final bool isLtr = LocalStorage.getLangLtr();

    // Add a listener for debugging brands in HomeState
    ref.listen<HomeState>(homeProvider, (previous, current) {
      // Debug HomeState changes
      final prevBrandCount = previous?.brands.length ?? 0;
      final currentBrandCount = current.brands.length;

      if (prevBrandCount != currentBrandCount) {
        debugPrint(
            "🔍 HomeState brands changed: $prevBrandCount -> $currentBrandCount");

        if (currentBrandCount > 0) {
          debugPrint("✅ HomeState now has brands. First few:");
          final samplesToShow = currentBrandCount > 3 ? 3 : currentBrandCount;
          for (var i = 0; i < samplesToShow; i++) {
            debugPrint(
                "   - ${current.brands[i].title} (ID: ${current.brands[i].id})");
          }
        }
      }

      final prevProductCount = previous?.discountProducts.length ?? 0;
      final currentProductCount = current.discountProducts.length;

      if (prevProductCount != currentProductCount) {
        debugPrint(
            "🔍 HomeState discount products changed: $prevProductCount -> $currentProductCount");
      }
    });

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
        (state.story?.length ?? 0) >= 3
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
        state.isBannerLoading
            ? const BannerShimmer()
            : BannerThree(
                bannerController: _bannerController,
                pageController: _pageController,
                banners: state.banners,
                notifier: event,
              ),
        16.verticalSpace,
        state.isShopLoading
            ? ShopShimmer(
                title: AppHelpers.getTranslation(TrKeys.favouriteBrand),
              )
            : state.shops.isNotEmpty
                ? Column(
                    children: [
                      TitleAndIcon(
                        isIcon: false,
                        title: AppHelpers.getTranslation(TrKeys.favouriteBrand),
                        onRightTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      RecommendedPage(isShop: true)));
                        },
                      ),
                      8.verticalSpace,
                      SizedBox(
                          height: 60.r,
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
                        rightTitle: state.shopsRecommend.length > 1
                            ? AppHelpers.getTranslation(TrKeys.seeAll)
                            : null,
                        isIcon: state.shopsRecommend.length > 1,
                        title: AppHelpers.getTranslation(TrKeys.recommended),
                        onRightTap: state.shopsRecommend.length > 1
                            ? () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RecommendedPage()));
                              }
                            : null,
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
                                    itemCount: state.shopsRecommend.length,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
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
            ? ShopShimmer(
                title: AppHelpers.getTranslation(TrKeys.newsOfWeek),
              )
            : state.newRestaurant.isNotEmpty
                ? Column(
                    children: [
                      TitleAndIcon(
                        title: AppHelpers.getTranslation(TrKeys.newsOfWeek),
                        secondTitle: AppHelpers.getAppName() ?? "",
                        secondTitleColor: AppStyle.primary,
                        rightTitle: state.newRestaurant.length > 6
                            ? AppHelpers.getTranslation(TrKeys.seeAll)
                            : null,
                        isIcon: state.newRestaurant.length > 6,
                        onRightTap: state.newRestaurant.length > 6
                            ? () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RecommendedPage(isNewsOfPage: true)
                                      )
                                  );
                              }
                            : null,
                      ),
                      8.verticalSpace,
                      SizedBox(
                        height: 60.r,
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
                                    isShop: true,
                                    shop: state.newRestaurant[index],
                                    isNewRestaurant: true,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
        state.newRestaurant.isNotEmpty ? 30.verticalSpace : 3.verticalSpace,
        state.isDiscountProductsLoading
            ? ShopShimmer(
                title: AppHelpers.getTranslation(TrKeys.save),
              )
            : state.discountProducts.length > 1
                ? Column(
                    children: [
                      // Show discount products section only if loading or has items
                      if (state.isDiscountProductsLoading ||
                          state.discountProducts.isNotEmpty)
                        Column(
                          children: [
                            TitleAndIcon(
                              title: AppHelpers.getTranslation(TrKeys.deals),
                              secondTitle: Remix.fire_fill,
                              secondTitleColor: AppStyle.primary,
                            ),
                            8.verticalSpace,
                            SizedBox(
                              child: state.isDiscountProductsLoading
                                  ? ShopShimmer(
                                      title: AppHelpers.getTranslation(
                                          TrKeys.deals),
                                    )
                                  : DiscountedProductsSection(
                                      products:
                                          _reorderProductsToAvoidConsecutiveShops(
                                              state.discountProducts),
                                      cartId: null,
                                    ),
                            ),
                            16.verticalSpace,
                          ],
                        ),
                    ],
                  )
                : const SizedBox.shrink(),
        state.isRestaurantLoading
            ? const AllShopTwoShimmer()
            : Column(
                children: [
                  TitleAndIcon(
                    rightTitle: AppHelpers.getTranslation(TrKeys.seeAll),
                    isIcon: true,
                    title: AppHelpers.getTranslation(TrKeys.popularNearYou),
                    onRightTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RecommendedFourPage(
                                  isPopular: true, bgImg: false)));
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
                                  bgImg: false),
                            ),
                          ),
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
