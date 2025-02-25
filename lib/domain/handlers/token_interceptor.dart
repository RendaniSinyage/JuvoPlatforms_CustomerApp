import 'package:dio/dio.dart';
import 'package:foodyman/infrastructure/services/local_storage.dart';

class TokenInterceptor extends Interceptor {
  final bool requireAuth;

  TokenInterceptor({required this.requireAuth});

  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    // Always add the mobile client header
    options.headers.addAll({'X-Client-Type': 'mobile'});

    // Add authentication token if needed
    final String token = LocalStorage.getToken();
    if (token.isNotEmpty && requireAuth) {
      options.headers.addAll({'Authorization': 'Bearer  $token'});
    }

    handler.next(options);
  }
}