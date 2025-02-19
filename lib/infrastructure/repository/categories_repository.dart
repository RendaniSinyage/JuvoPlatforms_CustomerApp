import 'package:foodyman/domain/di/dependency_manager.dart';
import 'package:foodyman/domain/interface/categories.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/infrastructure/models/request/category_request.dart';
import 'package:foodyman/infrastructure/models/request/search_shop.dart';

import 'package:foodyman/domain/handlers/handlers.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';

class CategoriesRepository implements CategoriesRepositoryFacade {
  @override
  Future<ApiResult<CategoriesPaginateResponse>> getAllCategories(
      {required int page}) async {
    final data = CategoryModel(page: page);

    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/v1/rest/categories/paginate',
        queryParameters: data.toJson(),
      );
      return ApiResult.success(
        data: CategoriesPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<CategoriesPaginateResponse>> searchCategories(
      {required String text}) async {
    final data = SearchShopModel(text: text);
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/v1/rest/categories/search',
        queryParameters: data.toJson(),
      );
      return ApiResult.success(
        data: CategoriesPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<CategoriesPaginateResponse>> getCategoriesByShop(
      {required String shopId}) async {
    final data = CategoryModel(page: 1);
    try {
      final client = dioHttp.client(requireAuth: false);
      final response = await client.get(
        '/api/v1/rest/shops/$shopId/categories',
        queryParameters: data.toJsonShop(),
      );
      return ApiResult.success(
        data: CategoriesPaginateResponse.fromJson(response.data),
      );
    } catch (e) {
      return ApiResult.failure(
        error: AppHelpers.errorHandler(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}
