import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:riverpodtemp/application/home/home_provider.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/app_bars/common_app_bar.dart';
import 'package:riverpodtemp/presentation/components/buttons/pop_button.dart';
import 'package:riverpodtemp/presentation/components/loading.dart';
import 'package:riverpodtemp/presentation/pages/home_one/widget/market_one_item.dart';
import 'package:riverpodtemp/presentation/pages/home_three/widgets/market_three_item.dart';
import 'package:riverpodtemp/presentation/pages/home_two/widget/market_two_item.dart';

import '../../../../infrastructure/models/data/shop_data.dart';
import '../../../../infrastructure/services/local_storage.dart';
import '../../../components/market_item.dart';
import '../../../theme/app_style.dart';

@RoutePage()
class ShopsBannerPage extends ConsumerStatefulWidget {
  final int bannerId;
  final bool isAds;
  final String title;

  const ShopsBannerPage({
    super.key,
    required this.bannerId,
    required this.title,
    this.isAds = false,
  });

  @override
  ConsumerState<ShopsBannerPage> createState() => _ShopsBannerPageState();
}

class _ShopsBannerPageState extends ConsumerState<ShopsBannerPage> {
  final bool isLtr = LocalStorage.getLangLtr();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.isAds
          ? ref
              .read(homeProvider.notifier)
              .fetchAdsById(context, widget.bannerId)
          : ref
              .read(homeProvider.notifier)
              .fetchBannerById(context, widget.bannerId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeProvider);
    return Directionality(
      textDirection: isLtr ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        body: Column(
          children: [
            CommonAppBar(
              child: Text(
                widget.title,
                style: AppStyle.interNoSemi(size: 18.sp),
                maxLines: 2,
              ),
            ),
            state.isBannerLoading
                ? Padding(
                    padding: EdgeInsets.only(top: 200.h),
                    child: const Loading(),
                  )
                : Expanded(
                    child: (state.banner?.shops?.isNotEmpty ?? false)
                        ? ListView.builder(
                            shrinkWrap: true,
                            
                            itemCount: state.banner?.shops?.length,
                            padding: AppHelpers.getType() == 2
                                ? EdgeInsets.all(16.r)
                                : EdgeInsets.symmetric(vertical: 24.h),
                            itemBuilder: (context, index) =>
                                AppHelpers.getType() == 0
                                    ? MarketItem(
                                        shop: state.banner?.shops?[index] ??
                                            ShopData(),
                                        isSimpleShop: true,
                                      )
                                    : AppHelpers.getType() == 1
                                        ? MarketOneItem(
                                            shop: state.banner?.shops?[index] ??
                                                ShopData(),
                                            isSimpleShop: true,
                                          )
                                        : AppHelpers.getType() == 2
                                            ? MarketTwoItem(
                                                shop: state.banner
                                                        ?.shops?[index] ??
                                                    ShopData(),
                                                isSimpleShop: true,
                                              )
                                            : MarketThreeItem(
                                                shop: state.banner
                                                        ?.shops?[index] ??
                                                    ShopData(),
                                                isSimpleShop: true,
                                              ),
                          )
                        : Column(
                            children: [
                              16.verticalSpace,
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 3,
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
      ),
    );
  }
}
