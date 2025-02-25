import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/presentation/components/custom_network_image.dart';
import 'package:foodyman/presentation/theme/app_style.dart';
import 'package:foodyman/presentation/pages/product/product_page.dart';
import 'package:foodyman/utils/products/product_utils.dart';
import 'package:remixicon/remixicon.dart';
import 'package:foodyman/application/shop_order/shop_order_provider.dart';

import 'brand_utils.dart';
import 'product_uI_components.dart';

// A generic product card that works with both ProductData and Product models
class ProductCard extends ConsumerWidget {
  final dynamic product; // Can be ProductData or Product
  final bool hasTransparentBg;
  final int cartQuantity;
  final String? cartId;
  final VoidCallback? onTap;
  final bool showShopName;
  final bool showPerUnitPrice;
  final bool canAddDirectly;

  const ProductCard({
    super.key,
    required this.product,
    required this.hasTransparentBg,
    required this.cartQuantity,
    this.cartId,
    this.onTap,
    this.showShopName = true,
    this.showPerUnitPrice = true,
    this.canAddDirectly = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Common properties regardless of product type
    final String? title = product.translation?.title;
    final String? description = product.translation?.description;
    final String imageUrl = product.img ?? "";
    final int? brandId = product.brandId;
    final int? shopId = product.shopId;

    // Get brand information
    final BrandData? brand = BrandUtils.getBrandFromProduct(brandId, ref);

    // Get shop info if needed
    String? shopName;
    if (showShopName) {
      shopName = BrandUtils.getShopNameFromId(shopId, ref);
    }

    // Clean the title
    final String cleanedTitle = ProductUtils.cleanTitleWithBrand(title, brand?.title);

    // Get price information
    final double originalPrice = product.stock?.price?.toDouble() ?? 0;
    final double discountedPrice = product.stock?.totalPrice?.toDouble() ?? 0;
    final bool hasDiscount = discountedPrice < originalPrice && originalPrice > 0;

    // Check if stock quantity is low
    final int stockQuantity = product.stock?.quantity ?? 0;
    final bool isLowStock = stockQuantity > 0 && stockQuantity <= 10;

    // Get size info
    final SizeInfo? sizeInfo = ProductUtils.extractSize(title);

    // Find packaging type in title or description
    final String? packagingType = ProductUtils.findPackagingType(title, description);

    // Check for cold/frozen and adult content
    final KeywordCheck keywords = ProductUtils.checkKeywords(title, description);

    // Calculate price per unit if needed
    String? pricePerUnit;
    if (showPerUnitPrice && !isLowStock) {
      // Don't show per unit price if title/description contains "drink" or "bottle"
      bool shouldShow = !ProductUtils.containsKeyword(title, "drink") &&
          !ProductUtils.containsKeyword(description, "drink") &&
          !ProductUtils.containsKeyword(title, "bottle") &&
          !ProductUtils.containsKeyword(description, "bottle");

      if (shouldShow) {
        pricePerUnit = ProductUIComponents.calculatePerUnitPrice(
            hasDiscount ? discountedPrice : originalPrice,
            sizeInfo,
            shouldShow: shouldShow);
      }
    }

    return Container(
      margin: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
          color: AppStyle.white, borderRadius: BorderRadius.circular(10.r)),
      child: Stack(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.all(10.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product image section
                  Expanded(
                    flex: 5,
                    child: Center(
                      child: CustomNetworkImage(
                        url: imageUrl,
                        height: 80.h,
                        width: double.infinity,
                        radius: 8.r,
                        fit: hasTransparentBg ? BoxFit.contain : BoxFit.cover,
                      ),
                    ),
                  ),

                  // Product details section
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Brand name if available
                        if (brand != null && brand.title != null && brand.title!.toLowerCase() != 'no brand')
                          BrandUtils.buildBrandSection(brand),

                        // Product title
                        Text(
                          cleanedTitle.isNotEmpty ? cleanedTitle : (title ?? ""),
                          style: AppStyle.interNoSemi(
                            size: 12,
                            color: AppStyle.black,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        // Shop name if requested and available
                        if (showShopName && shopName != null)
                          Text(
                            shopName,
                            style: AppStyle.interRegular(
                              size: 10,
                              color: AppStyle.textGrey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                        4.verticalSpace,

                        // Price section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Current price (discounted or regular)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppHelpers.numberFormat(number: discountedPrice),
                                  style: hasDiscount
                                      ? AppStyle.interNoSemi(
                                    size: 16,
                                    color: AppStyle.red,
                                  )
                                      : AppStyle.interNoSemi(
                                    size: 16,
                                    color: AppStyle.black,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                // Show "Only X left" if low stock
                                if (isLowStock)
                                  Text(
                                    "Only $stockQuantity left",
                                    style: AppStyle.interRegular(
                                      size: 12,
                                      color: AppStyle.red,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),

                            // Original price if discounted and per unit price below it
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (hasDiscount)
                                  Text(
                                    AppHelpers.numberFormat(number: originalPrice),
                                    style: AppStyle.interRegular(
                                      size: 12,
                                      color: AppStyle.textGrey,
                                      textDecoration: TextDecoration.lineThrough,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                // Per unit price below the crossed price
                                if (pricePerUnit != null)
                                  Text(
                                    pricePerUnit,
                                    style: AppStyle.interRegular(
                                      size: 10,
                                      color: AppStyle.textGrey,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Size info badge with packaging type at the top right
          if (sizeInfo?.size != null || packagingType != null)
            Positioned(
              top: 8.r,
              right: 8.r,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (sizeInfo?.size != null)
                    ProductUIComponents.buildSizeBadge(sizeInfo?.size),

                  if (packagingType != null)
                    Text(
                      packagingType,
                      style: AppStyle.interRegular(
                        size: 10,
                        color: AppStyle.textGrey,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),

          // SAVE badge at top left
          if (hasDiscount)
            Positioned(
              top: 8.r,
              left: 8.r,
              child: ProductUIComponents.buildDiscountBadge(originalPrice, discountedPrice),
            ),

          // Bonus indicator (if product has bonus)
          if (product.stock?.bonus != null)
            Positioned(
              top: hasDiscount ? 36.r : 8.r,
              left: 8.r,
              child: Container(
                width: 22.w,
                height: 22.h,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppStyle.blueBonus,
                ),
                child: Icon(
                  Remix.gift_2_fill,
                  size: 14.r,
                  color: AppStyle.white,
                ),
              ),
            ),

          // Cold/Frozen badges at top left with text
          if (keywords.hasCold || keywords.hasFrozen)
            Positioned(
              top: 8.r,
              left: hasDiscount
                  ? 70.r
                  : 8.r, // Adjust position if there's a discount badge
              child: keywords.hasCold && keywords.hasFrozen
                  ? Row(
                children: [
                  ProductUIComponents.buildColdFrozenBadge(
                    "Cold",
                    Colors.blue.shade100,
                    Colors.blue.shade700,
                  ),
                  SizedBox(width: 8.r),
                  ProductUIComponents.buildColdFrozenBadge(
                    "Frozen",
                    Colors.indigo.shade100,
                    Colors.indigo.shade700,
                  ),
                ],
              )
                  : keywords.hasFrozen
                  ? ProductUIComponents.buildColdFrozenBadge(
                "Frozen",
                Colors.indigo.shade100,
                Colors.indigo.shade700,
              )
                  : ProductUIComponents.buildColdFrozenBadge(
                "Cold",
                Colors.blue.shade100,
                Colors.blue.shade700,
              ),
            ),

          // Adult content badge (18+)
          if (keywords.isAdult)
            Positioned(
              top: 40.r,
              right: 8.r,
              child: Container(
                width: 22.w,
                height: 22.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppStyle.red,
                ),
                child: Center(
                  child: Text(
                    "18+",
                    style: AppStyle.interNoSemi(
                      size: 10,
                      color: AppStyle.white,
                    ),
                  ),
                ),
              ),
            ),

          // Quantity controls at top right
          Positioned(
            top: 4.r,
            right: 4.r,
            child: ProductUIComponents.buildQuantityControl(
                context, ref, product, cartQuantity, canAddDirectly: canAddDirectly),
          ),
        ],
      ),
    );
  }
}