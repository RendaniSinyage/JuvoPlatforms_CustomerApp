import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:foodyman/application/home/home_provider.dart';
import 'package:foodyman/application/search/search_state.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/tpying_delay.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:foodyman/presentation/components/app_bars/common_app_bar.dart';
import 'package:foodyman/presentation/components/buttons/pop_button.dart';
import 'package:foodyman/presentation/components/keyboard_dismisser.dart';
import 'package:foodyman/presentation/components/tab_bar_item.dart';
import 'package:foodyman/presentation/components/text_fields/search_text_field.dart';
import 'package:foodyman/presentation/components/title_icon.dart';
import 'package:foodyman/presentation/theme/theme.dart';
import 'package:foodyman/application/search/search_notifier.dart';
import 'package:foodyman/application/search/search_provider.dart';
import 'package:foodyman/application/main/main_provider.dart';
import 'shimmer/category_shimmer.dart';
import 'shimmer/search_product_shimmer.dart';
import 'shimmer/search_shop_shimmer.dart';
import 'widgets/product_item.dart';
import 'widgets/restaurant_item.dart';
import 'widgets/search_result.dart';


@RoutePage()
class SearchPage extends ConsumerStatefulWidget {
  final bool isBackButton;

  const SearchPage({
    super.key,
    this.isBackButton = true,
  });

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  late SearchNotifier event;
  late RefreshController _categoryController;
  late RefreshController _categoryControllerTwo;
  late RefreshController _productController;
  late ScrollController _controller;
  late TextEditingController _searchController;
  final _delayed = Delayed(milliseconds: 700);

  @override
  void initState() {
    _categoryController = RefreshController();
    _categoryControllerTwo = RefreshController();
    _productController = RefreshController();
    _controller = ScrollController();
    _searchController = TextEditingController();
    _controller.addListener(listen);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchProvider.notifier).init();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    event = ref.read(searchProvider.notifier);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _productController.dispose();
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchProvider);
    return KeyboardDismisser(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppStyle.bgGrey,
        body: Column(
          children: [
            CommonAppBar(
                isSearchPage: true,
                child: SearchTextField(
                  textEditingController: _searchController,
                  onChanged: (s) {
                    _delayed.run(() {
                      event.changeSearch(s);
                      if (s.trim().isNotEmpty) {
                        event
                          ..searchShop(context, s,
                              categoryId: state.selectIndexCategory >= 0
                                  ? ref
                                      .watch(homeProvider)
                                      .categories[state.selectIndexCategory]
                                      .id
                                  : null)
                          ..searchProduct(context, s);
                      }
                    });
                  },
                )),
            SizedBox(
              height: MediaQuery.sizeOf(context).height -
                  76.h -
                  ((MediaQuery.paddingOf(context).top > 34)
                      ? 34.h
                      : MediaQuery.paddingOf(context).top),
              child: state.search.isEmpty
                  ? _categoryAndSearchHistory(state, context)
                  : _searchResultBody(context, state),
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

  Widget _resultEmpty() {
    return Column(
      children: [
        Lottie.asset("assets/lottie/not-found.json", height: 200.h),
        Text(
          AppHelpers.getTranslation(TrKeys.nothingFound),
          style: AppStyle.interSemi(size: 18.sp),
        ),
      ],
    );
  }

  Widget _searchResultBody(BuildContext context, SearchState state) {
    return SmartRefresher(
      scrollDirection: Axis.vertical,
      enablePullDown: false,
      enablePullUp: true,
      scrollController: _controller,
      controller: _productController,
      onLoading: () async {
        await event.searchProductPage(context, state.search);
        _productController.loadComplete();
      },
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: [
          16.verticalSpace,
          ref.watch(homeProvider).isCategoryLoading
              ? const SearchCategoryShimmer()
              : ref.watch(homeProvider).categories.isNotEmpty
                  ? Column(
                      children: [
                        SizedBox(
                          height: 36.h,
                          child: SmartRefresher(
                            scrollDirection: Axis.horizontal,
                            enablePullDown: false,
                            enablePullUp: true,
                            controller: _categoryController,
                            onLoading: () async {
                              await ref
                                  .read(homeProvider.notifier)
                                  .fetchCategoriesPage(
                                      context, _categoryController);
                            },
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    ref.watch(homeProvider).categories.length,
                                padding: EdgeInsets.only(left: 16.w),
                                itemBuilder: (context, index) {
                                  return TabBarItem(
                                    isShopTabBar: true,
                                    title: ref
                                            .watch(homeProvider)
                                            .categories[index]
                                            .translation
                                            ?.title ??
                                        "",
                                    currentIndex: state.selectIndexCategory,
                                    index: index,
                                    onTap: () => event.setSelectCategory(
                                        index, context,
                                        categoryId: state.selectIndexCategory >=
                                                0
                                            ? ref
                                                .watch(homeProvider)
                                                .categories[
                                                    state.selectIndexCategory]
                                                .id
                                            : null),
                                  );
                                }),
                          ),
                        ),
                        30.verticalSpace,
                      ],
                    )
                  : const SizedBox.shrink(),
          state.isShopLoading
              ? const SearchShopShimmer()
              : Column(
                  children: [
                    TitleAndIcon(
                        title: AppHelpers.getTranslation(TrKeys.restaurants),
                        rightTitle:
                            "${AppHelpers.getTranslation(TrKeys.found)} ${state.shops.length} ${AppHelpers.getTranslation(TrKeys.results)}"),
                    20.verticalSpace,
                    state.shops.isNotEmpty
                        ? AnimationLimiter(
                            child: ListView.builder(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.shops.length,
                                itemBuilder: (context, index) {
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 375),
                                    child: SlideAnimation(
                                      horizontalOffset: 50.0,
                                      child: FadeInAnimation(
                                        child: RestaurantItem(
                                          shop: state.shops[index],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          )
                        : _resultEmpty(),
                  ],
                ),
          22.verticalSpace,
          state.isProductLoading
              ? const SearchProductShimmer()
              : Column(
                  children: [
                    TitleAndIcon(
                        title: AppHelpers.getTranslation(TrKeys.products),
                        rightTitle:
                            "${AppHelpers.getTranslation(TrKeys.found)} ${state.products.length} ${AppHelpers.getTranslation(TrKeys.results)}"),
                    20.verticalSpace,
                    state.products.isNotEmpty
                        ? AnimationLimiter(
                            child: ListView.builder(
                                padding: EdgeInsets.only(
                                    right: 16.w,
                                    left: 16.w,
                                    bottom:
                                        MediaQuery.paddingOf(context).bottom),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.products.length,
                                itemBuilder: (context, index) {
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 375),
                                    child: SlideAnimation(
                                      horizontalOffset: 50.0,
                                      child: FadeInAnimation(
                                        child: ProductItem(
                                            product: state.products[index]),
                                      ),
                                    ),
                                  );
                                }),
                          )
                        : _resultEmpty()
                  ],
                ),
        ],
      ),
    );
  }

  Widget _categoryAndSearchHistory(SearchState state, BuildContext context) {
    return ListView(
      shrinkWrap: true,
      controller: _controller,
      padding: EdgeInsets.only(bottom: 100.h),
      children: [
        16.verticalSpace,
        ref.watch(homeProvider).isCategoryLoading
            ? const SearchCategoryShimmer()
            : ref.watch(homeProvider).categories.isNotEmpty
                ? Column(
                    children: [
                      SizedBox(
                        height: 36.h,
                        child: SmartRefresher(
                          scrollDirection: Axis.horizontal,
                          enablePullDown: false,
                          enablePullUp: true,
                          controller: _categoryControllerTwo,
                          onLoading: () async {
                            await ref
                                .read(homeProvider.notifier)
                                .fetchCategoriesPage(
                                    context, _categoryControllerTwo);
                          },
                          child: AnimationLimiter(
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    ref.watch(homeProvider).categories.length,
                                padding: EdgeInsets.only(left: 16.w),
                                itemBuilder: (context, index) {
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 375),
                                    child: SlideAnimation(
                                      verticalOffset: 50.0,
                                      child: FadeInAnimation(
                                        child: TabBarItem(
                                          isShopTabBar: true,
                                          title: ref
                                                  .watch(homeProvider)
                                                  .categories[index]
                                                  .translation
                                                  ?.title ??
                                              "",
                                          index: index,
                                          currentIndex:
                                              state.selectIndexCategory,
                                          onTap: () => event.setSelectCategory(
                                              index, context,
                                              categoryId: state
                                                          .selectIndexCategory >=
                                                      0
                                                  ? ref
                                                      .watch(homeProvider)
                                                      .categories[state
                                                          .selectIndexCategory]
                                                      .id
                                                  : null),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ),
                      30.verticalSpace,
                    ],
                  )
                : const SizedBox.shrink(),
        TitleAndIcon(
          title: AppHelpers.getTranslation(TrKeys.recently),
          rightTitle: AppHelpers.getTranslation(TrKeys.clear),
          rightTitleColor: AppStyle.red,
          onRightTap: () {
            event.clearAllHistory();
          },
        ),
        30.verticalSpace,
        AnimationLimiter(
          child: ListView.builder(
              padding: EdgeInsets.only(
                  right: 16.w,
                  left: 16.w,
                  bottom: MediaQuery.paddingOf(context).bottom),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.searchHistory.length,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 375),
                  child: SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(
                      child: SearchResultText(
                        title: state.searchHistory[index],
                        canceled: () {
                          event.clearHistory(index);
                        },
                        onTap: () {
                          _searchController.text = state.searchHistory[index];
                          event
                            ..changeSearch(state.searchHistory[index])
                            ..searchShop(context, state.searchHistory[index],
                                categoryId: state.selectIndexCategory >= 0
                                    ? ref
                                        .watch(homeProvider)
                                        .categories[state.selectIndexCategory]
                                        .id
                                    : null)
                            ..searchProduct(
                                context, state.searchHistory[index]);
                        },
                      ),
                    ),
                  ),
                );
              }),
        )
      ],
    );
  }
}
