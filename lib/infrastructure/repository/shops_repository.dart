import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpodtemp/domain/di/injection.dart';
import 'package:riverpodtemp/domain/handlers/http_service.dart';
import 'package:riverpodtemp/domain/iterface/shops.dart';
import 'package:riverpodtemp/infrastructure/models/data/address_new_data.dart';
import 'package:riverpodtemp/infrastructure/models/models.dart';
import 'package:riverpodtemp/infrastructure/models/request/only_shop.dart';
import 'package:riverpodtemp/infrastructure/models/request/search_shop.dart';
import 'package:riverpodtemp/infrastructure/models/request/shop_request.dart';
import 'package:riverpodtemp/infrastructure/models/response/branches_response.dart';
import 'package:riverpodtemp/infrastructure/services/app_constants.dart';
import 'package:riverpodtemp/infrastructure/services/local_storage.dart';
import '../../../domain/handlers/handlers.dart';
import '../models/data/filter_model.dart';
import '../models/data/story_data.dart';
import '../models/request/story_request.dart';
import '../models/response/tag_response.dart';

class ShopsRepository implements ShopsRepositoryFacade {
  @override
  Future<ApiResult<ShopsPaginateResponse>> searchShops(
      {required String text, int? categoryId}) async {
    final data = SearchShopModel(text: text, categoryId: categoryId);
    try {
      final client = inject<HttpService>().client(requireAuth: false);
      final response = await client.get(
        '/api/v1/rest/shops/search',
        queryParameters: data.toJson(),
      );
      return ApiResult.success(
        data: ShopsPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> search shops failure: $e');
      return ApiResult.failure(
          error: (e.runtimeType == DioException)
              ? ((e as DioException).response?.data["message"] == "Bad request."
                  ? (e.response?.data["params"] as Map).values.first[0]
                  : e.response?.data["message"])
              : "",
          statusCode: NetworkExceptions.getDioStatus(e));
    }
  }

  @override
  Future<ApiResult<ShopsPaginateResponse>> getNearbyShops(
    double latitude,
    double longitude,
  ) async {
    final data = {'clientLocation': '$latitude,$longitude'};
    try {
      final client = inject<HttpService>().client(requireAuth: false);
      final response = await client.get(
        '/api/v1/rest/shops/nearby',
        queryParameters: data,
      );
      return ApiResult.success(
        data: ShopsPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get nearby shops failure: $e');
      return ApiResult.failure(
          error: (e.runtimeType == DioException)
              ? ((e as DioException).response?.data["message"] == "Bad request."
                  ? (e.response?.data["params"] as Map).values.first[0]
                  : e.response?.data["message"])
              : "",
          statusCode: NetworkExceptions.getDioStatus(e));
    }
  }

  @override
  Future<ApiResult<ShopsPaginateResponse>> getAllShops(int page,
      {int? categoryId,
      FilterModel? filterModel,
      required bool isOpen,
      bool? verify}) async {
    final data = ShopRequest(
        page: page,
        categoryId: categoryId,
        price: filterModel?.price,
        rating: filterModel?.rating,
        freeDelivery: filterModel?.isFreeDelivery,
        orderBy: filterModel?.sort,
        onlyOpen: isOpen,
        verify: verify,
        deals: filterModel?.isDeal,
        take: filterModel?.offer);
    try {
      final client = inject<HttpService>().client(requireAuth: false);
      final response = await client.get(
        '/api/v1/rest/shops/paginate',
        queryParameters: data.toJson(),
      );
      return ApiResult.success(
        data: ShopsPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get all shops failure: $e');
      return ApiResult.failure(
          error: (e.runtimeType == DioException)
              ? ((e as DioException).response?.data["message"] == "Bad request."
                  ? (e.response?.data["params"] as Map).values.first[0]
                  : e.response?.data["message"])
              : "",
          statusCode: NetworkExceptions.getDioStatus(e));
    }
  }

  @override
  Future<ApiResult<BranchResponse>> getShopBranch({required int uuid}) async {
    try {
      final client = inject<HttpService>().client(requireAuth: false);
      final response = await client.get(
        '/api/v1/rest/branches?lang=en&shop_id=$uuid&page=1&perPage=100',
      );
      return ApiResult.success(
        data: BranchResponse.fromJson(response.data),
      );
    } catch (e) {
      return ApiResult.failure(
          error: (e.runtimeType == DioException)
              ? ((e as DioException).response?.data["message"] == "Bad request."
                  ? (e.response?.data["params"] as Map).values.first[0]
                  : e.response?.data["message"])
              : "",
          statusCode: NetworkExceptions.getDioStatus(e));
    }
  }

  @override
  Future<ApiResult<SingleShopResponse>> getSingleShop(
      {required String uuid}) async {
    final data = OnlyShopRequest();
    try {
      final client = inject<HttpService>().client(requireAuth: false);
      final response = await client.get('/api/v1/rest/shops/$uuid',
          queryParameters: data.toJson());
      return ApiResult.success(
        data: SingleShopResponse.fromJson(response.data),
      );
    } catch (e) {
      return ApiResult.failure(
          error: (e.runtimeType == DioException)
              ? ((e as DioException).response?.data["message"] == "Bad request."
                  ? (e.response?.data["params"] as Map).values.first[0]
                  : e.response?.data["message"])
              : "",
          statusCode: NetworkExceptions.getDioStatus(e));
    }
  }

  @override
  Future<ApiResult<dynamic>> joinOrder({
    required String shopId,
    required String name,
    required String cartId,
  }) async {
    final data = {"shop_id": shopId, "name": name, "cart_id": cartId};
    try {
      final client = inject<HttpService>().client(requireAuth: false);
      final response = await client.post('/api/v1/rest/cart/open', data: data);
      return ApiResult.success(
        data: response.data["data"]["uuid"],
      );
    } catch (e) {
      return ApiResult.failure(
          error: (e.runtimeType == DioException)
              ? ((e as DioException).response?.data["message"] == "Bad request."
                  ? (e.response?.data["params"] as Map).values.first[0]
                  : e.response?.data["message"])
              : "",
          statusCode: NetworkExceptions.getDioStatus(e));
    }
  }

  @override
  Future<ApiResult<ShopsPaginateResponse>> getShopFilter(
      {int? categoryId, required int page, int? subCategoryId}) async {
    final data = {
      'category_id': subCategoryId ?? categoryId,
      'perPage': 5,
      "open": 1,
      "page": page,
      'lang': LocalStorage.getLanguage()?.locale,
      "address": {
        "latitude": LocalStorage.getAddressSelected()?.location?.latitude ??
            AppConstants.demoLatitude,
        "longitude": LocalStorage.getAddressSelected()?.location?.longitude ??
            AppConstants.demoLongitude
      }
    };
    try {
      final client = inject<HttpService>().client(requireAuth: false);
      final response = await client.get(
        '/api/v1/rest/shops/paginate',
        queryParameters: data,
      );
      return ApiResult.success(
        data: ShopsPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get work filter shops failure: $e');
      return ApiResult.failure(
          error: (e.runtimeType == DioException)
              ? ((e as DioException).response?.data["message"] == "Bad request."
                  ? (e.response?.data["params"] as Map).values.first[0]
                  : e.response?.data["message"])
              : "",
          statusCode: NetworkExceptions.getDioStatus(e));
    }
  }

  @override
  Future<ApiResult<ShopsPaginateResponse>> getPickupShops() async {
    final data = {
      'delivery': 'pickup',
      'perPage': 100,
      'lang': LocalStorage.getLanguage()?.locale,
    };
    try {
      final client = inject<HttpService>().client(requireAuth: false);
      final response = await client.get(
        '/api/v1/rest/shops/paginate',
        queryParameters: data,
      );
      return ApiResult.success(
        data: ShopsPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get pickup shops failure: $e');
      return ApiResult.failure(
          error: (e.runtimeType == DioException)
              ? ((e as DioException).response?.data["message"] == "Bad request."
                  ? (e.response?.data["params"] as Map).values.first[0]
                  : e.response?.data["message"])
              : "",
          statusCode: NetworkExceptions.getDioStatus(e));
    }
  }

  @override
  Future<ApiResult<ShopsPaginateResponse>> getShopsByIds(
    List<int> shopIds,
  ) async {
    final data = <String, dynamic>{
      'lang': LocalStorage.getLanguage()?.locale,
    };
    for (int i = 0; i < shopIds.length; i++) {
      data['shops[$i]'] = shopIds[i];
    }
    try {
      final client = inject<HttpService>().client(requireAuth: false);
      final response = await client.get(
        '/api/v1/rest/shops',
        queryParameters: data,
      );
      return ApiResult.success(
        data: ShopsPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get shops by ids failure: $e');
      return ApiResult.failure(
          error: (e.runtimeType == DioException)
              ? ((e as DioException).response?.data["message"] == "Bad request."
                  ? (e.response?.data["params"] as Map).values.first[0]
                  : e.response?.data["message"])
              : "",
          statusCode: NetworkExceptions.getDioStatus(e));
    }
  }

  @override
  Future<ApiResult<void>> createShop({
    required double tax,
    required double deliveryTo,
    required double deliveryFrom,
    required String deliveryType,
    required String phone,
    required String name,
    required num category,
    required String description,
    required double startPrice,
    required double perKm,
    required AddressNewModel? address,
    String? logoImage,
    String? backgroundImage,
  }) async {
    final data = {
      "price_per_km": perKm,
      'tax': tax,
      'delivery_time_type': deliveryType,
      'location': LocationModel(
              latitude: address?.location?.first,
              longitude: address?.location?.last)
          .toJson(),
      'phone': phone,
      'delivery_time_from': deliveryFrom,
      'delivery_time_to': deliveryTo,
      'title': {LocalStorage.getLanguage()?.locale ?? "": name},
      'description': {LocalStorage.getLanguage()?.locale ?? "": description},
      'price': startPrice,
      'address': {
        LocalStorage.getLanguage()?.locale ?? "": "${address?.address?.address}"
      },
      if (logoImage != null) 'images[0]': logoImage,
      if (backgroundImage != null) "images[1]": backgroundImage,
    };
    try {
      final client = inject<HttpService>().client(requireAuth: true);
      await client.post(
        '/api/v1/dashboard/user/shops',
        queryParameters: data,
      );
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> create shop failure: $e');
      return ApiResult.failure(
          error: (e.runtimeType == DioException)
              ? ((e as DioException).response?.data["message"] == "Bad request."
                  ? (e.response?.data["params"] as Map).values.first[0]
                  : e.response?.data["message"])
              : "",
          statusCode: NetworkExceptions.getDioStatus(e));
    }
  }

  @override
  Future<ApiResult<ShopsPaginateResponse>> getShopsRecommend(int page) async {
    final data = ShopRequest(page: page, onlyOpen: true);
    try {
      final client = inject<HttpService>().client(requireAuth: false);
      final response = await client.get(
        '/api/v1/rest/shops/recommended',
        queryParameters: data.toJson(),
      );
      return ApiResult.success(
        data: ShopsPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get all shops recommend failure: $e');
      return ApiResult.failure(
          error: (e.runtimeType == DioException)
              ? ((e as DioException).response?.data["message"] == "Bad request."
                  ? (e.response?.data["params"] as Map).values.first[0]
                  : e.response?.data["message"])
              : "",
          statusCode: NetworkExceptions.getDioStatus(e));
    }
  }

  @override
  Future<ApiResult<List<List<StoryModel?>?>?>> getStory(int page) async {
    final data = StoryRequest(page: page);
    try {
      final client = inject<HttpService>().client(requireAuth: false);
      final response = await client.get(
        '/api/v1/rest/stories/paginate',
        queryParameters: data.toJson(),
      );
      return ApiResult.success(
        data: storyModelFromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get all story failure: $e');
      return ApiResult.failure(
          error: (e.runtimeType == DioException)
              ? ((e as DioException).response?.data["message"] == "Bad request."
                  ? (e.response?.data["params"] as Map).values.first[0]
                  : e.response?.data["message"])
              : "",
          statusCode: NetworkExceptions.getDioStatus(e));
    }
  }

  @override
  Future<ApiResult<TagResponse>> getTags(int categoryId) async {
    try {
      final client = inject<HttpService>().client(requireAuth: false);
      final data = <String, dynamic>{
        'lang': LocalStorage.getLanguage()?.locale ?? "en",
        'category_id': categoryId,
      };
      final response =
          await client.get('/api/v1/rest/shops-takes', queryParameters: data);
      return ApiResult.success(
        data: TagResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get all take failure: $e');
      return ApiResult.failure(
          error: (e.runtimeType == DioException)
              ? ((e as DioException).response?.data["message"] == "Bad request."
                  ? (e.response?.data["params"] as Map).values.first[0]
                  : e.response?.data["message"])
              : "",
          statusCode: NetworkExceptions.getDioStatus(e));
    }
  }

  @override
  Future<ApiResult<bool>> checkDriverZone(LatLng location,
      {int? shopId}) async {
    try {
      final client = inject<HttpService>().client(requireAuth: false);
      final data = <String, dynamic>{
        'address[latitude]': location.latitude,
        'address[longitude]': location.longitude,
      };
      dynamic response;
      if (shopId == null) {
        response = await client.get(
            '/api/v1/rest/shop//delivery-zone/check/distance',
            queryParameters: data);
      } else {
        response = await client.get(
            '/api/v1/rest/shop/$shopId/delivery-zone/check/distance',
            queryParameters: data);
      }

      return ApiResult.success(
        data: response.data["status"],
      );
    } catch (e) {
      debugPrint('==> get delivery zone failure: $e');
      return ApiResult.failure(
          error: (e.runtimeType == DioException)
              ? ((e as DioException).response?.data["message"])
              : "",
          statusCode: NetworkExceptions.getDioStatus(e));
    }
  }

  @override
  Future<ApiResult<PriceModel>> getSuggestPrice() async {
    try {
      final client = inject<HttpService>().client(requireAuth: false);
      final data = {
        if (LocalStorage.getSelectedCurrency() != null)
          "currency_id": LocalStorage.getSelectedCurrency()?.id
      };
      final response = await client.get('/api/v1/rest/products-avg-prices',
          queryParameters: data);
      return ApiResult.success(
        data: PriceModel.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get all price failure: $e');
      return ApiResult.failure(
          error: (e.runtimeType == DioException)
              ? ((e as DioException).response?.data["message"] == "Bad request."
                  ? (e.response?.data["params"] as Map).values.first[0]
                  : e.response?.data["message"])
              : "",
          statusCode: NetworkExceptions.getDioStatus(e));
    }
  }
}
