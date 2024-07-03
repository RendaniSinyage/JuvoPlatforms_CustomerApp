import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:riverpodtemp/domain/iterface/parcel.dart';
import 'package:riverpodtemp/infrastructure/models/data/parcel_order.dart';
import '../../infrastructure/services/app_connectivity.dart';
import '../../infrastructure/services/app_helpers.dart';
import 'parcel_list_state.dart';

class ParcelListNotifier extends StateNotifier<ParcelListState> {
  final ParcelRepositoryFacade _parcelRepo;

  ParcelListNotifier(
    this._parcelRepo,
  ) : super(const ParcelListState());
  int activeOrder = 1;
  int historyOrder = 1;

  Future<void> fetchActiveOrdersPage(
      BuildContext context, RefreshController controller,
      {bool isRefresh = false}) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      if (isRefresh) {
        activeOrder = 1;
      }
      final response =
          await _parcelRepo.getActiveParcel(isRefresh ? 1 : ++activeOrder);
      response.when(
        success: (data) {
          if (isRefresh) {
            state = state.copyWith(
              activeOrders: data.data ?? [],
              totalActiveCount: data.meta?.total ?? 0,
            );
            controller.refreshCompleted();
          } else {
            if (data.data?.isNotEmpty ?? false) {
              List<ParcelOrder> list = List.from(state.activeOrders);
              list.addAll(data.data!);
              state = state.copyWith(
                activeOrders: list,
                totalActiveCount: data.meta?.total ?? 0,
              );
              controller.loadComplete();
            } else {
              activeOrder--;
              controller.loadNoData();
            }
          }
        },
        failure: (failure, status) {
          if (!isRefresh) {
            activeOrder--;
            controller.loadFailed();
          } else {
            controller.refreshFailed();
          }
          AppHelpers.showCheckTopSnackBar(
            context,
            AppHelpers.getTranslation(status.toString()),
          );
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<void> fetchHistoryOrdersPage(
      BuildContext context, RefreshController controller,
      {bool isRefresh = false}) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      if (isRefresh) {
        historyOrder = 1;
      }
      final response =
          await _parcelRepo.getHistoryParcel(isRefresh ? 1 : ++historyOrder);
      response.when(
        success: (data) {
          if (isRefresh) {
            state = state.copyWith(
              historyOrders: data.data ?? [],
            );
            controller.refreshCompleted();
          } else {
            if (data.data?.isNotEmpty ?? false) {
              List<ParcelOrder> list = List.from(state.historyOrders);
              list.addAll(data.data!);
              state = state.copyWith(
                historyOrders: list,
              );
              controller.loadComplete();
            } else {
              historyOrder--;
              controller.loadNoData();
            }
          }
        },
        failure: (failure, status) {
          if (!isRefresh) {
            historyOrder--;
            controller.loadFailed();
          } else {
            controller.refreshFailed();
          }
          AppHelpers.showCheckTopSnackBar(
            context,
            AppHelpers.getTranslation(status.toString()),
          );
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<void> fetchActiveOrders(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(
        isActiveLoading: true,
        activeOrders: [],
      );
      final response = await _parcelRepo.getActiveParcel(1);
      response.when(
        success: (data) {
          state = state.copyWith(
            activeOrders: data.data ?? [],
            isActiveLoading: false,
            totalActiveCount: data.meta?.total ?? 0,
          );
        },
        failure: (failure, status) {
          state = state.copyWith(
            isActiveLoading: false,
          );
          AppHelpers.showCheckTopSnackBar(
            context,
            AppHelpers.getTranslation(status.toString()),
          );
          debugPrint('==> get active orders failure: $failure');
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }

  Future<void> fetchHistoryOrders(BuildContext context) async {
    final connected = await AppConnectivity.connectivity();
    if (connected) {
      state = state.copyWith(
        historyOrders: [],
        isHistoryLoading: true,
      );
      final response = await _parcelRepo.getHistoryParcel(1);
      response.when(
        success: (data) {
          state = state.copyWith(
            historyOrders: data.data ?? [],
            isHistoryLoading: false,
          );
        },
        failure: (failure, status) {
          state = state.copyWith(isHistoryLoading: true);
          AppHelpers.showCheckTopSnackBar(
            context,
            AppHelpers.getTranslation(status.toString()),
          );
          debugPrint('==> get history orders failure: $failure');
        },
      );
    } else {
      if (context.mounted) {
        AppHelpers.showNoConnectionSnackBar(context);
      }
    }
  }
}
