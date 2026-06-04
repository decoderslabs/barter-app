import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  ApiClient._();

  static final ApiClient instance = ApiClient._();

  late final Dio _dio;
  final _storage = const FlutterSecureStorage();

  static const String _baseUrl = 'http://localhost:8000/api';

  Dio get dio => _dio;

  void initialize() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      _authInterceptor(),
      _loggingInterceptor(),
    ]);
  }

  Interceptor _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'access_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // Token expired, try to refresh
          final refreshToken = await _storage.read(key: 'refresh_token');
          if (refreshToken != null) {
            try {
              final response = await Dio().post(
                '$_baseUrl/auth/token/refresh/',
                data: {'refresh': refreshToken},
              );
              final newToken = response.data['access'] as String;
              await _storage.write(key: 'access_token', value: newToken);

              // Retry original request
              error.requestOptions.headers['Authorization'] = 'Bearer $newToken';
              final retryResponse = await _dio.fetch(error.requestOptions);
              handler.resolve(retryResponse);
              return;
            } catch (e) {
              // Refresh failed, clear tokens
              await _storage.deleteAll();
            }
          }
        }
        handler.next(error);
      },
    );
  }

  Interceptor _loggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        if (kDebugMode) {
          debugPrint('[API] ${options.method} ${options.path}');
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        if (kDebugMode) {
          debugPrint('[API] ${response.statusCode} ${response.requestOptions.path}');
        }
        handler.next(response);
      },
      onError: (error, handler) {
        if (kDebugMode) {
          debugPrint('[API ERROR] ${error.response?.statusCode} ${error.message}');
        }
        handler.next(error);
      },
    );
  }

  Future<void> setTokens({required String access, required String refresh}) async {
    await _storage.write(key: 'access_token', value: access);
    await _storage.write(key: 'refresh_token', value: refresh);
  }

  Future<void> clearTokens() async {
    await _storage.deleteAll();
  }
}
