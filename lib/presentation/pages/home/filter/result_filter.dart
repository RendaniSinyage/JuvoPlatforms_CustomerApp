import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:riverpodtemp/application/filter/filter_provider.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/presentation/components/app_bars/common_app_bar.dart';
import 'package:riverpodtemp/presentation/components/buttons/pop_button.dart';
import 'package:riverpodtemp/presentation/components/title_icon.dart';
import 'package:riverpodtemp/presentation/pages/home_one/widget/market_one_item.dart';
import 'package:riverpodtemp/presentation/pages/home_three/widgets/market_three_item.dart';

import '../../../../application/filter/filter_notifier.dart';
import '../../../../infrastructure/services/tr_keys.dart';
import '../../../components/market_item.dart';
import '../../../theme/app_style.dart';
import '../../home_two/widget/market_two_item.dart';
import '../shimmer/all_shop_shimmer.dart';


@RoutePage()
class ResultFilterPage extends ConsumerStatefulWidget {
  final int categoryId;

  const ResultFilterPage({
    super.key,
    required this.categoryId,
  });

  @override
  ConsumerState<ResultFilterPage> createState() => _ResultFilterState();
}

class _ResultFilterState extends ConsumerState<ResultFilterPage> {
  late FilterNotifier event;
  final RefreshController _shopController = RefreshController();
  final RefreshController _restaurantController = RefreshController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(filterProvider.notifier)
          .fetchRestaurant(context, widget.categoryId);
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    event = ref.read(filterProvider.notifier);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _shopController.dispose();
    _restaurantController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(filterProvider);
    return Scaffold(
      body: Column(
        children: [
          CommonAppBar(
            child: Text(
              AppHelpers.getTranslation(TrKeys.shops),
              style: AppStyle.interNoSemi(size: 18.sp),
            ),
          ),
          Expanded(
            child: SmartRefresher(
              controller: _restaurantController,
              enablePullUp: true,
              enablePullDown: true,
              onLoading: () {
                event.fetchRestaurantPage(
                    context, _restaurantController, widget.categoryId);
              },
              onRefresh: () {
                event.fetchRestaurantPage(
                    context, _restaurantController, widget.categoryId,
                    isRefresh: true);
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    24.verticalSpace,
                    state.isRestaurantLoading
                        ? const AllShopShimmer()
                        : Column(
                            children: [
                              TitleAndIcon(
                                title:
                                    AppHelpers.getTranslation(TrKeys.allShops),
                                rightTitle:
                                    "${AppHelpers.getTranslation(TrKeys.found)} ${state.restaurant.length.toString()} ${AppHelpers.getTranslation(TrKeys.results)}",
                              ),
                              ListView.builder(
                                padding: EdgeInsets.only(top: 6.h),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: state.restaurant.length,
                                itemBuilder: (context, index) =>
                                    AppHelpers.getType() == 0
                                        ? MarketItem(
                                            shop: state.restaurant[index],
                                            isSimpleShop: true,
                                          )
                                        : AppHelpers.getType() == 1
                                            ? MarketOneItem(
                                                shop: state.restaurant[index],
                                                isSimpleShop: true,
                                              )
                                            : AppHelpers.getType() == 2
                                                ? MarketTwoItem(
                                                    shop:
                                                        state.restaurant[index],
                                                    isSimpleShop: true,
                                                    isFilter: true,
                                                  )
                                                : MarketThreeItem(
                                                    shop:
                                                        state.restaurant[index],
                                                    isSimpleShop: true,
                                                  ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          )
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
