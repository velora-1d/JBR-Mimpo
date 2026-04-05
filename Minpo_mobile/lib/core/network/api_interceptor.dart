import 'dart:async';
import 'package:dio/dio.dart';
import '../services/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorageService _storage = SecureStorageService();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Handle Token Refresh here if needed
      // For now, redirect to login or clear token
    }
    return handler.next(err);
  }
}

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration retryInterval;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.retryInterval = const Duration(seconds: 2),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    var requestOptions = err.requestOptions;
    
    // Retry only on 5xx or connection issues
    bool shouldRetry = err.type != DioExceptionType.cancel &&
        (err.response == null || err.response!.statusCode! >= 500);

    if (shouldRetry && (requestOptions.extra['retry_count'] ?? 0) < maxRetries) {
      int retryCount = (requestOptions.extra['retry_count'] ?? 0) + 1;
      requestOptions.extra['retry_count'] = retryCount;

      await Future.delayed(retryInterval);
      
      try {
        final response = await dio.request(
          requestOptions.path,
          cancelToken: requestOptions.cancelToken,
          data: requestOptions.data,
          onReceiveProgress: requestOptions.onReceiveProgress,
          onSendProgress: requestOptions.onSendProgress,
          queryParameters: requestOptions.queryParameters,
          options: Options(
            method: requestOptions.method,
            headers: requestOptions.headers,
            extra: requestOptions.extra,
            contentType: requestOptions.contentType,
            responseType: requestOptions.responseType,
          ),
        );
        return handler.resolve(response);
      } catch (e) {
        return handler.next(err);
      }
    }
    return handler.next(err);
  }
}
