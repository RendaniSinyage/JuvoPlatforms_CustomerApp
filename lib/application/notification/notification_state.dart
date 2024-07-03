import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpodtemp/infrastructure/models/data/count_of_notifications_data.dart';
import 'package:riverpodtemp/infrastructure/models/response/notification_response.dart';

part 'notification_state.freezed.dart';

@freezed
class NotificationState with _$NotificationState {
  const factory NotificationState({
    @Default([]) List<NotificationModel> notifications,
    @Default(null) CountNotificationModel? countOfNotifications,
    @Default(false) bool isReadAllLoading,
    @Default(false) bool isAllNotificationsLoading,
  }) = _NotificationState;

  const NotificationState._();
}
