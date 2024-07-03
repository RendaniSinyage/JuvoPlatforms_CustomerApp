import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:riverpodtemp/domain/iterface/notification.dart';
import 'package:riverpodtemp/infrastructure/models/response/notification_response.dart';
import 'package:riverpodtemp/infrastructure/services/app_connectivity.dart';
import 'package:riverpodtemp/infrastructure/services/app_helpers.dart';

import 'notification_state.dart';

class NotificationNotifier extends StateNotifier<NotificationState> {
  final NotificationRepositoryFacade _notificationRepository;

  int _notificationPage = 0;

  NotificationNotifier(this._notificationRepository)
      : super(const NotificationState());

  Future<void> fetchAllNotifications(BuildContext context) async {
    state = state.copyWith(isAllNotificationsLoading: true);

    final response = await _notificationRepository.getNotifications();
    response.when(
      success: (data) {
        state = state.copyWith(
            isAllNotificationsLoading: false, notifications: data.data ?? []);
      },
      failure: (failure, s) {
        AppHelpers.showCheckTopSnackBar(context, failure.toString());
      },
    );
  }

  Future<void> fetchNotificationsPaginate(
      {VoidCallback? checkYourNetwork,
      RefreshController? refreshController,
      bool isRefresh = false}) async {
    final connected = await AppConnectivity.connectivity();
    if (isRefresh) {
      _notificationPage = 0;
    }
    if (connected) {
      final response = await _notificationRepository.getNotifications(
        page: ++_notificationPage,
      );
      response.when(
        success: (data) async {
          final List<NotificationModel> newList =
              List.from(state.notifications);
          newList.addAll(data.data ?? []);
          state = state.copyWith(
            notifications: isRefresh ? (data.data ?? []) : newList,
          );
          if (data.data?.isEmpty ?? true) {
            refreshController?.loadNoData();
          }
          if (isRefresh) {
            refreshController?.refreshCompleted();
          } else {
            refreshController?.loadComplete();
          }
        },
        failure: (failure, s) {
          debugPrint('==> get notifications more failure: $failure');
        },
      );
    } else {
      checkYourNetwork?.call();
    }
  }

  Future<void> readAll(BuildContext context) async {
    List<NotificationModel> notif = List.from(state.notifications);
    for (var i = 0; i < notif.length; i++) {
      if (notif[i].readAt == null) {
        notif[i] = notif[i].copyWith(readAt: DateTime.now());
      }
    }
    state = state.copyWith(
      notifications: notif,
      countOfNotifications:
          state.countOfNotifications?.copyWith(notification: 0),
    );

    final response = await _notificationRepository.readAll();
    response.when(
      success: (data) {},
      failure: (failure, s) {
        AppHelpers.showCheckTopSnackBar(context, failure.toString());
      },
    );
  }

  Future<void> readOne(BuildContext context,
      {int? id, required int index}) async {
    List<NotificationModel> notif = List.from(state.notifications);
    notif[index] = notif[index].copyWith(
      readAt: DateTime.now(),
    );
    final notification = state.countOfNotifications?.copyWith(
        notification: (state.countOfNotifications?.notification ?? 0) - 1);
    state = state.copyWith(
        notifications: notif, countOfNotifications: notification);
    final response = await _notificationRepository.readOne(id: id);
    response.when(
      success: (data) {},
      failure: (failure, s) {
        AppHelpers.showCheckTopSnackBar(context, failure.toString());
      },
    );
  }

  Future<void> fetchCount(BuildContext context) async {
    final response = await _notificationRepository.getCount();
    response.when(
      success: (data) {
        state = state.copyWith(countOfNotifications: data);
      },
      failure: (failure, s) {
        AppHelpers.showCheckTopSnackBar(context, failure.toString());
      },
    );
  }
}
