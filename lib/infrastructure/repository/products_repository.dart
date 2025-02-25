import 'package:flutter/material.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';
import 'package:foodyman/domain/interface/products.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/infrastructure/models/request/product_request.dart';
import 'package:foodyman/infrastructure/models/request/search_product.dart';
import 'package:foodyman/infrastructure/models/response/all_products_response.dart';
import 'package:foodyman/infrastructure/services/local_storage.dart';
import 'package:foodyman/domain/handlers/handlers.dart';
import '../services/app_helpers.dart';

class ProductsRepository implements ProductsRepositoryFacade {
  @override
  Future<ApiResult<ProductsPaginateResponse>> searchProducts(
      {required String text, int? page}) async {
    final data = SearchProductModel(text: text, page: page ?? 1);
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/v1/rest/products/paginate',
        queryParameters: data.toJson(),
      );
      return ApiResult.success(
        data: ProductsPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<SingleProductResponse>> getProductDetails(
    String uuid,
  ) async {
    final data = {
      if (LocalStorage.getSelectedCurrency() != null)
        'currency_id': LocalStorage.getSelectedCurrency()?.id,
      'lang': LocalStorage.getLanguage()?.locale,
    };
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/v1/rest/products/$uuid',
        queryParameters: data,
      );
      return ApiResult.success(
        data: SingleProductResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get product details failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getProductsByCategoryPaginate(
      {String? shopId, required int page, required int categoryId}) async {
    final data =
        ProductRequest(shopId: shopId!, page: page, categoryId: categoryId);
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/v1/rest/products/paginate',
        queryParameters: data.toJsonByCategory(),
      );
      return ApiResult.success(
        data: ProductsPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> getProductsByCategoryPaginate id failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getProductsPaginate({
    String? shopId,
    required int page,
  }) async {
    final data = ProductRequest(shopId: shopId!, page: page);
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/v1/rest/products/paginate',
        queryParameters: data.toJson(),
      );
      return ApiResult.success(
        data: ProductsPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> getProductsPaginate failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<AllProductsResponse>> getAllProducts({
    required String shopId,
  }) async {
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/v1/rest/shops/$shopId/products',
        queryParameters: {
          "lang": LocalStorage.getLanguage()?.locale,
          "currency_id": LocalStorage.getSelectedCurrency()?.id
        },
      );
      return ApiResult.success(
        data: AllProductsResponse.fromJson(response.data),
      );
    } catch (e,s) {
      debugPrint('==> getAllProducts failure: $e, $s');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getProductsShopByCategoryPaginate(
      {String? shopId,
      List<int>? brands,
      int? sortIndex,
      required int page,
      required int categoryId}) async {
    final Map<String, dynamic> data = {
      "shop_id": shopId,
      "lang": LocalStorage.getLanguage()?.locale ?? "en",
      if (LocalStorage.getSelectedCurrency() != null)
        "currency_id": LocalStorage.getSelectedCurrency()?.id,
      "page": page,
      "status": "published",
      "category_id": categoryId,
      "perPage": 6,
      if (sortIndex != 0 && sortIndex != null)
        "column": sortIndex == 1 ? "price_asc" : "price_desc",
      if (brands?.isNotEmpty ?? false)
        for (int i = 0; i < (brands?.length ?? 0); i++)
          'brand_ids[$i]': brands?[i]
    };

    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/v1/rest/shops/$shopId/products/paginate',
        queryParameters: data,
      );
      return ApiResult.success(
        data: ProductsPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> getProductsByCategoryPaginate id failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getProductsPopularPaginate({
    String? shopId,
    required int page,
  }) async {
    final data = ProductRequest(shopId: shopId!, page: page);
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/v1/rest/shops/$shopId/products/recommended/paginate',
        queryParameters: data.toJsonPopular(),
      );
      return ApiResult.success(
        data: ProductsPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> getProductsPopularPaginate failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getMostSoldProducts({
    int? shopId,
    int? categoryId,
    int? brandId,
  }) async {
    final data = {
      if (shopId != null) 'shop_id': shopId,
      if (categoryId != null) 'category_id': categoryId,
      if (brandId != null) 'brand_id': brandId,
      if (LocalStorage.getSelectedCurrency() != null)
        'currency_id': LocalStorage.getSelectedCurrency()?.id,
      'lang': LocalStorage.getLanguage()?.locale,
    };
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/v1/rest/products/most-sold',
        queryParameters: data,
      );
      return ApiResult.success(
        data: ProductsPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get most sold products failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getRelatedProducts(
    int? brandId,
    int? shopId,
    int? categoryId,
  ) async {
    final data = {
      'brand_id': brandId,
      'shop_id': shopId,
      'category_id': categoryId,
      "status": "published",
      'lang': LocalStorage.getLanguage()?.locale,
    };
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/v1/rest/products/paginate',
        queryParameters: data,
      );
      return ApiResult.success(
        data: ProductsPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> getRelatedProduct failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ProductCalculateResponse>> getProductCalculations(
    int stockId,
    int quantity,
  ) async {
    final data = {
      if (LocalStorage.getSelectedCurrency() != null)
        'currency_id': LocalStorage.getSelectedCurrency()?.id,
      'products[0][id]': stockId,
      'products[0][quantity]': quantity,
    };
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/v1/rest/products/calculate',
        queryParameters: data,
      );
      return ApiResult.success(
        data: ProductCalculateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get product calculations failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ProductCalculateResponse>> getAllCalculations(
    List<CartProductData> cartProducts,
  ) async {
    final data = {
      if (LocalStorage.getSelectedCurrency() != null)
        'currency_id': LocalStorage.getSelectedCurrency()?.id,
    };
    for (int i = 0; i < cartProducts.length; i++) {
      data['products[$i][id]'] = cartProducts[i].selectedStock?.id;
      data['products[$i][quantity]'] = cartProducts[i].quantity;
    }
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/v1/rest/products/calculate',
        queryParameters: data,
      );
      return ApiResult.success(
        data: ProductCalculateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get all calculations failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getProductsByIds(
    List<int> ids,
  ) async {
    final data = {
      if (LocalStorage.getSelectedCurrency() != null)
        'currency_id': LocalStorage.getSelectedCurrency()?.id,
      'lang': LocalStorage.getLanguage()?.locale,
    };
    for (int i = 0; i < ids.length; i++) {
      data['products[$i]'] = ids[i];
    }
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/v1/rest/products/ids',
        queryParameters: data,
      );
      return ApiResult.success(
        data: ProductsPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get products by ids failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<void>> addReview(
    String productUuid,
    String comment,
    double rating,
    String? imageUrl,
  ) async {
    final data = {
      'rating': rating,
      if (comment != "") 'comment': comment,
      if (imageUrl != null) 'images': [imageUrl],
    };
    debugPrint('===> add review data: $data');
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post(
        '/api/v1/rest/products/review/$productUuid',
        data: data,
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> add review failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getNewProducts({
    int? shopId,
    int? brandId,
    int? categoryId,
    int? page,
  }) async {
    final data = {
      if (shopId != null) 'shop_id': shopId,
      if (brandId != null) 'brand_id': brandId,
      if (categoryId != null) 'category_id': categoryId,
      if (page != null) 'page': page,
      'sort': 'desc',
      'column': 'created_at',
      if (LocalStorage.getSelectedCurrency() != null)
        'currency_id': LocalStorage.getSelectedCurrency()?.id,
      'perPage': 14,
      "status": "published",
      'lang': LocalStorage.getLanguage()?.locale,
    };
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/v1/rest/products/paginate',
        queryParameters: data,
      );
      return ApiResult.success(
        data: ProductsPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get new products failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  Future<ApiResult<ProductsPaginateResponse>> getDiscountProducts({
    int? shopId,
    int? brandId,
    int? categoryId,
    int? page,
  }) async {
    final data = {
      if (shopId != null) 'shop_id': shopId,
      if (brandId != null) 'brand_id': brandId,
      if (categoryId != null) 'category_id': categoryId,
      if (page != null) 'page': page,
      if (LocalStorage.getSelectedCurrency() != null)
        'currency_id': LocalStorage.getSelectedCurrency()?.id,
      'perPage': 14,
      'lang': LocalStorage.getLanguage()?.locale,
    };

    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/v1/rest/products/discount',
        queryParameters: data,
      );

      // Process the response to filter invalid discounts
      final responseData = response.data;
      if (responseData is Map && responseData['data'] is List) {
        final List<dynamic> productsData = responseData['data'];
        final List<dynamic> validProducts = [];

        final now = DateTime.now();
        debugPrint("Processing ${productsData.length} discount products from API...");

        for (var i = 0; i < productsData.length; i++) {
          var product = productsData[i];

          // If product has stocks array but no stock field, use the first item in stocks
          if (product is Map && product['stocks'] is List && product['stocks'].isNotEmpty && product['stock'] == null) {
            product['stock'] = product['stocks'][0];
          }

          // Verify this product has valid price discount (at least 5%)
          bool isValidDiscount = false;

          // Check price difference
          if (product['stock'] != null) {
            final originalPrice = double.tryParse(product['stock']['price']?.toString() ?? '0') ?? 0;
            final discountedPrice = double.tryParse(product['stock']['total_price']?.toString() ?? '0') ?? 0;

            // Must have at least 5% discount
            isValidDiscount = originalPrice > 0 &&
                discountedPrice > 0 &&
                discountedPrice <= (originalPrice * 0.95);

            final discountPercent = originalPrice > 0
                ? ((originalPrice - discountedPrice) / originalPrice * 100).toStringAsFixed(2)
                : "0";

            debugPrint("Product #${product['id']}: Original price: $originalPrice, Discounted: $discountedPrice, Discount: $discountPercent%, Has price discount: $isValidDiscount");
          }

          // Check discount dates if available
          bool hasValidDates = true;
          if (product['discounts'] is List && product['discounts'].isNotEmpty) {
            final discount = product['discounts'][0];

            // Check discount type
            final discountType = discount['type'];
            debugPrint("Product #${product['id']}: Discount type: $discountType");

            // Check active flag
            if (discount['active'] != null) {
              hasValidDates = hasValidDates && (discount['active'] == 1 || discount['active'] == true);
              if (!hasValidDates) {
                debugPrint("Product #${product['id']}: Discount marked as inactive");
              }
            }

            // Check start date
            if (discount['start'] != null && discount['start'] is String) {
              try {
                final startDate = DateTime.parse("${discount['start']}T00:00:00Z");
                hasValidDates = hasValidDates && now.isAfter(startDate);
                if (!hasValidDates) {
                  debugPrint("Product #${product['id']}: Discount hasn't started yet. Start: ${discount['start']}");
                }
              } catch (e) {
                debugPrint("Product #${product['id']}: Error parsing start date: ${discount['start']} - $e");
                hasValidDates = false;
              }
            }

            // Check end date
            if (discount['end'] != null && discount['end'] is String) {
              try {
                final endDate = DateTime.parse("${discount['end']}T23:59:59Z");
                hasValidDates = hasValidDates && now.isBefore(endDate);
                if (!hasValidDates) {
                  debugPrint("Product #${product['id']}: Discount has expired. End: ${discount['end']}");
                }
              } catch (e) {
                debugPrint("Product #${product['id']}: Error parsing end date: ${discount['end']} - $e");
                hasValidDates = false;
              }
            }
          }

          // Only include products with both price discount and valid dates
          if (isValidDiscount && hasValidDates) {
            validProducts.add(product);
          } else {
            debugPrint("Product #${product['id']}: Filtered out. Has price discount: $isValidDiscount, Has valid dates: $hasValidDates");
          }
        }

        // Replace original data with filtered valid products
        responseData['data'] = validProducts;
        debugPrint("Filtered ${productsData.length} discount products to ${validProducts.length} valid ones");
      }

      return ApiResult.success(
        data: ProductsPaginateResponse.fromJson(responseData),
      );
    } catch (e) {
      debugPrint('==> get discount products failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<ProductsPaginateResponse>> getProfitableProducts({
    int? brandId,
    int? categoryId,
    int? page,
  }) async {
    final data = {
      if (brandId != null) 'brand_id': brandId,
      if (categoryId != null) 'category_id': categoryId,
      if (page != null) 'page': page,
      'profitable': true,
      if (LocalStorage.getSelectedCurrency() != null)
        'currency_id': LocalStorage.getSelectedCurrency()?.id,
      'perPage': 14,
      'lang': LocalStorage.getLanguage()?.locale,
    };
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/v1/rest/products/discount',
        queryParameters: data,
      );
      return ApiResult.success(
        data: ProductsPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get profitable products failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}
