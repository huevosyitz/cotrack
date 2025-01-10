import 'package:cotrack/config/app_config.dart';
import 'package:cotrack/core/services/authentication_header_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:watch_it/watch_it.dart';

final httpClient = getDio();

// Global options
final dioCacheOptions = CacheOptions(
  // A default store is required for interceptor.
  store: MemCacheStore(),

  // All subsequent fields are optional.

  // Default.
  policy: CachePolicy.forceCache,
  // Returns a cached response on error but for statuses 401 & 403.
  // Also allows to return a cached response on network errors (e.g. offline usage).
  // Defaults to [null].
  hitCacheOnErrorExcept: [401, 403],
  // Overrides any HTTP directive to delete entry past this duration.
  // Useful only when origin server has no cache config or custom behaviour is desired.
  // Defaults to [null].
  maxStale: const Duration(minutes: 30),
  // Default. Allows 3 cache sets and ease cleanup.
  priority: CachePriority.normal,
  // Default. Body and headers encryption with your own algorithm.
  cipher: null,
  // Default. Key builder to retrieve requests.
  keyBuilder: CacheOptions.defaultCacheKeyBuilder,
  // Default. Allows to cache POST requests.
  // Overriding [keyBuilder] is strongly recommended when [true].
  allowPostMethod: false,
);

Dio getDio() {
  var dio = Dio(BaseOptions(
      validateStatus: (int? status) {
        return status == null ||
            (status >= 200 && status < 300 || status == 304);
      },
      baseUrl: AppConfig.API_BASEURL,
      contentType: "application/json"));
  // dio.interceptors.add(PrettyDioLogger());
  dio.interceptors.add(AuthenticationHeaderInterceptor(authService: di.get()));
  dio.interceptors.add(DioCacheInterceptor(options: dioCacheOptions));
  dio.interceptors.add(JsonContentTypeHeaderInterceptor());

  return dio;
}

extension DioHelper on Dio {
  Future<Response<T>> getRequest<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    bool forceRefresh = false,
  }) {
    var cacheOptions = dioCacheOptions.copyWith(
        policy: forceRefresh
            ? CachePolicy.refreshForceCache
            : dioCacheOptions.policy);

    var finalOptions = cacheOptions.toOptions();
    if (options?.extra != null) {
      options?.extra?.addAll(cacheOptions.toExtra());
      finalOptions = options!;
    }

    return get<T>(path,
        data: data,
        queryParameters: queryParameters,
        options: finalOptions,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress);
  }
}
