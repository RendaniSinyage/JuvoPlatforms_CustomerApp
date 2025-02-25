// lib/infrastructure/utils/product_utils.dart

import 'package:flutter/material.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/presentation/theme/app_style.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';

/// Helper class for size information
class SizeInfo {
  final String? size;
  SizeInfo(this.size);
}

/// Helper class for keyword checks
class KeywordCheck {
  final bool hasCold;
  final bool hasFrozen;
  final bool isAdult;

  KeywordCheck({
    required this.hasCold,
    required this.hasFrozen,
    required this.isAdult
  });
}

/// Helper extension for string extraction
extension StringNumberExtraction on String {
  String? extractNumber() {
    final RegExp numberPattern = RegExp(r'(\d+(?:\.\d+)?)');
    final match = numberPattern.firstMatch(this);
    return match?.group(1);
  }
}

class ProductUtils {
  /// Determines if image likely has a transparent background based on format
  static bool hasTransparentBackground(String imageUrl) {
    final String lowerUrl = imageUrl.toLowerCase();
    return lowerUrl.endsWith('.png') ||
        lowerUrl.endsWith('.webp') ||
        lowerUrl.contains('transparent') ||
        lowerUrl.contains('png') ||
        lowerUrl.contains('webp');
  }

  /// Clean title by removing brand name, size, container words
  static String cleanTitleWithBrand(String? title, String? brandName) {
    if (title == null) return '';

    String cleanedTitle = title;

    // Remove brand name if it exists
    if (brandName != null) {
      final brandPatterns = [
        RegExp(r'^' + RegExp.escape(brandName) + r'\s+', caseSensitive: false),
        RegExp(r'\s+' + RegExp.escape(brandName) + r'$', caseSensitive: false),
        RegExp(r'\s+' + RegExp.escape(brandName) + r'\s+', caseSensitive: false)
      ];

      for (final pattern in brandPatterns) {
        cleanedTitle = cleanedTitle.replaceAll(pattern, ' ');
      }
    }

    // Remove cold/frozen keywords
    cleanedTitle = cleanedTitle
        .replaceAll(RegExp(r'\bcold\b', caseSensitive: false), '')
        .replaceAll(RegExp(r'\bfrozen\b', caseSensitive: false), '')
        .replaceAll(RegExp(r'\bice cube\b', caseSensitive: false), '')
        .replaceAll(RegExp(r'\bice block\b', caseSensitive: false), '');

    // Clean other elements (size, container words)
    return cleanTitle(cleanedTitle);
  }

  /// Clean title by removing size information and container words
  static String cleanTitle(String title) {
    String cleanedTitle = title;

    // Remove size information
    final sizePatterns = [
      RegExp(
          r'\d+(?:\.\d+)?\s*(?:Litre|Liter|L|ml|milliliter|millilitre|kg|kilo|kilogram|g|gram|grams|pack|pck|case|cs)\s*-',
          caseSensitive: false),
      RegExp(
          r'-\s*\d+(?:\.\d+)?\s*(?:Litre|Liter|L|ml|milliliter|millilitre|kg|kilo|kilogram|g|gram|grams|pack|pck|case|cs)',
          caseSensitive: false),
      RegExp(r'\d+(?:\.\d+)?\s*(?:Litre|Liter|L)\b', caseSensitive: false),
      RegExp(r'\d+(?:\.\d+)?\s*(?:ml|milliliter|millilitre)\b',
          caseSensitive: false),
      RegExp(r'\d+(?:\.\d+)?\s*(?:kg|kilo|kilogram)\b', caseSensitive: false),
      RegExp(r'\d+(?:\.\d+)?\s*(?:g|gram|grams)\b', caseSensitive: false),
      RegExp(r'\d+(?:\.\d+)?\s*(?:pack|pck)\b', caseSensitive: false),
      RegExp(r'\d+(?:\.\d+)?\s*(?:case|cs)\b', caseSensitive: false),
    ];

    for (final pattern in sizePatterns) {
      cleanedTitle = cleanedTitle.replaceAll(pattern, '');
    }

    // Remove container words
    final containerWords = [
      'bottle',
      'bottles',
      'container',
      'containers',
      'can',
      'cans',
      'jar',
      'jars',
      'box',
      'boxes',
      'packet',
      'packets',
      'pack',
      'packs'
    ];

    for (final word in containerWords) {
      cleanedTitle = cleanedTitle.replaceAll(
          RegExp('\\b$word\\b', caseSensitive: false), '');
    }

    // Clean up any remaining mess
    cleanedTitle = cleanedTitle.replaceAll(RegExp(r'^-+|-+$'), '');
    cleanedTitle = cleanedTitle.replaceAll(RegExp(r'\s+'), ' ').trim();

    return cleanedTitle;
  }

  /// Helper method to extract size from title
  static SizeInfo? extractSize(String? title) {
    if (title == null) return null;

    final literPattern =
    RegExp(r'(\d+(?:\.\d+)?)\s*(?:Litre|Liter|L)\b', caseSensitive: false);
    final mlPattern = RegExp(
        r'(\d+(?:\.\d+)?)\s*(?:ml|milliliter|millilitre)\b',
        caseSensitive: false);
    final kgPattern = RegExp(r'(\d+(?:\.\d+)?)\s*(?:kg|kilo|kilogram)\b',
        caseSensitive: false);
    final gramPattern =
    RegExp(r'(\d+(?:\.\d+)?)\s*(?:g|gram|grams)\b', caseSensitive: false);

    var match = literPattern.firstMatch(title);
    if (match != null) {
      return SizeInfo('${match.group(1)}L');
    }

    match = mlPattern.firstMatch(title);
    if (match != null) {
      return SizeInfo('${match.group(1)}ml');
    }

    match = kgPattern.firstMatch(title);
    if (match != null) {
      final size = double.parse(match.group(1)!);
      return SizeInfo('${size}kg');
    }

    match = gramPattern.firstMatch(title);
    if (match != null) {
      final size = double.parse(match.group(1)!);
      if (size >= 1000) {
        return SizeInfo('${size / 1000}kg');
      }
      return SizeInfo('${size}g');
    }

    return null;
  }

  /// Helper method to find packaging type in title or description
  static String? findPackagingType(String? title, String? description) {
    // Exclude 'container' from the list of packaging types to look for in title (as requested)
    final List<String> packagingTypes = ['pack', 'bottle', 'sachet', 'case', 'box', 'bucket'];
    final List<String> allPackagingTypes = ['pack', 'container', 'bottle', 'sachet', 'case'];

    // Look for packaging types (except 'container') in title first
    for (final type in packagingTypes) {
      if (containsKeyword(title, type)) {
        return type;
      }
    }

    // Then look in description for all packaging types including 'container'
    for (final type in allPackagingTypes) {
      if (containsKeyword(description, type)) {
        return type;
      }
    }

    return null;
  }

  /// Helper method to check if text contains a specific keyword
  static bool containsKeyword(String? text, String keyword) {
    if (text == null) return false;
    return text.toLowerCase().trim().contains(keyword.toLowerCase());
  }

  /// Check for cold/frozen and adult content
  static KeywordCheck checkKeywords(String? title, String? description) {
    bool hasCold = false;
    bool hasFrozen = false;
    bool isAdult = false;

    // Check for cold/frozen in title and description
    if (containsKeyword(title, 'cold') || containsKeyword(description, 'cold')) {
      hasCold = true;
    }
    if (containsKeyword(title, 'frozen') || containsKeyword(description, 'frozen')) {
      hasFrozen = true;
    }

    // Check for adult content
    if (containsKeyword(title, 'adult') || containsKeyword(description, 'adult') ||
        containsKeyword(title, 'alcohol') || containsKeyword(description, 'alcohol')) {
      isAdult = true;
    }

    return KeywordCheck(
        hasCold: hasCold,
        hasFrozen: hasFrozen,
        isAdult: isAdult
    );
  }

  /// Helper method to calculate savings text for the SAVE badge
  static String calculateSavingsText(double originalPrice, double discountedPrice) {
    if (originalPrice <= 0 || discountedPrice >= originalPrice) {
      return 'SAVE';
    }

    // Calculate percentage saved
    final percentageSaved = ((originalPrice - discountedPrice) / originalPrice * 100).round();

    return 'SAVE $percentageSaved%';
  }

  /// Check if a product has a valid active discount
  static bool hasValidActiveDiscount(ProductData product) {
    // Check price discount
    final double originalPrice = product.stock?.price?.toDouble() ?? 0;
    final double discountedPrice = product.stock?.totalPrice?.toDouble() ?? 0;

    // Set discount threshold to 5% (0.95 of original price)
    bool hasPriceDiscount = originalPrice > 0 &&
        discountedPrice > 0 &&
        discountedPrice <= (originalPrice * 0.95);

    if (!hasPriceDiscount) {
      debugPrint("Product ${product.id}: No valid price discount. Original: $originalPrice, Discounted: $discountedPrice");
      if (originalPrice > 0) {
        final discountPercentage = ((originalPrice - discountedPrice) / originalPrice * 100);
        debugPrint("Discount percentage: ${discountPercentage.toStringAsFixed(2)}%, Required: 5%");
      }
      return false;
    }

    // Check discount dates
    if (product.discounts != null && product.discounts!.isNotEmpty) {
      final discount = product.discounts!.first;
      final DateTime now = DateTime.now();

      // Check discount type and value for additional validation
      String? discountType = discount.type;
      num? discountValue = discount.price;

      // For percentage discounts, we can calculate the expected price and compare
      if (discountType == "percent" && discountValue != null) {
        // Calculate what the discounted price should be
        double expectedDiscountedPrice = originalPrice * (1 - (discountValue / 100));

        // Allow for small rounding differences (0.01 currency units)
        bool priceMatchesDiscount = (discountedPrice - expectedDiscountedPrice).abs() <= 0.01;

        if (!priceMatchesDiscount) {
          debugPrint("Product ${product.id}: Discounted price doesn't match expected price for $discountType discount");
          debugPrint("Expected: $expectedDiscountedPrice, Actual: $discountedPrice, Discount value: $discountValue%");
          // We'll still continue because the price difference is valid, but this is a warning
        }
      }

      // Check if the discount is marked as active
      if (discount.active != 1 && discount.active != true) {
        debugPrint("Product ${product.id}: Discount marked as inactive");
        return false;
      }

      // Check start date
      if (discount.start != null) {
        if (now.isBefore(discount.start!)) {
          debugPrint("Product ${product.id}: Discount hasn't started yet. Start date: ${discount.start}");
          return false;
        }
      }

      // Check end date
      if (discount.end != null) {
        if (now.isAfter(discount.end!)) {
          debugPrint("Product ${product.id}: Discount has expired. End date: ${discount.end}");
          return false;
        }
      }

      // If we got here, both price discount and date checks passed
      final discountPercentage = ((originalPrice - discountedPrice) / originalPrice * 100);
      debugPrint("Product ${product.id}: Valid discount of ${discountPercentage.toStringAsFixed(2)}%, valid until ${discount.end}");
      return true;
    }

    // If product has price discount but no discount object,
    // we'll accept it based just on the price difference
    final discountPercentage = ((originalPrice - discountedPrice) / originalPrice * 100);
    debugPrint("Product ${product.id}: Has ${discountPercentage.toStringAsFixed(2)}% price discount but no discount object. Accepting based on price.");
    return true;
  }
}