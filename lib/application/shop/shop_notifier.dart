import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:foodyman/infrastructure/services/time_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:foodyman/domain/interface/brands.dart';
import 'package:foodyman/domain/interface/categories.dart';
import 'package:foodyman/domain/interface/products.dart';
import 'package:foodyman/domain/interface/shops.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/infrastructure/services/app_connectivity.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/local_storage.dart';
import 'package:http/http.dart' as http;
import 'package:foodyman/infrastructure/services/marker_image_cropper.dart';
import 'package:foodyman/domain/interface/draw.dart';
import 'package:foodyman/infrastructure/models/response/all_products_response.dart';
import 'package:share_plus/share_plus.dart';
import '../../app_constants.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';
import '../../infrastructure/models/data/translation.dart';
import 'shop_state.dart';


class ShopNotifier extends StateNotifier<ShopState> {
  final ProductsRepositoryFacade _productsRepository;
  final ShopsRepositoryFacade _shopsRepository;
  final CategoriesRepositoryFacade _categoriesRepository;
  final DrawRepositoryFacade _drawRouting;
  final BrandsRepositoryFacade _brandsRepository;

  ShopNotifier(this._shopsRepository, this._productsRepository,
      this._categoriesRepository, this._drawRouting, this._brandsRepository)
      : super(const ShopState());
  int page = 1;
  List<int> _list = [];
  String? shareLink;

  void showWeekTime() {
    state = state.copyWith(showWeekTime: !state.showWeekTime);
  }

  void showBranch() {
    state = state.copyWith(showBranch: !state.showBranch);
  }

  void enableSearch() {
    state = state.copyWith(isSearchEnabled: !state.isSearchEnabled);
  }

  void enableNestedScroll({bool? val}) {
    state = state.copyWith(
        isNestedScrollDisabled: val ?? !state.isNestedScrollDisabled);
  }

  Future<void> getRoutingAll({
    required BuildContext context,
    required LatLng start,
    required LatLng end,
  }) async {
    if (await AppConnectivity.connectivity()) {
      state = state.copyWith(polylineCoordinates: []);
      final response = await _drawRouting.getRouting(start: start, end: end);
      response.when(
        success: (data) {
          List<LatLng> list = [];
          List ls = data.features[0].geometry.coordinates;
          for (int i = 0; i < ls.length; i++) {
            list.add(LatLng(ls[i][1], ls[i][0]));
          }
          state = state.copyWith(
            polylineCoordinates: list,
          );
        },
        failure: (failure, status) {
          state = state.copyWith(polylineCoordinates: []);
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  changeMap({
    required LatLng shopLocation,
  }) async {
    state = state.copyWith(isMapLoading: true);
    final ImageCropperForMarker image = ImageCropperForMarker();
    Set<Marker> markers = {};
    markers.addAll({
      Marker(
          markerId: const MarkerId("shop"),
          position: shopLocation,
          icon:
              await image.resizeAndCircle(state.shopData?.logoImg ?? "", 120)),
      Marker(
          markerId: const MarkerId("user"),
          position: LatLng(
            LocalStorage.getAddressSelected()?.location?.latitude ??
                AppConstants.demoLatitude,
            LocalStorage.getAddressSelected()?.location?.longitude ??
                AppConstants.demoLongitude,
          ),
          icon:
              await image.resizeAndCircle(LocalStorage.getUser()?.img, 120))
    });
    state = state.copyWith(isMapLoading: false, shopMarkers: markers);
  }

  getMarker() async {
    state = state.copyWith(
        isMapLoading: true, showBranch: false, showWeekTime: false);
    final ImageCropperForMarker image = ImageCropperForMarker();
    Set<Marker> markers = {};
    markers.addAll({
      Marker(
          markerId: const MarkerId("shop"),
          position: LatLng(
            state.shopData?.location?.latitude ?? AppConstants.demoLatitude,
            state.shopData?.location?.longitude ?? AppConstants.demoLongitude,
          ),
          icon:
              await image.resizeAndCircle(state.shopData?.logoImg ?? "", 120)),
      Marker(
          markerId: const MarkerId("user"),
          position: LatLng(
            LocalStorage.getAddressSelected()?.location?.latitude ??
                AppConstants.demoLatitude,
            LocalStorage.getAddressSelected()?.location?.longitude ??
                AppConstants.demoLongitude,
          ),
          icon:
              await image.resizeAndCircle(LocalStorage.getUser()?.img, 120))
    });
    state = state.copyWith(shopMarkers: markers, isMapLoading: false);
    final res =
        await _shopsRepository.getShopBranch(uuid: state.shopData?.id ?? 0);
    res.when(
        success: (data) {
          state = state.copyWith(branches: data.data);
        },
        failure: (t, e) {});
  }

  void onLike() {
    if (state.isLike) {
      for (int i = 0; i < _list.length; i++) {
        if (_list[i] == state.shopData?.id) {
          _list.removeAt(i);
          break;
        }
      }
    } else {
      _list.add(state.shopData?.id ?? 0);
    }
    state = state.copyWith(isLike: !state.isLike);
    LocalStorage.setSavedShopsList(_list);
  }

  void changeIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }

  void changeSearchText(String text) {
    state = state.copyWith(searchText: text);
  }

  void changeSubIndex(int index) {
    state = state.copyWith(subCategoryIndex: index);
  }

  void checkWorkingDay() {
    int todayWeekIndex = 0;
    for (int i = 0; i < state.shopData!.shopWorkingDays!.length; i++) {
      if (state.shopData!.shopWorkingDays![i].day ==
             TimeService.dateFormatEE(DateTime.now()).toLowerCase() &&
          !(state.shopData!.shopWorkingDays![i].disabled ?? true)) {
        state = state.copyWith(isTodayWorkingDay: true);
        todayWeekIndex = i;
        break;
      } else {
        state = state.copyWith(isTodayWorkingDay: false);
      }
    }

    if (state.isTodayWorkingDay) {
      for (int i = 0; i < state.shopData!.shopClosedDate!.length; i++) {
        if (DateTime.now().year ==
                state.shopData!.shopClosedDate![i].day!.year &&
            DateTime.now().month ==
                state.shopData!.shopClosedDate![i].day!.month &&
            DateTime.now().day == state.shopData!.shopClosedDate![i].day!.day) {
          state = state.copyWith(isTodayWorkingDay: false);
          break;
        } else {
          state = state.copyWith(isTodayWorkingDay: true);
        }
      }
      if (state.isTodayWorkingDay) {
        TimeOfDay startTimeOfDay = TimeOfDay(
          hour: int.tryParse(state
                      .shopData!.shopWorkingDays?[todayWeekIndex].from
                      ?.substring(
                          0,
                          state.shopData!.shopWorkingDays?[todayWeekIndex].from
                                  ?.indexOf("-") ??
                              0) ??
                  "") ??
              0,
          minute: int.tryParse(state
                      .shopData!.shopWorkingDays?[todayWeekIndex].from
                      ?.substring((state.shopData!
                                  .shopWorkingDays?[todayWeekIndex].from
                                  ?.indexOf("-") ??
                              0) +
                          1) ??
                  "") ??
              0,
        );
        TimeOfDay endTimeOfDay = TimeOfDay(
          hour: int.tryParse(state.shopData!.shopWorkingDays?[todayWeekIndex].to
                      ?.substring(
                          0,
                          state.shopData!.shopWorkingDays?[todayWeekIndex].to
                                  ?.indexOf("-") ??
                              0) ??
                  "") ??
              0,
          minute: int.tryParse(state
                      .shopData!.shopWorkingDays?[todayWeekIndex].to
                      ?.substring((state
                                  .shopData!.shopWorkingDays?[todayWeekIndex].to
                                  ?.indexOf("-") ??
                              0) +
                          1) ??
                  "") ??
              0,
        );
        state = state.copyWith(
          startTodayTime: startTimeOfDay,
          endTodayTime: endTimeOfDay,
        );
      }
    }
  }

  Future<void> setShop(ShopData shop) async {
    _list = LocalStorage.getSavedShopsList();
    for (int e in _list) {
      if (e == shop.id) {
        state = state.copyWith(
          isLike: true,
        );
        break;
      }
    }
    state = state.copyWith(
      shopData: shop,
    );
    generateShareLink();
    checkWorkingDay();
    final response =
        await _shopsRepository.getSingleShop(uuid: (shop.id ?? 0).toString());
    response.when(
      success: (data) async {
        _list = LocalStorage.getSavedShopsList();
        for (int e in _list) {
          if (e == data.data?.id) {
            state = state.copyWith(
              isLike: true,
            );
            break;
          }
        }
        state = state.copyWith(
          shopData: data.data,
        );
        checkWorkingDay();
      },
      failure: (failure, status) {},
    );
  }

  leaveGroup() {
    state = state.copyWith(
      userUuid: "",
      isGroupOrder: false,
    );
  }

  Future<void> joinOrder(BuildContext context, String shopId, String cartId,
      String name, VoidCallback onSuccess) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isJoinOrder: true);
      final response = await _shopsRepository.joinOrder(
          shopId: shopId, name: name, cartId: cartId);
      response.when(
        success: (data) async {
          state = state.copyWith(
              isJoinOrder: false, isGroupOrder: true, userUuid: data);
          onSuccess();
        },
        failure: (failure, status) {
          state = state.copyWith(
            isJoinOrder: false,
            userUuid: "",
            isGroupOrder: false,
          );
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<void> fetchShop(BuildContext context, String uuid) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isLoading: true);
      final response = await _shopsRepository.getSingleShop(uuid: uuid);
      response.when(
        success: (data) async {
          _list = LocalStorage.getSavedShopsList();
          for (int e in _list) {
            if (e == data.data?.id) {
              state = state.copyWith(
                isLike: true,
              );
              break;
            }
          }
          state = state.copyWith(
            isLoading: false,
            shopData: data.data,
          );
          generateShareLink();
          checkWorkingDay();
        },
        failure: (failure, status) {
          state = state.copyWith(isLoading: false);
          AppHelpers.showCheckTopSnackBar(
            context,
            failure,
          );
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<bool> fetchCategory(BuildContext context, String shopId) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isCategoryLoading: true);
      final response =
          await _categoriesRepository.getCategoriesByShop(shopId: shopId);
      response.when(
        success: (data) async {
          state = state.copyWith(
            category: data.data,
            isCategoryLoading: false,
          );
          return true;
        },
        failure: (failure, status) {
          state = state.copyWith(isCategoryLoading: false);
          AppHelpers.showCheckTopSnackBar(
            context,
            failure,
          );
          return false;
        },
      );
      return false;
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
      return false;
    }
  }

// At the end of the fetchProducts method in ShopNotifier, add this code
// to copy brand_ids from regular products to popular products:

  Future<void> fetchProducts(BuildContext context, String shopId, ValueChanged<int> onSuccess) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      page = 1;
      state = state.copyWith(
          isProductLoading: true,
          isCategoryLoading: true,
          isBrandsLoading: true
      );

      // First, fetch all brands for the shop - this is the only brands request we need
      final brandsResponse = await _brandsRepository.getAllBrands(shopId: shopId);
      List<BrandData> shopBrands = [];

      brandsResponse.when(
          success: (brandsData) {
            shopBrands = brandsData.data ?? [];
            // Update state with all shop brands - we won't need to fetch by category anymore
            state = state.copyWith(
                brands: shopBrands,
                isBrandsLoading: false
            );
          },
          failure: (failure, status) {
            debugPrint('Failed to fetch brands: $failure');
            state = state.copyWith(isBrandsLoading: false);
          }
      );

      // Then fetch products
      final productsResponse = await _productsRepository.getAllProducts(shopId: shopId);

      productsResponse.when(
          success: (data) {
            List<All> allList = data.data?.all ?? [];
            for (int i = 0; i < allList.length; i++) {
              allList[i] = allList[i].copyWith(key: GlobalKey());
            }

            // Get recommended products
            if (data.data?.recommended?.isNotEmpty ?? false) {
              // Create a map of regular products by ID for fast lookup
              final Map<int, Product> productsById = {};
              for (final category in allList) {
                for (final product in category.products ?? []) {
                  if (product.id != null) {
                    productsById[product.id!] = product;
                  }
                }
              }

              // Copy brand_id from regular products to corresponding recommended products
              final List<Product> recommendedWithBrands = [];
              for (final recProduct in data.data?.recommended ?? []) {
                if (recProduct.id != null && productsById.containsKey(recProduct.id)) {
                  // Copy the brand_id from the regular product to the recommended product
                  final regularProduct = productsById[recProduct.id]!;
                  recommendedWithBrands.add(recProduct.copyWith(brandId: regularProduct.brandId));
                } else {
                  recommendedWithBrands.add(recProduct);
                }
              }

              // Insert the popular category with updated products that have brand IDs
              allList.insert(
                0,
                All(
                    translation: Translation(
                      title: AppHelpers.getTranslation(TrKeys.popular),
                    ),
                    key: GlobalKey(),
                    products: recommendedWithBrands
                ),
              );
            }

            state = state.copyWith(
                allData: allList,
                isProductLoading: false,
                isCategoryLoading: false
            );

            onSuccess.call(allList.length);
          },
          failure: (failure, status) {
            state = state.copyWith(
                isProductLoading: false,
                isCategoryLoading: false
            );
            AppHelpers.showCheckTopSnackBar(context, failure);
          }
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
      state = state.copyWith(
          isProductLoading: false,
          isCategoryLoading: false,
          isBrandsLoading: false
      );
    }
  }

// Modified fetchBrands method - only used as a fallback
  Future<void> fetchBrands(BuildContext context, int categoryId) async {
    // If we already have brands, don't fetch again
    if (state.brands != null && state.brands!.isNotEmpty) {
      return;
    }

    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isBrandsLoading: true);
      final response = await _brandsRepository.getAllBrands(categoryId: categoryId);
      response.when(
        success: (data) {
          state = state.copyWith(
              brands: data.data,
              isBrandsLoading: false
          );
        },
        failure: (failure, status) {
          state = state.copyWith(isBrandsLoading: false);
          AppHelpers.showCheckTopSnackBar(
            context,
            failure,
          );
        },
      );
    } else {
      state = state.copyWith(isBrandsLoading: false);
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(
          context,
        );
      }
    }
  }

  // Helper method to fetch brands for a single category
  Future<void> _fetchBrandForCategory(BuildContext context, int categoryId) async {
    try {
      final response = await _brandsRepository.getAllBrands(categoryId: categoryId);
      response.when(
        success: (data) {
          // More aggressive deduplication
          final List<BrandData> newBrands = data.data ?? [];
          final Set<int> existingBrandIds = {
            ...state.brands?.map((b) => b.id).whereType<int>() ?? {}
          };

          final List<BrandData> brandsToAdd = newBrands.where((brand) =>
          brand.id != null && !existingBrandIds.contains(brand.id)
          ).toList();

          state = state.copyWith(
              brands: [
                ...?state.brands,
                ...brandsToAdd
              ]
          );
        },
        failure: (failure, status) {
          debugPrint('Failed to fetch brands for category $categoryId: $failure');
        },
      );
    } catch (e) {
      debugPrint('Exception in _fetchBrandForCategory: $e');
    }
  }

  Future<void> checkProductsPopular(BuildContext context, String shopId) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      page = 1;
      final response = await _productsRepository.getProductsPopularPaginate(
          page: 1, shopId: shopId);
      response.when(
        success: (data) {
          state =
              state.copyWith(isPopularProduct: (data.data ?? []).isNotEmpty);
        },
        failure: (failure, status) {
          AppHelpers.showCheckTopSnackBar(
            context,
            failure,
          );
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(
          context,
        );
      }
    }
  }

  // Future<void> fetchProductsPopular(BuildContext context, String shopId) async {
  //   final connected = await AppConnectivity.connectivity();
  //   if (connected) {
  //     page = 1;
  //     state = state.copyWith(
  //       isProductLoading: true,
  //     );
  //     final response = await _productsRepository.getProductsPopularPaginate(
  //         page: 1, shopId: shopId);
  //     response.when(
  //       success: (data) {
  //         state = state.copyWith(
  //             popularProducts: data.data
  //                     ?.map((e) => ProductData.fromJson(e.toJson()))
  //                     .toList() ??
  //                 [],
  //             isProductLoading: false,
  //             isPopularProduct: (data.data ?? []).isNotEmpty);
  //       },
  //       failure: (failure, status) {
  //         state = state.copyWith(isProductLoading: false);
  //         AppHelpers.showCheckTopSnackBar(
  //           context,
  //           failure,
  //         );
  //       },
  //     );
  //   } else {
  //     if (context.mounted) {
  //       AppHelpers.showNoConnectionSnackBar(
  //         context,
  //       );
  //     }
  //   }
  // }

  Future<void> fetchProductsByCategory(
      BuildContext context, String shopId, int categoryId) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(
        isProductCategoryLoading: true,
      );
      page = 1;
      final response =
          await _productsRepository.getProductsShopByCategoryPaginate(
              page: 1,
              shopId: shopId,
              categoryId: categoryId,
              sortIndex: state.sortIndex,
              brands: state.brandIds);
      response.when(
        success: (data) {
          state = state.copyWith(
            categoryProducts: data.data ?? [],
            isProductCategoryLoading: false,
          );
        },
        failure: (failure, status) {
          state = state.copyWith(isProductCategoryLoading: false);
          AppHelpers.showCheckTopSnackBar(
            context,
            failure,
          );
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(
          context,
        );
      }
    }
  }

  Future<void> fetchProductsByCategoryPage(
      BuildContext context, String shopId, int categoryId,
      {RefreshController? controller}) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      final response =
          await _productsRepository.getProductsShopByCategoryPaginate(
              page: ++page, shopId: shopId, categoryId: categoryId);
      response.when(
        success: (data) {
          List<ProductData> list = List.from(state.categoryProducts);
          list.addAll(data.data!.toList());
          state = state.copyWith(
            categoryProducts: list,
          );
          if (data.data?.isEmpty ?? true) {
            controller?.loadNoData();
            return;
          }
          controller?.loadComplete();
        },
        failure: (failure, status) {
          controller?.loadComplete();

          AppHelpers.showCheckTopSnackBar(
            context,
            failure,
          );
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(
          context,
        );
      }
    }
  }

  // Future<void> fetchProductsPage(BuildContext context, String shopId,
  //     {RefreshController? controller}) async {
  //   final connected = await AppConnectivity.connectivity();
  //   if (connected) {
  //     final response = await _productsRepository.getProductsPaginate(
  //         page: ++page, shopId: shopId);
  //     response.when(
  //       success: (data) {
  //         List<ProductData> list = List.from(state.products);
  //         list.addAll(data.data!.toList());
  //         state = state.copyWith(
  //           products:
  //               list.map((e) => ProductData.fromJson(e.toJson())).toList(),
  //         );
  //         if (data.data?.isEmpty ?? true) {
  //           controller?.loadNoData();
  //           return;
  //         }
  //
  //         controller?.loadComplete();
  //       },
  //       failure: (failure, status) {
  //         controller?.loadComplete();
  //         AppHelpers.showCheckTopSnackBar(
  //           context,
  //           failure,
  //         );
  //       },
  //     );
  //   } else {
  //     if (context.mounted) {
  //       AppHelpers.showNoConnectionSnackBar(
  //         context,
  //       );
  //     }
  //   }
  // }

  // Future<void> fetchProductsPopularPage(BuildContext context, String shopId,
  //     {RefreshController? controller}) async {
  //   final connected = await AppConnectivity.connectivity();
  //   if (connected) {
  //     final response = await _productsRepository.getProductsPopularPaginate(
  //         page: ++page, shopId: shopId);
  //     response.when(
  //       success: (data) {
  //         List<ProductData> list = List.from(state.products);
  //         list.addAll(data.data ?? []);
  //         state = state.copyWith(products: list);
  //         if (data.data?.isEmpty ?? true) {
  //           controller?.loadNoData();
  //           return;
  //         }
  //
  //         controller?.loadComplete();
  //       },
  //       failure: (failure, status) {
  //         controller?.loadComplete();
  //         AppHelpers.showCheckTopSnackBar(
  //           context,
  //           failure,
  //         );
  //       },
  //     );
  //   } else {
  //     if (context.mounted) {
  //       AppHelpers.showNoConnectionSnackBar(
  //         context,
  //       );
  //     }
  //   }
  // }



  setBrands({required int id}) {
    List<int> list = List.from(state.brandIds);
    if (list.contains(id)) {
      list.remove(id);
    } else {
      list.add(id);
    }
    state = state.copyWith(brandIds: list);
  }

  clear() {
    state = state.copyWith(brandIds: [], sortIndex: 0);
  }

  changeSort(int index) {
    state = state.copyWith(sortIndex: index);
  }

  generateShareLink() async {
    final productLink = '${AppConstants.webUrl}/shop/${state.shopData?.id}';

    final dynamicLink = 'https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=${AppConstants.firebaseWebKey}';

    final dataShare = {
      "dynamicLinkInfo": {
        "domainUriPrefix": AppConstants.uriPrefix,
        "link": productLink,
        "androidInfo": {
          "androidPackageName": AppConstants.androidPackageName,
          "androidFallbackLink":
              "${AppConstants.webUrl}/shop/${state.shopData?.id}"
        },
        "iosInfo": {
          "iosBundleId": AppConstants.iosPackageName,
          "iosFallbackLink": "${AppConstants.webUrl}/shop/${state.shopData?.id}"
        },
        "socialMetaTagInfo": {
          "socialTitle": "${state.shopData?.translation?.title}",
          "socialDescription": "${state.shopData?.translation?.description}",
          "socialImageLink": '${state.shopData?.logoImg}',
        }
      }
    };
    debugPrint("share link data: $shareLink");
    final res =
        await http.post(Uri.parse(dynamicLink), body: jsonEncode(dataShare));

    shareLink = jsonDecode(res.body)['shortLink'];
    debugPrint("share link: shop_notifier $shareLink \n$dataShare");
  }

  onShare() async {
    await Share.share(
      shareLink ?? '',
      subject: state.shopData?.translation?.title ?? "Juvo",
      // title: state.shopData?.translation?.description ?? "",
    );
  }

  Future<ShopData?> fetchShopData(String shopId) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      final response = await _shopsRepository.getSingleShop(uuid: shopId);
      return response.when(
        success: (data) => data.data,
        failure: (failure, status) {
          // Handle error
          return null;
        },
      );
    } else {
      // Handle no connection
      return null;
    }
  }
}
