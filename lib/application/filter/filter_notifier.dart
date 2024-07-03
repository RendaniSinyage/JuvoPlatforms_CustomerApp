import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:riverpodtemp/domain/iterface/shops.dart';
import 'package:riverpodtemp/infrastructure/models/data/filter_model.dart';
import 'package:riverpodtemp/infrastructure/services/tpying_delay.dart';

import '../../infrastructure/models/data/shop_data.dart';
import '../../infrastructure/services/app_connectivity.dart';
import '../../infrastructure/services/app_helpers.dart';
import 'filter_state.dart';

class FilterNotifier extends StateNotifier<FilterState> {
  final ShopsRepositoryFacade _shopsRepository;

  FilterNotifier(this._shopsRepository) : super(const FilterState());
  int shopIndex = 1;
  int marketRefreshIndex = 1;
  final _delayed = Delayed(milliseconds: 700);

  Future<void> setFilterModel(BuildContext context, FilterModel? data,int categoryId) async {
    state = state.copyWith(filterModel: data);
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isLoading: true);
      final response = await _shopsRepository.getAllShops(1,
          filterModel: data, isOpen: data?.isOpen ?? true,categoryId: categoryId);
      response.when(
        success: (data) async {
          state = state.copyWith(
              isLoading: false, shopCount: data.meta?.total ?? 0);
        },
        failure: (activeFailure, status) {
          state = state.copyWith(isLoading: false);
          AppHelpers.showCheckTopSnackBar(
            context,
            activeFailure,
          );
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  void clear(BuildContext context,int categoryId) {
    state = state.copyWith(
        filterModel: FilterModel(),
        rangeValues: RangeValues(1, state.endPrice));
    setCheck(context,false,false,true,categoryId);
  }

  Future<void> setCheck(
      BuildContext context, bool check, bool deal, bool open,int categoryId) async {
    state.filterModel?.isFreeDelivery = check;
    state.filterModel?.isDeal = deal;
    state.filterModel?.isOpen = open;
    state = state.copyWith(freeDelivery: check, deals: deal, open: open);
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isLoading: true);
      final response =
          await _shopsRepository.getAllShops(1, filterModel: state.filterModel, isOpen: state.filterModel?.isOpen ?? true,categoryId: categoryId);
      response.when(
        success: (data) async {
          state = state.copyWith(
              isLoading: false, shopCount: data.meta?.total ?? 0);
        },
        failure: (activeFailure, status) {
          state = state.copyWith(isLoading: false);
          AppHelpers.showCheckTopSnackBar(
            context,
            activeFailure,
          );
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  void setRange(RangeValues values, BuildContext context,int categoryId) {
    state.filterModel?.price = [values.start, values.end];
    state = state.copyWith(
        rangeValues: RangeValues(values.start, values.end),
        filterModel: state.filterModel);
    _delayed.run(() {
      setCheck(context, state.freeDelivery, state.deals, state.open,categoryId);
    });
  }

  Future<void> init(BuildContext context,int categoryId) async {
    state = state.copyWith(filterModel: FilterModel(), isTagLoading: true);
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      final response = await _shopsRepository.getTags(categoryId);
      final res = await _shopsRepository.getSuggestPrice();
      response.when(
        success: (data) async {
          state = state.copyWith(
            tags: data.data ?? [],
          );
        },
        failure: (activeFailure, status) {
          state = state.copyWith(isTagLoading: false);
          AppHelpers.showCheckTopSnackBar(
            context,
            activeFailure,
          );
        },
      );
      res.when(
        success: (data) async {
          state = state.copyWith(
              isTagLoading: false,
              endPrice: data.data.max,
              startPrice: data.data.min,
              rangeValues: RangeValues(
                  data.data.min, data.data.max - data.data.max / 20),
              prices: List.generate(
                  (20).round(), (index) => (Random().nextInt(8) + 1)));
        },
        failure: (activeFailure, status) {
          state = state.copyWith(isTagLoading: false);
          AppHelpers.showCheckTopSnackBar(
            context,
            activeFailure,
          );
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<void> fetchRestaurant(BuildContext context,int categoryId) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(isRestaurantLoading: true);
      final response = await _shopsRepository.getAllShops(1,
          categoryId: categoryId, filterModel: state.filterModel,isOpen: state.filterModel?.isOpen ?? true);
      response.when(
        success: (data) async {
          state = state.copyWith(
              isRestaurantLoading: false, restaurant: data.data ?? [],shopCount: data.meta?.total ?? 0);
        },
        failure: (activeFailure, status) {
          state = state.copyWith(isRestaurantLoading: false);
          AppHelpers.showCheckTopSnackBar(
            context,
            activeFailure,
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
      BuildContext context, RefreshController shopController,int categoryId,
      {bool isRefresh = false}) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      if (isRefresh) {
        shopIndex = 1;
      }
      final response = await _shopsRepository.getAllShops(
          isRefresh ? 1 : ++shopIndex,
          categoryId: categoryId,
          filterModel: state.filterModel, isOpen: state.filterModel?.isOpen ?? true);
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
        failure: (activeFailure, status) {
          if (!isRefresh) {
            shopIndex--;
            shopController.loadFailed();
          } else {
            shopController.refreshFailed();
          }
          AppHelpers.showCheckTopSnackBar(
            context,
            activeFailure,
          );
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

}
