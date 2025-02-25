// lib/infrastructure/utils/brand_utils.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/presentation/theme/app_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodyman/application/home/home_provider.dart';
import 'package:foodyman/application/shop/shop_provider.dart';

class BrandUtils {
  /// Get brand from product using brand ID and provider references
  static BrandData? getBrandFromProduct(int? brandId, WidgetRef ref) {
    if (brandId == null) {
      debugPrint("No brandId available");
      return null;
    }

    // First try to find the brand in HomeProvider (this will have our brand cache)
    final homeState = ref.read(homeProvider);
    final List<BrandData> homeBrands = homeState.brands;

    if (homeBrands.isNotEmpty) {
      for (var brand in homeBrands) {
        if (brand.id == brandId) {
          debugPrint("Found brand '${brand.title}' in HomeProvider");
          return brand;
        }
      }
    }

    // If not found in HomeProvider, try ShopProvider as fallback
    final shopState = ref.read(shopProvider);
    final List<BrandData>? shopBrands = shopState.brands;

    if (shopBrands != null && shopBrands.isNotEmpty) {
      for (var brand in shopBrands) {
        if (brand.id == brandId) {
          debugPrint("Found brand '${brand.title}' in ShopProvider");
          return brand;
        }
      }
    }

    debugPrint("Brand ID $brandId not found in either provider");
    return null;
  }

  /// Build a styled brand label with appropriate color based on brand name
  static Widget buildBrandSection(BrandData? brand) {
    if (brand == null) return const SizedBox.shrink();
    if (brand.title == null || brand.title!.isEmpty || brand.title!.toLowerCase() == 'no brand') {
      return const SizedBox.shrink();
    }

    // Determine brand color based on name
    Color brandColor = AppStyle.primary;
    final String brandLower = brand.title!.toLowerCase();

    // Red brands
    if (brandLower.contains('coke') ||
        brandLower.contains('coca-cola') ||
        brandLower.contains('kfc') ||
        brandLower.contains('krusher') ||
        brandLower.contains('kit kat') ||
        brandLower.contains('nandos') ||
        brandLower.contains('streetwise') ||
        brandLower.contains('nuggets') ||
        brandLower.contains('nandinos') ||
        brandLower.contains('nando\'s') ||
        brandLower.contains('redbull')) {
      brandColor = AppStyle.red;
    }
    // Green brands
    else if (brandLower.contains('sprite')) {
      brandColor = Colors.green;
    }
    // Blue brands
    else if (brandLower.contains('powerade') ||
        brandLower.contains('south river') ||
        brandLower.contains('valpre')) {
      brandColor = AppStyle.blueBonus;
    }
    // Brown brands
    else if (brandLower.contains('stoney')) {
      brandColor = Colors.brown;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.r, vertical: 2.r),
      decoration: BoxDecoration(
        color: brandColor,
        borderRadius: BorderRadius.zero, // Sharp corners
      ),
      child: Text(
        brand.title ?? "",
        style: AppStyle.interRegular(
          size: 12,
          color: AppStyle.white,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  /// Get shop name from ID using provider references
  static String? getShopNameFromId(int? shopId, WidgetRef ref) {
    if (shopId == null) return null;

    try {
      // Try to get shop data from homeProvider's shops list
      final homeState = ref.read(homeProvider);

      // Check in all shop lists that might be in the HomeState
      List<ShopData> allShops = [];

      // Add shops from different lists in the HomeState
      if (homeState.shops.isNotEmpty) {
        allShops.addAll(homeState.shops);
      }
      if (homeState.restaurant.isNotEmpty) {
        allShops.addAll(homeState.restaurant);
      }
      if (homeState.newRestaurant.isNotEmpty) {
        allShops.addAll(homeState.newRestaurant);
      }
      if (homeState.shopsRecommend.isNotEmpty) {
        allShops.addAll(homeState.shopsRecommend);
      }

      // Look for the shop with matching ID
      for (var shop in allShops) {
        if (shop.id == shopId) {
          return shop.translation?.title;
        }
      }
    } catch (e) {
      debugPrint("Error getting shop name: $e");
    }

    // No fallback - if we don't find the shop, we don't show the name
    // This ensures we only show products from shops that are available in the user's area
    return null;
  }
}