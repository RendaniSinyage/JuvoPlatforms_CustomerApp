import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
//import 'package:foodyman/application/home/home_provider.dart';
import 'package:foodyman/application/like/like_notifier.dart';
import 'package:foodyman/application/like/like_provider.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:foodyman/presentation/components/app_bars/common_app_bar.dart';
import 'package:foodyman/presentation/components/buttons/pop_button.dart';
import 'package:foodyman/presentation/components/market_item.dart';
import 'package:foodyman/presentation/pages/home/shimmer/all_shop_shimmer.dart';
import '../home/home_four/widgets/market_one_item.dart';
import '../home/home_four/widgets/market_three_item.dart';
import '../home/home_four/widgets/market_two_item.dart';
import 'package:foodyman/presentation/theme/theme.dart';
import 'package:foodyman/presentation/components/badges/empty_badge.dart';

import '../../../application/main/main_provider.dart';

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
              },
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    top: 24.h, bottom: MediaQuery.paddingOf(context).bottom),
                child: Column(
                  children: [
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
  return EmptyBadge();
}
}
