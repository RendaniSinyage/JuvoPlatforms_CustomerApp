import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:foodyman/application/shop_order/shop_order_provider.dart';
import 'package:foodyman/application/home/home_provider.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/presentation/pages/product/product_page.dart';

import '../../../../../utils/products/brand_utils.dart';
import '../../../../../utils/products/product_card.dart';
import '../../../../../utils/products/product_utils.dart';

class DiscountedProductsSection extends ConsumerWidget {
  final List<ProductData> products;
  final String? cartId;

  const DiscountedProductsSection({
    super.key,
    required this.products,
    this.cartId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shopOrderState = ref.watch(shopOrderProvider);
    final homeState = ref.watch(homeProvider);

    // Filter for products with valid discounts
    final validDiscountProducts = products.where((product) {
      return ProductUtils.hasValidActiveDiscount(product);
    }).toList();

    // Debug information
    debugPrint("Building DiscountedProductsSection");
    debugPrint("Products count: ${products.length}");
    debugPrint("Valid discount products: ${validDiscountProducts.length}");

    // Filter for products from shops that are available
    final filteredProducts = validDiscountProducts.where((product) {
      final shopName = BrandUtils.getShopNameFromId(product.shopId, ref);
      return shopName != null;
    }).toList();

    return SizedBox(
      height: 200.h,
      child: AnimationLimiter(
        child: ListView.builder(
          padding: EdgeInsets.only(left: 16.w, right: 16.w),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            final product = filteredProducts[index];
            final String imageUrl = product.img ?? "";
            final bool isTransparentFormat = ProductUtils.hasTransparentBackground(imageUrl);

            // Get cart quantity
            int cartQuantity = 0;
            if (shopOrderState.cart != null) {
              for (var userCart in shopOrderState.cart!.userCarts ?? []) {
                if (userCart.cartDetails != null) {
                  for (var cartDetail in userCart.cartDetails!) {
                    if (cartDetail.stock?.id == product.stock?.id) {
                      final qtyInt = int.tryParse(cartDetail.quantity.toString()) ?? 0;
                      cartQuantity += qtyInt;
                    }
                  }
                }
              }
            }

            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  child: Container(
                    width: 150.w,
                    margin: EdgeInsets.only(right: 12.w),
                    child: GestureDetector(
                      onTap: () {
                        AppHelpers.showCustomModalBottomDragSheet(
                          context: context,
                          modal: (c) => ProductScreen(
                            cartId: cartId,
                            data: product,
                            controller: c,
                          ),
                          isDarkMode: false,
                          isDrag: true,
                          radius: 16,
                        );
                      },
                      child: ProductCard(
                        product: product,
                        hasTransparentBg: isTransparentFormat,
                        cartQuantity: cartQuantity,
                        cartId: cartId,
                        onTap: () {
                          AppHelpers.showCustomModalBottomDragSheet(
                            context: context,
                            modal: (c) => ProductScreen(
                              cartId: cartId,
                              data: product,
                              controller: c,
                            ),
                            isDarkMode: false,
                            isDrag: true,
                            radius: 16,
                          );
                        },
                        showShopName: true,
                        canAddDirectly: _hasSimpleExtrasAddons(product),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Function to check if a product has simple options,
  // now only used to pass to ProductCard for canAddDirectly property

  // Check if product has simple extras/addons (only one option per group)
  bool _hasSimpleExtrasAddons(ProductData product) {
    // Check if there are stocks
    if (product.stocks == null || product.stocks!.isEmpty) {
      return true; // No stocks means it's simple (default)
    }

    // If there are multiple stocks, it's complex
    if (product.stocks!.length > 1) {
      return false;
    }

    // Get the first stock
    final stock = product.stocks!.first;

    // Check for extras
    if (stock.extras != null && stock.extras!.isNotEmpty) {
      // If any extras exist, it's complex
      return false;
    }

    // Check for addons
    if (stock.addons != null && stock.addons!.isNotEmpty) {
      // If any addons exist, it's complex
      return false;
    }

    // No extras or addons means it's simple
    return true;
  }
}