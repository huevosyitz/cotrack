import 'package:cotrack/core/services/auth_service.dart';
import 'package:dio/dio.dart';

class AuthenticationHeaderInterceptor extends Interceptor {
  final AuthService _authService;

  AuthenticationHeaderInterceptor({required AuthService authService})
      : _authService = authService;

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _authService.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return super.onRequest(options, handler);
  }
}

class JsonContentTypeHeaderInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers['content-type'] = 'application/json';
    return super.onRequest(options, handler);
  }
}
