import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/presentation/pages/home/widgets/banner_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:foodyman/application/home/home_provider.dart';
import 'package:foodyman/application/like/like_notifier.dart';
import 'package:foodyman/application/like/like_provider.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:foodyman/presentation/components/app_bars/common_app_bar.dart';
import 'package:foodyman/presentation/components/buttons/pop_button.dart';
import 'package:foodyman/presentation/components/market_item.dart';
import 'package:foodyman/presentation/pages/home/shimmer/banner_shimmer.dart';
import 'package:foodyman/presentation/theme/theme.dart';
import 'package:foodyman/application/main/main_provider.dart';
import '../home/home_one/widget/market_one_item.dart';
import '../home/home_three/widgets/market_three_item.dart';
import '../home/home_two/widget/market_two_item.dart';
import '../home/shimmer/all_shop_shimmer.dart';


@RoutePage()
class LikePage extends ConsumerStatefulWidget {
  final bool isBackButton;

  const LikePage({
    super.key,
    this.isBackButton = true,
  });

  @override
  ConsumerState<LikePage> createState() => _LikePageState();
}

class _LikePageState extends ConsumerState<LikePage> {
  late LikeNotifier event;
  final RefreshController _bannerController = RefreshController();
  final RefreshController _likeShopController = RefreshController();
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(likeProvider.notifier).fetchLikeShop(context);
    });
    _controller.addListener(listen);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    event = ref.read(likeProvider.notifier);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bannerController.dispose();
    _likeShopController.dispose();
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
    final state = ref.watch(likeProvider);
    return Scaffold(
      backgroundColor: AppStyle.bgGrey,
      body: Column(
        children: [
          CommonAppBar(
            child: Text(
              AppHelpers.getTranslation(TrKeys.likeRestaurants),
              style: AppStyle.interNoSemi(
                size: 18,
                color: AppStyle.black,
              ),
            ),
          ),
          Expanded(
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: false,
              physics: const BouncingScrollPhysics(),
              controller: _likeShopController,
              scrollController: _controller,
              onLoading: () {},
              onRefresh: () {
                event.fetchLikeShop(context);
                ref.read(homeProvider.notifier).fetchBannerPage(
                    context, _likeShopController,
                    isRefresh: true);
              },
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    top: 24.h, bottom: MediaQuery.paddingOf(context).bottom),
                child: Column(
                  children: [
                    ref.watch(homeProvider).isBannerLoading
                        ? const BannerShimmer()
                        : SizedBox(
                            height: 200.h,
                            child: SmartRefresher(
                              scrollDirection: Axis.horizontal,
                              enablePullDown: false,
                              enablePullUp: true,
                              controller: _bannerController,
                              onLoading: () async {
                                await ref
                                    .read(homeProvider.notifier)
                                    .fetchBannerPage(
                                        context, _bannerController);
                              },
                              child: ListView.builder(
                                shrinkWrap: false,
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    ref.watch(homeProvider).banners.length,
                                padding: EdgeInsets.only(left: 16.w),
                                itemBuilder: (context, index) => BannerItem(
                                  banner:
                                      ref.watch(homeProvider).banners[index],
                                ),
                              ),
                            ),
                          ),
                    24.verticalSpace,
                    state.isShopLoading
                        ? const AllShopShimmer(
                            isTitle: false,
                          )
                        : state.shops.isEmpty
                            ? _resultEmpty()
                            : ListView.builder(
                                padding: AppHelpers.getType() == 2
                                    ? EdgeInsets.symmetric(
                                        horizontal: 16.r,
                                      )
                                    : EdgeInsets.only(top: 6.h),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: state.shops.length,
                                itemBuilder: (context, index) =>
                                    AppHelpers.getType() == 0
                                        ? MarketItem(
                                            shop: state.shops[index],
                                            isSimpleShop: true,
                                          )
                                        : AppHelpers.getType() == 1
                                            ? MarketOneItem(
                                                shop: state.shops[index],
                                                isSimpleShop: true,
                                              )
                                            : AppHelpers.getType() == 2
                                                ? MarketTwoItem(
                                                    shop: state.shops[index],
                                                    isSimpleShop: true,
                                                  )
                                                : MarketThreeItem(
                                                    shop: state.shops[index],
                                                    isSimpleShop: true,
                                                  ),
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
    );
  }

  Widget _resultEmpty() {
    return Column(
      children: [
        32.verticalSpace,
        Image.asset("assets/images/notFound.png"),
        Text(
          AppHelpers.getTranslation(TrKeys.nothingFound),
          style: AppStyle.interSemi(size: 18.sp),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Text(
            AppHelpers.getTranslation(TrKeys.trySearchingAgain),
            style: AppStyle.interRegular(size: 14.sp),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
