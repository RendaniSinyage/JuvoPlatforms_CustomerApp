import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/presentation/theme/app_style.dart';
import 'package:remixicon/remixicon.dart';
import 'package:foodyman/application/shop_order/shop_order_provider.dart';
import 'package:foodyman/application/product/product_provider.dart';

import 'product_utils.dart';

class ProductUIComponents {
  /// Build quantity control widget for product in cart
  static Widget buildQuantityControl(
      BuildContext context,
      WidgetRef ref,
      dynamic product, // Can be ProductData or Product depending on use
      int cartQuantity,
      {bool canAddDirectly = true}) {

    final shopOrderNotifier = ref.read(shopOrderProvider.notifier);
    final productNotifier = ref.read(productProvider.notifier);

    // Get the stock ID - works for both ProductData and Product
    final stockId = product.stock?.id;

    // Only show quantity controls when product is in cart
    if (cartQuantity > 0) {
      return Container(
        decoration: BoxDecoration(
          color: AppStyle.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: AppStyle.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Decrease button
            InkWell(
              onTap: () {
                try {
                  final shopOrderState = ref.read(shopOrderProvider);

                  if (shopOrderState.cart != null && cartQuantity > 0) {
                    for (var userCart in shopOrderState.cart!.userCarts ?? []) {
                      for (int i = 0; i < (userCart.cartDetails?.length ?? 0); i++) {
                        final cartDetail = userCart.cartDetails?[i];
                        if (cartDetail?.stock?.id == stockId) {
                          shopOrderNotifier.removeCount(context, i);
                          return;
                        }
                      }
                    }
                  }
                } catch (e) {
                  debugPrint("Error decreasing quantity: $e");
                }
              },
              child: Container(
                padding: EdgeInsets.all(8.r),
                decoration: const BoxDecoration(
                  color: AppStyle.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.remove,
                  size: 20.r,
                  color: AppStyle.black,
                ),
              ),
            ),

            // Quantity display
            Container(
              margin: EdgeInsets.symmetric(horizontal: 8.r),
              child: Text(
                cartQuantity.toString(),
                style: AppStyle.interNoSemi(
                  size: 16,
                  color: AppStyle.black,
                ),
              ),
            ),

            // Increase button
            InkWell(
              onTap: () {
                try {
                  final shopOrderState = ref.read(shopOrderProvider);

                  if (shopOrderState.cart != null) {
                    for (var userCart in shopOrderState.cart!.userCarts ?? []) {
                      for (int i = 0; i < (userCart.cartDetails?.length ?? 0); i++) {
                        final cartDetail = userCart.cartDetails?[i];
                        if (cartDetail?.stock?.id == stockId) {
                          shopOrderNotifier.addCount(context, i);
                          return;
                        }
                      }
                    }
                  }
                } catch (e) {
                  debugPrint("Error increasing quantity: $e");
                }
              },
              child: Container(
                padding: EdgeInsets.all(8.r),
                decoration: const BoxDecoration(
                  color: AppStyle.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add,
                  size: 20.r,
                  color: AppStyle.black,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  /// Build cold/frozen badge with snowflake icon and text
  static Widget buildColdFrozenBadge(String text, Color backgroundColor, Color textColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.r, vertical: 4.r),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Remix.snowflake_fill,
            color: textColor,
            size: 12.r,
          ),
          SizedBox(width: 2.r),
          Text(
            text,
            style: AppStyle.interNoSemi(
              size: 10,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  /// Build discount badge ("SAVE X%")
  static Widget buildDiscountBadge(double originalPrice, double discountedPrice) {
    if (discountedPrice >= originalPrice || originalPrice <= 0) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 22.h,
      color: AppStyle.red,
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Center(
        child: Text(
          ProductUtils.calculateSavingsText(originalPrice, discountedPrice),
          style: AppStyle.interNoSemi(
            size: 12,
            color: AppStyle.white,
          ),
        ),
      ),
    );
  }

  /// Build size badge (e.g. "2L", "500ml")
  static Widget buildSizeBadge(String? size) {
    if (size == null || size.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.r, vertical: 2.r),
      decoration: BoxDecoration(
        color: AppStyle.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        size,
        style: AppStyle.interRegular(
          size: 10,
          color: AppStyle.black,
        ),
      ),
    );
  }

  /// Calculate per unit price label (e.g. "R25.00/liter")
  static String? calculatePerUnitPrice(
      double price,
      SizeInfo? sizeInfo,
      {bool shouldShow = true}) {

    if (!shouldShow || sizeInfo?.size == null) {
      return null;
    }

    final String? numberStr = sizeInfo!.size!.extractNumber();
    if (numberStr == null) {
      return null;
    }

    final double? unitSize = double.tryParse(numberStr);
    if (unitSize == null || unitSize <= 0) {
      return null;
    }

    double perUnitPrice = price / unitSize;

    // Only show if price per unit is >= 1
    if (perUnitPrice < 1) {
      return null;
    }

    String unitLabel = '';
    if (sizeInfo.size!.toLowerCase().contains('l')) {
      unitLabel = 'litre';
    } else if (sizeInfo.size!.toLowerCase().contains('kg')) {
      unitLabel = 'kg';
    } else if (sizeInfo.size!.toLowerCase().contains('g')) {
      unitLabel = 'g';
    } else if (sizeInfo.size!.toLowerCase().contains('ml')) {
      // Adjust for milliliters
      if (unitSize < 1) {
        perUnitPrice = price * (1000 / unitSize);
        unitLabel = 'litre';
      } else {
        unitLabel = 'ml';
      }
    }

    if (perUnitPrice >= 1) {
      return '${AppHelpers.numberFormat(number: perUnitPrice)}/$unitLabel';
    }

    return null;
  }
}