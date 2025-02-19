import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:foodyman/application/auto_order/auto_order_state.dart';
import 'package:foodyman/domain/di/dependency_manager.dart';
import 'package:foodyman/infrastructure/models/data/repeat_data.dart';
import 'package:foodyman/infrastructure/services/app_helpers.dart';
import 'package:foodyman/infrastructure/services/tr_keys.dart';

class AutoOrderNotifier extends StateNotifier<AutoOrderState> {
  AutoOrderNotifier()
      : super(AutoOrderState(
          from: DateTime.now().add(const Duration(days: 1)),
          to: DateTime.now().add(
            const Duration(days: 7),
          ),
        ));

  void pickFrom(DateTime date) {
    isValidDates();
    state = state.copyWith(from: date);
  }

  void pickTo(DateTime date) {
    isValidDates();

    state = state.copyWith(to: date);
  }

  bool isValidDates() {
    if (state.from.isBefore(state.to)) {
      state = state.copyWith(isError: false);
      return true;
    } else {
      state = state.copyWith(isError: true);
      return false;
    }
  }

  bool isTimeChanged(RepeatData? repeatData) {
    if (repeatData == null) {
      return true;
    }
    return (((DateTime.parse(repeatData.from ?? "")
                .difference(state.from)
                .inDays) !=
            0) ||
        ((DateTime.parse(repeatData.to ?? "").difference(state.to).inDays) !=
            0));
  }

  Future<void> startAutoOrder(
      {required int orderId,
      required BuildContext context,
      VoidCallback? onSuccess}) async {
    final res = await ordersRepository.createAutoOrder(
        DateFormat('yyyy-MM-dd').format(state.from),
        DateFormat('yyyy-MM-dd').format(state.to),
        orderId);

    res.when(
      success: (data) {
        onSuccess?.call();
        AppHelpers.showCheckTopSnackBarDone(context,
            AppHelpers.getTranslation(TrKeys.autoOrderCreatedSuccessfully));
        context.router.maybePop();
      },
      failure: (error, statusCode) {
        AppHelpers.showCheckTopSnackBar(
            context, AppHelpers.getTranslation(error));
      },
    );
  }

  Future<void> deleteAutoOrder(
      {required int orderId, required BuildContext context}) async {
    final res = await ordersRepository.deleteAutoOrder(orderId);

    res.when(
      success: (data) {
        AppHelpers.showCheckTopSnackBarDone(context,
            AppHelpers.getTranslation(TrKeys.autoOrderDeletedSuccessfully));
        context.router.maybePop();
      },
      failure: (error, statusCode) {
        AppHelpers.showCheckTopSnackBar(
            context, AppHelpers.getTranslation(error));
      },
    );
  }
}
