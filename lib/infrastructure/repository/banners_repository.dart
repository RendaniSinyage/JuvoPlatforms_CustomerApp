import 'package:flutter/material.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';
import 'package:foodyman/domain/interface/banners.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/infrastructure/models/request/banners_request.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/local_storage.dart';
import 'package:foodyman/domain/handlers/handlers.dart';

class BannersRepository implements BannersRepositoryFacade {
  @override
  Future<ApiResult<BannersPaginateResponse>> getBannersPaginate(
      {required int page}) async {
    final data = BannersRequest(page: page);
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/v1/rest/banners/paginate',
        queryParameters: data.toJson(),
      );
      return ApiResult.success(
        data: BannersPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get banner products failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<BannersPaginateResponse>> getAdsPaginate(
      {required int page}) async {
    final data = BannersRequest(page: page, perPage: 6);
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/v1/rest/banners-ads',
        queryParameters: data.toJson(),
      );
      return ApiResult.success(
        data: BannersPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      debugPrint('==> get banner products failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<BannerData>> getBannerById(
    int? bannerId,
  ) async {
    final data = {'lang': LocalStorage.getLanguage()?.locale, "perPage": 100};
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/v1/rest/banners/$bannerId',
        queryParameters: data,
      );
      return ApiResult.success(
        data: BannerData.fromJson(response.data["data"]),
      );
    } catch (e) {
      debugPrint('==> get banner products failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<BannerData>> getAdsById(
    int? bannerId,
  ) async {
    final data = {'lang': LocalStorage.getLanguage()?.locale, "perPage": 100};
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/v1/rest/banners-ads/$bannerId',
        queryParameters: data,
      );
      return ApiResult.success(
        data: BannerData.fromJson(response.data["data"]),
      );
    } catch (e) {
      debugPrint('==> get banner products failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<void>> likeBanner(int? bannerId) async {
    try {
      final client = dioHttp.client(requireAuth: true);
      await client.post('/api/v1/rest/banners/$bannerId/liked');
      return const ApiResult.success(data: null);
    } catch (e) {
      debugPrint('==> like banner failure: $e');
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}
