import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/pages/home_two/widget/market_two_item.dart';

import '../../../../application/home/home_notifier.dart';
import '../../../../application/home/home_provider.dart';
import '../../../../infrastructure/services/app_helpers.dart';
import '../../../components/app_bars/common_app_bar.dart';
import '../../../components/buttons/pop_button.dart';
import '../../../components/market_item.dart';
import '../../../theme/app_style.dart';
import 'recommended_item.dart';


@RoutePage()
class RecommendedPage extends ConsumerStatefulWidget {
  final bool isNewsOfPage;
  final bool isShop;

  const RecommendedPage({
    super.key,
    this.isNewsOfPage = false,
    this.isShop = false,
  });

  @override
  ConsumerState<RecommendedPage> createState() => _RecommendedPageState();
}

class _RecommendedPageState extends ConsumerState<RecommendedPage> {
  late HomeNotifier event;
  final RefreshController _recommendedController = RefreshController();

  @override
  void didChangeDependencies() {
    event = ref.read(homeProvider.notifier);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeProvider);
    return Scaffold(
      body: Column(
        children: [
          CommonAppBar(
            child: Text(
              AppHelpers.getTranslation(widget.isShop
                  ? TrKeys.shops
                  : widget.isNewsOfPage
                      ? TrKeys.newsOfWeek
                      : TrKeys.recommended),
              style: AppStyle.interNoSemi(size: 18.sp),
            ),
          ),
          widget.isShop
              ? Expanded(
                  child: state.shops.isNotEmpty
                      ? SmartRefresher(
                          controller: _recommendedController,
                          enablePullDown: true,
                          enablePullUp: true,
                          onLoading: () async {
                            await event.fetchShopPage(
                                context, _recommendedController);
                          },
                          onRefresh: () async {
                            await event.fetchShopPage(
                                context, _recommendedController,
                                isRefresh: true);
                          },
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.shops.length,
                            padding: EdgeInsets.symmetric(vertical: 24.h),
                            itemBuilder: (context, index) => MarketItem(
                              isSimpleShop: true,
                              shop: state.shops[index],
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height / 2,
                              child: SvgPicture.asset(
                                "assets/svgs/empty.svg",
                              ),
                            ),
                            16.verticalSpace,
                            Text(AppHelpers.getTranslation(TrKeys.noRestaurant))
                          ],
                        ))
              : widget.isNewsOfPage
              ? Expanded(
              child: state.restaurant.isNotEmpty
                  ? SmartRefresher(
                controller: _recommendedController,
                enablePullDown: true,
                enablePullUp: true,
                onLoading: () async {
                  await event.fetchRestaurantPage(
                      context, _recommendedController);
                },
                onRefresh: () async {
                  await event.fetchRestaurantPage(
                    context,
                    _recommendedController,
                    isRefresh: true,
                  );
                },
                child: AnimationLimiter(
                  child: GridView.builder(
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8.r,
                      crossAxisSpacing: 8.r,
                      childAspectRatio: 0.70,
                    ),
                    padding:
                    REdgeInsets.symmetric(horizontal: 16),
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
                              child: MarketTwoItem(
                                shop: state.restaurant[index],
                                isSimpleShop: true,
                              ),
                            ),
                          ),
                        ),
                  ),
                ),
              )
                  : Column(
                children: [
                  SizedBox(
                    height:
                    MediaQuery.of(context).size.height / 2,
                    child: SvgPicture.asset(
                      "assets/svgs/empty.svg",
                    ),
                  ),
                  16.verticalSpace,
                  Text(AppHelpers.getTranslation(
                      TrKeys.noRestaurant))
                ],
              ))
                  : Expanded(
                      child: state.shopsRecommend.isNotEmpty
                          ? SmartRefresher(
                              controller: _recommendedController,
                              enablePullDown: true,
                              enablePullUp: false,
                              
                              onLoading: () async {
                                // await event.fetchShopPageRecommend(
                                //     context, _recommendedController);
                              },
                              onRefresh: () async {
                                await event.fetchShopPageRecommend(
                                    context, _recommendedController,
                                    isRefresh: true);
                              },
                              child: GridView.builder(
                                shrinkWrap: true,
                                
                                itemCount: state.shopsRecommend.length,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 24.h),
                                itemBuilder: (context, index) =>
                                    RecommendedItem(
                                 shop:  state.shopsRecommend[index],
                                      itemCount: state.shopsRecommend.length,
                                    ),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio: 0.66.r,
                                        crossAxisCount: 2,
                                        mainAxisExtent: 190.h,
                                        mainAxisSpacing: 10.h),
                              ),
                            )
                          : Column(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.sizeOf(context).height / 2,
                                  child: SvgPicture.asset(
                                    "assets/svgs/empty.svg",
                                  ),
                                ),
                                16.verticalSpace,
                                Text(AppHelpers.getTranslation(
                                    TrKeys.noRestaurant))
                              ],
                            ))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(left: 16.w),
        child: const PopButton(),
      ),
    );
  }
}
