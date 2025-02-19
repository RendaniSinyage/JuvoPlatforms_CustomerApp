import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';
import 'package:foodyman/presentation/components/title_icon.dart';

import 'package:foodyman/presentation/theme/app_style.dart';

import 'package:foodyman/application/shop/shop_provider.dart';
import 'package:foodyman/application/shop/shop_state.dart';
import 'package:foodyman/infrastructure/models/response/all_products_response.dart';
import '../../product/product_page.dart';
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

  List<Product> category(int id) {
    return where((element) {
      return element.categoryId == id;
    }).toList();
  }
}

class ProductsList extends ConsumerStatefulWidget {
  final All? all;
  final int? shopId;
  final String? cartId;

  const ProductsList({
    super.key,
    this.cartId,
    this.all,
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
      child: (widget.all?.products?.search(state).isNotEmpty ?? false) &&
              widget.all?.translation?.title ==
                  AppHelpers.getTranslation(TrKeys.popular) && state.searchText.isNotEmpty
          ? const SizedBox.shrink()
          : Column(
              children: [
                if ((widget.all?.products?.search(state).isNotEmpty ?? false) &&
                    (widget.all?.products?.isNotEmpty ?? false))
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      12.verticalSpace,
                      TitleAndIcon(title: widget.all?.translation?.title ?? ""),
                    ],
                  ),
                if ((widget.all?.products?.search(state).isNotEmpty ?? false) &&
                    (widget.all?.products?.isNotEmpty ?? false))
                  12.verticalSpace,
               ((widget.all?.products?.search(state).isNotEmpty ??
                                false) &&
                            (widget.all?.products?.isNotEmpty ?? false))
                        ? AnimationLimiter(
                            child: GridView.builder(
                              padding: EdgeInsets.only(
                                  right: 12.w, left: 12.w, bottom: 12.h),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 0.66.r,
                                crossAxisCount: 2,
                                mainAxisExtent: 250.r,
                              ),
                              itemCount:
                                  widget.all?.products?.search(state).length,
                              itemBuilder: (context, index) {
                                return AnimationConfiguration.staggeredGrid(
                                  columnCount: widget.all?.products
                                          ?.search(state)
                                          .length ??
                                      0,
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
                                              data: ProductData.fromJson(widget
                                                  .all?.products
                                                  ?.search(state)[index]
                                                  .toJson()),
                                              controller: c,
                                            ),
                                            isDarkMode: false,
                                            isDrag: true,
                                            radius: 16,
                                          );
                                        },
                                        child: ShopProductItem(
                                          product: (widget.all?.products
                                                      ?.search(state) ??
                                                  [])
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

  Widget resultEmpty() {
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
