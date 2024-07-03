
import 'package:riverpodtemp/domain/handlers/api_result.dart';
import 'package:riverpodtemp/infrastructure/models/data/count_of_notifications_data.dart';
import 'package:riverpodtemp/infrastructure/models/response/notification_response.dart';

abstract class NotificationRepositoryFacade {

  Future<ApiResult<NotificationResponse>> getNotifications({
    int? page,
  });

  Future<ApiResult<NotificationResponse>> getAllNotifications();

  Future<ApiResult<dynamic>> readOne({
    int? id,
  });

  Future<ApiResult<NotificationResponse>> readAll();


  Future<ApiResult<CountNotificationModel>> getCount();
}
