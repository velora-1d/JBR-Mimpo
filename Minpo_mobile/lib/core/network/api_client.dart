import 'package:dio/dio.dart';
import 'api_interceptor.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late final Dio dio;

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.jbr-minpo.com/v1',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        contentType: 'application/json',
        validateStatus: (status) => status! < 500,
      ),
    );

    // Add Interceptors
    dio.interceptors.addAll([
      AuthInterceptor(),
      LogInterceptor(
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
      ),
      RetryInterceptor(dio: dio),
    ]);
  }
}
