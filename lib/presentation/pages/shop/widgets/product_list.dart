import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:riverpodtemp/infrastructure/models/models.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/title_icon.dart';

import 'package:riverpodtemp/presentation/theme/app_style.dart';

import '../../../../application/shop/shop_provider.dart';
import '../../product/product_page.dart';
import 'shimmer_product_list.dart';
import 'shop_product_item.dart';

class ProductsList extends ConsumerStatefulWidget {
  final CategoryData? categoryData;
  final String shopId;
  final int? index;
  final String? cartId;

  const ProductsList({
    super.key,
    this.categoryData,
    this.index,
    this.cartId,
    required this.shopId,
  });

  @override
  ConsumerState<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends ConsumerState<ProductsList> {
  late RefreshController refreshController = RefreshController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.categoryData == null) {
        widget.index == 0
            ? ref
            .read(shopProvider.notifier)
            .fetchProducts(context, widget.shopId)
            : ref
            .read(shopProvider.notifier)
            .fetchProductsPopular(context, widget.shopId);
      }
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ProductsList oldWidget) {
    if (widget.categoryData == null){
      if (oldWidget.index != widget.index) {
        Future.delayed(const Duration(milliseconds: 500), () {
          ref
              .read(shopProvider.notifier)
              .fetchProductsPopular(context, widget.shopId);
        });
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(shopProvider);
    return SmartRefresher(
      controller: refreshController,
      enablePullUp: state.products.isNotEmpty,
      enablePullDown: false,
      onLoading: () {
        if (widget.categoryData == null) {
          widget.index == 0
              ? ref.read(shopProvider.notifier).fetchProductsPage(
              context, widget.shopId, controller: refreshController)
              : ref.read(shopProvider.notifier).fetchProductsPopularPage(
              context, widget.shopId, controller: refreshController);
          return;
        }

        ref.read(shopProvider.notifier).fetchProductsByCategoryPage(
            context, widget.shopId, widget.categoryData?.id ?? 0,
            controller: refreshController);

      },
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            TitleAndIcon(
                title: widget.index == null
                    ? widget.categoryData?.translation?.title ?? ""
                    : widget.index == 0
                    ? AppHelpers.getTranslation(TrKeys.all)
                    : AppHelpers.getTranslation(TrKeys.popular)),
            12.verticalSpace,
            if (widget.index != null)
              state.isProductLoading
                  ? const ShimmerProductList()
                  : state.products.isEmpty
                  ? _resultEmpty()
                  : AnimationLimiter(
                child: GridView.builder(
                  padding: EdgeInsets.only(
                      right: 12.w, left: 12.w, bottom: 96.h),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.66.r,
                      crossAxisCount: 2,
                      mainAxisExtent: 250.r),
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredGrid(
                      columnCount: state.products.length,
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: ScaleAnimation(
                        scale: 0.5,
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: () {
                              AppHelpers
                                  .showCustomModalBottomDragSheet(
                                context: context,
                                modal: (c) => ProductScreen(
                                  cartId: widget.cartId,
                                  data: state.products[index],
                                  controller: c,
                                ),
                                isDarkMode: false,
                                isDrag: true,
                                radius: 16,
                              );
                            },
                            child: ShopProductItem(
                              product: state.products[index],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            if (widget.index == null)
              state.isProductCategoryLoading
                  ? const ShimmerProductList()
                  : state.categoryProducts.isEmpty
                  ? _resultEmpty()
                  : AnimationLimiter(
                child: GridView.builder(
                  padding: EdgeInsets.only(
                      right: 12.w, left: 12.w, bottom: 96.h),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.66.r,
                      crossAxisCount: 2,
                      mainAxisExtent: 250.r),
                  itemCount: state.categoryProducts.length,
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredGrid(
                      columnCount: state.categoryProducts.length,
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: ScaleAnimation(
                        scale: 0.5,
                        child: FadeInAnimation(
                          child: GestureDetector(
                            onTap: () {
                              AppHelpers
                                  .showCustomModalBottomDragSheet(
                                context: context,
                                modal: (c) => ProductScreen(
                                  cartId: widget.cartId,
                                  data: state.categoryProducts[index],
                                  controller: c,
                                ),
                                isDarkMode: false,
                                isDrag: true,
                                radius: 16,
                              );
                            },
                            child: ShopProductItem(
                              product: state.categoryProducts[index],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _resultEmpty() {
    return Column(
      children: [
        Lottie.asset("assets/lottie/empty-box.json"),
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
