import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:foodyman/domain/interface/banners.dart';
import 'package:foodyman/domain/interface/categories.dart';
import 'package:foodyman/domain/interface/shops.dart';
import 'package:foodyman/infrastructure/models/data/address_information.dart';
import 'package:foodyman/infrastructure/models/data/address_new_data.dart';
import 'package:foodyman/infrastructure/models/data/address_old_data.dart';
import 'package:foodyman/infrastructure/models/data/filter_model.dart';
import 'package:foodyman/infrastructure/models/data/story_data.dart';
import 'package:foodyman/infrastructure/models/models.dart';
import 'package:foodyman/infrastructure/services/app_connectivity.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/local_storage.dart';
import 'package:auto_route/auto_route.dart';
import 'package:foodyman/presentation/routes/app_router.dart';

import '../../domain/interface/brands.dart';
import '../../domain/interface/products.dart';
import 'home_state.dart';

class HomeNotifier extends StateNotifier<HomeState> {
  final CategoriesRepositoryFacade _categoriesRepository;
  final ShopsRepositoryFacade _shopsRepository;
  final BannersRepositoryFacade _bannersRepository;
  final ProductsRepositoryFacade _productsRepository;
  final BrandsRepositoryFacade _brandsRepository;

  // Cache for preloaded category shops
  final Map<int, List<ShopData>> _preloadedCategoryShops = {};
  final Map<int, int> _categoryTotalShops = {};

  // Keep track of navigation state to avoid showing loading screens
  bool _isNavigatingToShop = false;

  HomeNotifier(this._categoriesRepository, this._bannersRepository,
      this._shopsRepository,  this._productsRepository, this._brandsRepository)
      : super(
    const HomeState(),
  );
  int categoryIndex = 1;
  int shopIndex = 1;
  int newShopIndex = 1;
  int marketIndex = 1;
  int storyIndex = 1;
  int bannerIndex = 1;
  int shopRefreshIndex = 1;
  int marketRefreshIndex = 1;
  int discountProductsIndex = 1;

  void setAddress([AddressNewModel? data]) async {
    AddressData? addressData = LocalStorage.getAddressSelected();
    state = state.copyWith(
      addressData: data ??
          AddressNewModel(
            title: addressData?.title ?? "",
            address: AddressInformation(address: addressData?.address ?? ""),
            location: [
              addressData?.location?.latitude,
              addressData?.location?.longitude
            ],
          ),
    );
  }

  // Function to preload shops for a specific category
  Future<void> _preloadShopsForCategory(int categoryId) async {
    if (_preloadedCategoryShops.containsKey(categoryId)) {
      // Already preloaded
      return;
    }

    try {
      final connected = await AppConnectivity.connectivity();
      if (!connected) return;

      final response = await _shopsRepository.getShopFilter(
        categoryId: categoryId,
        page: 1,
      );

      response.when(
        success: (data) {
          final shopsList = data.data ?? [];
          _preloadedCategoryShops[categoryId] = shopsList;
          _categoryTotalShops[categoryId] = data.meta?.total ?? 0;
          debugPrint('✅ Preloaded ${shopsList.length} shops for category $categoryId');
        },
        failure: (_, __) {
          // Silent failure for preloading
          _preloadedCategoryShops[categoryId] = []; // Store empty list to avoid retrying
        },
      );
    } catch (e) {
      debugPrint('Error preloading shops for category $categoryId: $e');
      // Don't store in _preloadedCategoryShops so we might retry later
    }
  }

  // Preload shops for all categories
  Future<void> preloadAllCategoryShops() async {
    for (final category in state.categories) {
      if (category.id != null) {
        _preloadShopsForCategory(category.id!);
        // Add small delay to avoid overwhelming the server
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }
  }

  // Modified to use preloaded shops and handle navigation seamlessly
  void setSelectCategory(int index, BuildContext context) async {
    // If we're in the process of navigating to a shop, don't change state
    if (_isNavigatingToShop) return;

    if (state.selectIndexCategory == index) {
      // User clicked the already selected category - deselect it
      state = state.copyWith(
        selectIndexCategory: -1,
        isSelectCategoryLoading: 0,
        selectIndexSubCategory: -1,
        filterShops: [], // Clear filtered shops when deselecting
        filterMarket: [],
      );
    } else {
      final int? categoryId = index >= 0 && index < state.categories.length
          ? state.categories[index].id
          : null;

      // Check if we have preloaded shops for this category
      final bool hasPreloadedShops = categoryId != null &&
          _preloadedCategoryShops.containsKey(categoryId) &&
          _preloadedCategoryShops[categoryId] != null;

      // Check if there's only one shop and we can navigate directly
      if (hasPreloadedShops && _preloadedCategoryShops[categoryId]!.length == 1) {
        // We're going to navigate to a shop directly - don't show loading
        _isNavigatingToShop = true;

        // Update the state but keep isSelectCategoryLoading at 1 to indicate it's completed
        state = state.copyWith(
          selectIndexCategory: index,
          selectIndexSubCategory: -1,
          isSelectCategoryLoading: 1,  // Already loaded
          filterShops: _preloadedCategoryShops[categoryId]!,
          filterMarket: [],
          totalShops: _categoryTotalShops[categoryId] ?? 0,
        );

        // Get the shop and navigate
        final shop = _preloadedCategoryShops[categoryId]!.first;
        if (context.mounted) {
          // Navigation callback
          onComplete() {
            // Reset navigation flag after navigation completes
            _isNavigatingToShop = false;
          }

          // Navigate to the shop page
          context.router.push(ShopRoute(shopId: shop.id.toString())).then((_) => onComplete());
        } else {
          _isNavigatingToShop = false;
        }

        return;
      }

      // Normal category selection - update UI to show loading
      state = state.copyWith(
        selectIndexCategory: index,
        selectIndexSubCategory: -1,
        isSelectCategoryLoading: index,
        // If we have preloaded shops, use them immediately to prevent "No stores" flash
        filterShops: hasPreloadedShops ? _preloadedCategoryShops[categoryId]! : [],
        filterMarket: [],
        totalShops: hasPreloadedShops ? _categoryTotalShops[categoryId] ?? 0 : 0,
      );

      if (index != -1 && categoryId != null) {
        // Fetch shops for this category (even if preloaded, to ensure fresh data)
        final response = await _shopsRepository.getShopFilter(
          categoryId: categoryId,
          page: 1,
        );

        response.when(
          success: (data) {
            final shopsList = data.data ?? [];

            // Update cache
            _preloadedCategoryShops[categoryId] = shopsList;
            _categoryTotalShops[categoryId] = data.meta?.total ?? 0;

            // If we're not navigating directly to a shop, update the state
            if (!_isNavigatingToShop) {
              // Update state with the shop list
              state = state.copyWith(
                filterShops: shopsList,
                filterMarket: [],
                isSelectCategoryLoading: 1,
                totalShops: data.meta?.total ?? 0,
              );

              // If only one shop was found (and not preloaded earlier), navigate to it
              if (shopsList.length == 1) {
                final shop = shopsList.first;
                _isNavigatingToShop = true;

                // Navigate to the shop page
                if (context.mounted) {
                  context.router.push(ShopRoute(shopId: shop.id.toString())).then((_) {
                    _isNavigatingToShop = false;
                  });
                } else {
                  _isNavigatingToShop = false;
                }
              }
            }
          },
          failure: (failure, status) {
            // Update state to show error has completed
            state = state.copyWith(isSelectCategoryLoading: 1);
            AppHelpers.showCheckTopSnackBar(context, failure);
          },
        );
      }
    }
  }

  void setSelectSubCategory(int index, BuildContext context) {
    if (state.selectIndexSubCategory == index) {
      state = state.copyWith(selectIndexSubCategory: -1);
    } else {
      state = state.copyWith(selectIndexSubCategory: index);
    }
    fetchFilterRestaurant(context, isRefresh: true);
  }

  Future<void> fetchCategories(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isCategoryLoading: true);
      final response = await _categoriesRepository.getAllCategories(page: 1);
      response.when(
        success: (data) async {
          state = state.copyWith(
            isCategoryLoading: false,
            categories: data.data ?? [],
          );

          // Start preloading shops for all categories
          preloadAllCategoryShops();
        },
        failure: (failure, status) {
          state = state.copyWith(isCategoryLoading: false);
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

  fetchFilterRestaurant(
      BuildContext context, {
        bool? isRefresh,
        RefreshController? controller,
      }) async {
    // Safety check - if no category is selected, don't fetch
    if (state.selectIndexCategory == -1) {
      return;
    }

    final connected = await AppConnectivity.connectivity();
    if (connected) {
      // Only clear the list if this is a refresh call
      if (isRefresh ?? false) {
        controller?.resetNoData();
        shopRefreshIndex = 0;
        state = state.copyWith(
          filterShops: [],
          filterMarket: [],
          isSelectCategoryLoading: state.isSelectCategoryLoading,
        );
      }

      // Get category ID and subcategory ID if applicable
      final int? categoryId = state.selectIndexCategory >= 0 && state.selectIndexCategory < state.categories.length
          ? state.categories[state.selectIndexCategory].id
          : null;

      final int? subCategoryId;
      if (state.selectIndexSubCategory != -1 &&
          state.selectIndexCategory >= 0 &&
          state.selectIndexCategory < state.categories.length &&
          state.categories[state.selectIndexCategory].children != null &&
          state.selectIndexSubCategory < (state.categories[state.selectIndexCategory].children?.length ?? 0)) {
        subCategoryId = state.categories[state.selectIndexCategory].children?[state.selectIndexSubCategory].id;
      } else {
        subCategoryId = null;
      }

      // Return early if we don't have a valid category
      if (categoryId == null) {
        state = state.copyWith(isSelectCategoryLoading: 1);
        return;
      }

      final response = await _shopsRepository.getShopFilter(
          categoryId: categoryId,
          subCategoryId: subCategoryId,
          page: ++shopRefreshIndex);

      response.when(success: (data) {
        // If refreshing, replace the list; otherwise, append to it
        List<ShopData> list = (isRefresh ?? false)
            ? (data.data ?? [])
            : [...state.filterShops, ...(data.data ?? [])];

        // Update preloaded data if this is page 1
        if (shopRefreshIndex == 1 && subCategoryId == null) {
          _preloadedCategoryShops[categoryId] = data.data ?? [];
          _categoryTotalShops[categoryId] = data.meta?.total ?? 0;
        }

        state = state.copyWith(
          isSelectCategoryLoading: 1, // Show that loading is complete
          filterShops: list,
          totalShops: data.meta?.total ?? 0,
        );

        if (isRefresh ?? false) {
          controller?.refreshCompleted();
        } else if (data.data?.isEmpty ?? true) {
          controller?.loadNoData();
        } else {
          controller?.loadComplete();
        }
      }, failure: (failure, status) {
        state = state.copyWith(isSelectCategoryLoading: 1);
        AppHelpers.showCheckTopSnackBar(context, failure);
      });
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<void> fetchAdsById(BuildContext context, int bannerId) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isBannerLoading: true);
      final response = await _bannersRepository.getAdsById(bannerId);
      response.when(
        success: (data) async {
          state = state.copyWith(
            isBannerLoading: false,
            banner: data,
          );
        },
        failure: (failure, status) {
          state = state.copyWith(isBannerLoading: false);
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

  Future<void> fetchBannerById(BuildContext context, int bannerId) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isBannerLoading: true);
      final response = await _bannersRepository.getBannerById(bannerId);
      response.when(
        success: (data) async {
          state = state.copyWith(
            isBannerLoading: false,
            banner: data,
          );
        },
        failure: (failure, status) {
          state = state.copyWith(isBannerLoading: false);
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

  Future<void> fetchCategoriesPage(
      BuildContext context, RefreshController controller,
      {bool isRefresh = false}) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      if (isRefresh) {
        categoryIndex = 1;
        controller.resetNoData();
      }
      final response = await _categoriesRepository.getAllCategories(
          page: isRefresh ? 1 : ++categoryIndex);
      response.when(
        success: (data) async {
          if (isRefresh) {
            state = state.copyWith(
              categories: data.data ?? [],
            );
            controller.refreshCompleted();

            // Clear preloaded cache and start fresh on refresh
            _preloadedCategoryShops.clear();
            _categoryTotalShops.clear();
            preloadAllCategoryShops();
          } else {
            if (data.data?.isNotEmpty ?? false) {
              List<CategoryData> list = List.from(state.categories);
              list.addAll(data.data!);
              state = state.copyWith(
                categories: list,
              );
              controller.loadComplete();

              // Preload shops for new categories
              for (final category in data.data ?? []) {
                if (category.id != null) {
                  _preloadShopsForCategory(category.id!);
                }
              }
            } else {
              categoryIndex--;
              controller.loadNoData();
            }
          }
        },
        failure: (failure, status) {
          if (!isRefresh) {
            categoryIndex--;
            controller.loadNoData();
          } else {
            controller.refreshFailed();
          }
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

  Future<void> fetchShop(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isShopLoading: true);
      final response =
      await _shopsRepository.getAllShops(1, isOpen: true, verify: true);
      response.when(
        success: (data) async {
          state = state.copyWith(
              isShopLoading: false,
              shops: data.data ?? [],
              totalShops: data.meta?.total ?? 0);
        },
        failure: (failure, status) {
          state = state.copyWith(isShopLoading: false);
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

  Future<void> fetchShopPage(
      BuildContext context, RefreshController shopController,
      {bool isRefresh = false}) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      if (isRefresh) {
        marketIndex = 1;
        shopController.resetNoData();
      }
      final response = await _shopsRepository.getAllShops(
          isRefresh ? 1 : ++marketIndex,
          isOpen: true,
          verify: true);
      response.when(
        success: (data) async {
          if (isRefresh) {
            state = state.copyWith(
              shops: data.data ?? [],
            );
            shopController.refreshCompleted();
          } else {
            if (data.data?.isNotEmpty ?? false) {
              List<ShopData> list = List.from(state.shops);
              list.addAll(data.data!);
              state = state.copyWith(
                shops: list,
              );
              shopController.loadComplete();
            } else {
              marketIndex--;

              shopController.loadNoData();
            }
          }
        },
        failure: (failure, status) {
          if (!isRefresh) {
            marketIndex--;
            shopController.loadFailed();
          } else {
            shopController.refreshFailed();
          }
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

  Future<void> fetchRestaurant(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isRestaurantLoading: true);
      final response = await _shopsRepository.getAllShops(1, isOpen: true);
      response.when(
        success: (data) async {
          state = state.copyWith(
              isRestaurantLoading: false, restaurant: data.data ?? []);
        },
        failure: (failure, status) {
          state = state.copyWith(isRestaurantLoading: false);
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

  Future<void> fetchRestaurantPage(
      BuildContext context, RefreshController shopController,
      {bool isRefresh = false}) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      if (isRefresh) {
        shopIndex = 1;
        shopController.resetNoData();
      }
      final response = await _shopsRepository
          .getAllShops(isRefresh ? 1 : ++shopIndex, isOpen: true);
      response.when(
        success: (data) async {
          if (isRefresh) {
            state = state.copyWith(
              restaurant: data.data ?? [],
            );
            shopController.refreshCompleted();
          } else {
            if (data.data?.isNotEmpty ?? false) {
              List<ShopData> list = List.from(state.restaurant);
              list.addAll(data.data!);
              state = state.copyWith(
                restaurant: list,
              );
              shopController.loadComplete();
            } else {
              shopIndex--;

              shopController.loadNoData();
            }
          }
        },
        failure: (failure, status) {
          if (!isRefresh) {
            shopIndex--;
            shopController.loadFailed();
          } else {
            shopController.refreshFailed();
          }
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

  Future<void> fetchRestaurantNew(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isRestaurantNewLoading: true);
      final response = await _shopsRepository.getAllShops(1,
          filterModel: FilterModel(sort: "new"), isOpen: true);
      response.when(
        success: (data) async {
          state = state.copyWith(
              isRestaurantNewLoading: false, newRestaurant: data.data ?? []);
        },
        failure: (failure, status) {
          state = state.copyWith(isRestaurantNewLoading: false);
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

  Future<void> fetchRestaurantPageNew(
      BuildContext context, RefreshController shopController,
      {bool isRefresh = false}) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      if (isRefresh) {
        newShopIndex = 1;
      }
      final response = await _shopsRepository.getAllShops(
          isRefresh ? 1 : ++newShopIndex,
          filterModel: FilterModel(sort: "new"),
          isOpen: true);
      response.when(
        success: (data) async {
          if (isRefresh) {
            state = state.copyWith(
              newRestaurant: data.data ?? [],
            );
            shopController.refreshCompleted();
          } else {
            if (data.data?.isNotEmpty ?? false) {
              List<ShopData> list = List.from(state.newRestaurant);
              list.addAll(data.data!);
              state = state.copyWith(
                newRestaurant: list,
              );
              shopController.loadComplete();
            } else {
              newShopIndex--;
              shopController.loadNoData();
            }
          }
        },
        failure: (failure, status) {
          if (!isRefresh) {
            newShopIndex--;
            shopController.loadFailed();
          } else {
            shopController.refreshFailed();
          }
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

  Future<void> fetchShopRecommend(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isShopRecommendLoading: true);
      final response = await _shopsRepository.getShopsRecommend(1);
      response.when(
        success: (data) async {
          state = state.copyWith(
              isShopRecommendLoading: false, shopsRecommend: data.data ?? []);
        },
        failure: (failure, status) {
          state = state.copyWith(isShopRecommendLoading: false);
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

  Future<void> fetchStorePage(
      BuildContext context, RefreshController shopController,
      {bool isRefresh = false}) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      if (isRefresh) {
        storyIndex = 1;
        shopController.resetNoData();
      }
      final response =
      await _shopsRepository.getStory(isRefresh ? 1 : ++storyIndex);
      response.when(
        success: (data) async {
          if (isRefresh) {
            state = state.copyWith(
              story: data ?? [],
            );
            shopController.refreshCompleted();
          } else {
            if (data?.isNotEmpty ?? false) {
              List<List<StoryModel?>?>? list = state.story;
              list!.addAll(data!);
              state = state.copyWith(
                story: list,
              );
              shopController.loadComplete();
            } else {
              storyIndex--;

              shopController.loadNoData();
            }
          }
        },
        failure: (failure, status) {
          if (!isRefresh) {
            storyIndex--;
            shopController.loadFailed();
          } else {
            shopController.refreshFailed();
          }
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

  Future<void> fetchStore(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isStoryLoading: true);
      final response = await _shopsRepository.getStory(1);
      response.when(
        success: (data) async {
          state = state.copyWith(isStoryLoading: false, story: data ?? []);
        },
        failure: (failure, status) {
          state = state.copyWith(isStoryLoading: false);
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

  Future<void> fetchShopPageRecommend(
      BuildContext context, RefreshController shopController,
      {bool isRefresh = false}) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      if (isRefresh) {
        shopIndex = 1;
      }
      final response =
      await _shopsRepository.getShopsRecommend(isRefresh ? 1 : ++shopIndex);
      response.when(
        success: (data) async {
          if (isRefresh) {
            state = state.copyWith(
              shopsRecommend: data.data ?? [],
            );
            shopController.refreshCompleted();
          } else {
            if (data.data?.isNotEmpty ?? false) {
              List<ShopData> list = List.from(state.shopsRecommend);
              list.addAll(data.data!);
              state = state.copyWith(
                shopsRecommend: list,
              );
              shopController.loadComplete();
            } else {
              shopIndex--;

              shopController.loadNoData();
            }
          }
        },
        failure: (failure, status) {
          if (!isRefresh) {
            shopIndex--;
            shopController.loadFailed();
          } else {
            shopController.refreshFailed();
          }
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

  Future<void> fetchBanner(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isBannerLoading: true);
      final response = await _bannersRepository.getBannersPaginate(page: 1);
      response.when(
        success: (data) async {
          state =
              state.copyWith(isBannerLoading: false, banners: data.data ?? []);
        },
        failure: (failure, status) {
          state = state.copyWith(isBannerLoading: false);
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

  Future<void> fetchAds(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      final response = await _bannersRepository.getAdsPaginate(page: 1);
      response.when(
        success: (data) async {
          state = state.copyWith(ads: data.data ?? []);
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
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<void> fetchBannerPage(
      BuildContext context, RefreshController controller,
      {bool isRefresh = false}) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      if (isRefresh) {
        bannerIndex = 1;
        controller.resetNoData();
      }
      final response = await _bannersRepository.getBannersPaginate(
          page: isRefresh ? 1 : ++bannerIndex);
      response.when(
        success: (data) async {
          if (isRefresh) {
            state = state.copyWith(
              banners: data.data ?? [],
            );
            controller.refreshCompleted();
          } else {
            if (data.data?.isNotEmpty ?? false) {
              List<BannerData> list = List.from(state.banners);
              list.addAll(data.data!);
              state = state.copyWith(
                banners: list,
              );
              controller.loadComplete();
            } else {
              bannerIndex--;
              controller.loadNoData();
            }
          }
        },
        failure: (failure, status) {
          if (!isRefresh) {
            bannerIndex--;
            controller.loadFailed();
          } else {
            controller.refreshFailed();
          }

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

  // Enhanced fetchDiscountProducts method for HomeNotifier class
  Future<void> fetchDiscountProducts(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isDiscountProductsLoading: true);

      try {
        // Get all discount products
        final response = await _productsRepository.getDiscountProducts(
          page: 1,
        );

        response.when(
          success: (data) async {
            final List<ProductData> products = data.data ?? [];

            // Step 1: Extract all brand IDs from the products
            final Set<int> brandIds = {};
            for (final product in products) {
              if (product.brandId != null) {
                brandIds.add(product.brandId!);
              }
            }

            // Step 2: Get existing cached brands
            final Set<int> cachedBrandIds = state.brands.map((b) => b.id).whereType<int>().toSet();

            // Step 3: Determine which brands we need to fetch
            final Set<int> missingBrandIds = brandIds.difference(cachedBrandIds);

            // Step 4: Prefetch all missing brands before updating the UI
            List<BrandData> newBrands = [];
            List<Future> brandFutures = [];

            // Create a future for each brand fetch operation
            for (final brandId in missingBrandIds) {
              final future = _brandsRepository.getSingleBrand(brandId).then((response) {
                response.when(
                  success: (data) {
                    if (data.data != null) {
                      newBrands.add(data.data!);
                      debugPrint("✅ Fetched brand: ${data.data!.title} (ID: $brandId)");
                    }
                  },
                  failure: (failure, status) {
                    debugPrint("❌ Failed to fetch brand ID $brandId: $failure");
                  },
                );
              }).catchError((e) {
                debugPrint("❌ Exception fetching brand ID $brandId: $e");
              });

              brandFutures.add(future);
            }

            // Wait for all brand fetches to complete
            if (brandFutures.isNotEmpty) {
              await Future.wait(brandFutures);
              debugPrint("✅ All brand fetches completed");
            }

            // Combine existing brands with new brands
            final List<BrandData> allBrands = [...state.brands, ...newBrands];

            // Finally update the state with both products and brands
            state = state.copyWith(
              isDiscountProductsLoading: false,
              discountProducts: products,
              brands: allBrands,
            );

            debugPrint("✅ Updated state with ${products.length} products and ${allBrands.length} brands");
          },
          failure: (failure, status) {
            state = state.copyWith(isDiscountProductsLoading: false);
            AppHelpers.showCheckTopSnackBar(
              context,
              failure,
            );
          },
        );
      } catch (e) {
        debugPrint("❌ Exception in fetchDiscountProducts: $e");
        state = state.copyWith(isDiscountProductsLoading: false);
        if (context.mounted) {
          AppHelpers.showCheckTopSnackBar(
            context,
            "Failed to load discount products: $e",
          );
        }
      }
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }
}
