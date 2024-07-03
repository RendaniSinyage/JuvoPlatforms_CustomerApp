import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:riverpodtemp/infrastructure/models/models.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';
import 'package:riverpodtemp/infrastructure/services/tr_keys.dart';
import 'package:riverpodtemp/presentation/components/title_icon.dart';

import '../../../../application/shop/shop_provider.dart';
import '../../../../application/shop/shop_state.dart';
import '../../../../infrastructure/models/response/all_products_response.dart';
import '../../product/product_page.dart';
import 'shimmer_product_list.dart';
import 'shop_product_item.dart';

extension MyExtension1 on Iterable<Product> {
  List<Product> search(ShopState state) {
    return where((element) {
      if (state.searchText.isNotEmpty) {
        bool isOk = false;
        int level = 0;
        state.searchText.split(' ').forEach(
          (e) {
            isOk = (element.translation?.title
                        ?.toLowerCase()
                        .contains(e.toLowerCase()) ??
                    false) ||
                (element.translation?.description
                        ?.toLowerCase()
                        .contains(e.toLowerCase()) ??
                    false);
            if (isOk) {
              level++;
            }
          },
        );
        return level == state.searchText.split(' ').length;
      }
      return true;
    }).toList();
  }
}

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
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(shopProvider);
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: (widget.index == null && state.searchText.isEmpty)
          ? Column(
              children: [
                if (state.popularProducts.isNotEmpty)
                  TitleAndIcon(
                      title: AppHelpers.getTranslation(TrKeys.popular)),
                if (state.popularProducts.isNotEmpty) 12.verticalSpace,
                state.isProductLoading
                    ? const ShimmerProductList()
                    : state.popularProducts.isEmpty
                        ? const SizedBox.shrink()
                        // _resultEmpty()
                        : AnimationLimiter(
                            child: GridView.builder(
                              padding: EdgeInsets.only(
                                  right: 12.w, left: 12.w, bottom: 30.h),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 0.66.r,
                                      crossAxisCount: 2,
                                      mainAxisExtent: 250.r),
                              itemCount: state.popularProducts.length,
                              itemBuilder: (context, index) {
                                return AnimationConfiguration.staggeredGrid(
                                  columnCount: state.popularProducts.length,
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
                                              data: ProductData.fromJson(state
                                                  .popularProducts[index]
                                                  .toJson()),
                                              controller: c,
                                            ),
                                            isDarkMode: false,
                                            isDrag: true,
                                            radius: 16,
                                          );
                                        },
                                        child: ShopProductItem(
                                          product: state.popularProducts[index],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
              ],
            )
          : Column(
              children: [
                if (((state.products.where((element) =>
                            element.categoryId == widget.categoryData?.id))
                        .isNotEmpty) &&
                    state.products
                        .where((element) =>
                            element.categoryId == widget.categoryData?.id)
                        .search(state)
                        .isNotEmpty)
                  TitleAndIcon(
                      title: widget.categoryData?.translation?.title ?? ""),
                if (((state.products.where((element) =>
                            element.categoryId == widget.categoryData?.id))
                        .isNotEmpty) &&
                    state.products
                        .where((element) =>
                            element.categoryId == widget.categoryData?.id)
                        .search(state)
                        .isNotEmpty)
                  12.verticalSpace,
                state.isProductLoading
                    ? const ShimmerProductList()
                    : ((state.products.where((element) =>
                                element.categoryId ==
                                widget.categoryData?.id)).isNotEmpty) &&
                            state.products
                                .where((element) =>
                                    element.categoryId ==
                                    widget.categoryData?.id)
                                .search(state)
                                .isNotEmpty
                        // _resultEmpty()

                        ? AnimationLimiter(
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
                              itemCount: state.products
                                  .where((element) =>
                                      element.categoryId ==
                                      widget.categoryData?.id)
                                  .search(state)
                                  .length,
                              itemBuilder: (context, index) {
                                return AnimationConfiguration.staggeredGrid(
                                  columnCount: state.products
                                      .where((element) =>
                                          element.categoryId ==
                                          widget.categoryData?.id)
                                      .search(state)
                                      .length,
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
                                              data: ProductData.fromJson(state
                                                  .products
                                                  .where((element) =>
                                                      element.categoryId ==
                                                      widget.categoryData?.id)
                                                  .search(state)[index]
                                                  .toJson()),
                                              controller: c,
                                            ),
                                            isDarkMode: false,
                                            isDrag: true,
                                            radius: 16,
                                          );
                                        },
                                        child: ShopProductItem(
                                          product: state.products
                                              .where((element) =>
                                                  element.categoryId ==
                                                  widget.categoryData?.id)
                                              .search(state)
                                              .toList()[index],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : const SizedBox.shrink(),
              ],
            ),
    );
  }

  // Widget _resultEmpty() {
  //   return Column(
  //     children: [
  //       Lottie.asset("assets/lottie/empty-box.json"),
  //       Text(
  //         AppHelpers.getTranslation(TrKeys.nothingFound),
  //         style: AppStyle.interSemi(size: 18.sp),
  //       ),
  //       Padding(
  //         padding: EdgeInsets.symmetric(horizontal: 32.w),
  //         child: Text(
  //           AppHelpers.getTranslation(TrKeys.trySearchingAgain),
  //           style: AppStyle.interRegular(size: 14.sp),
  //           textAlign: TextAlign.center,
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
