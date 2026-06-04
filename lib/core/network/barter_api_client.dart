import 'package:dio/dio.dart';

import '../auth/token_storage.dart';
import '../config/api_config.dart';
import 'api_exception.dart';

class BarterApiClient {
  BarterApiClient({
    TokenStorage? tokenStorage,
    Dio? dio,
  })  : _tokenStorage = tokenStorage ?? TokenStorage(),
        _dio = dio ?? Dio() {
    _dio.options = BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    );
    _dio.interceptors.add(_AuthInterceptor(_tokenStorage, _dio, _refreshTokens));
  }

  final TokenStorage _tokenStorage;
  final Dio _dio;

  Dio get dio => _dio;

  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool auth = true,
  }) async {
    final response = await _dio.get<dynamic>(
      path,
      queryParameters: queryParameters,
      options: Options(extra: {'auth': auth}),
    );
    return _asMap(response.data);
  }

  Future<List<dynamic>> getJsonList(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool auth = true,
  }) async {
    final response = await _dio.get<dynamic>(
      path,
      queryParameters: queryParameters,
      options: Options(extra: {'auth': auth}),
    );
    final data = response.data;
    if (data is List) return data;
    return _parsePaginatedResults(data);
  }

  Future<Map<String, dynamic>> postJson(
    String path, {
    Map<String, dynamic>? body,
    bool auth = true,
  }) async {
    final response = await _dio.post<dynamic>(
      path,
      data: body,
      options: Options(extra: {'auth': auth}),
    );
    return _asMap(response.data);
  }

  Future<Map<String, dynamic>> patchJson(
    String path, {
    Map<String, dynamic>? body,
    bool auth = true,
  }) async {
    final response = await _dio.patch<dynamic>(
      path,
      data: body,
      options: Options(extra: {'auth': auth}),
    );
    return _asMap(response.data);
  }

  Future<Map<String, dynamic>> putJson(
    String path, {
    Map<String, dynamic>? body,
    bool auth = true,
  }) async {
    final response = await _dio.put<dynamic>(
      path,
      data: body,
      options: Options(extra: {'auth': auth}),
    );
    return _asMap(response.data);
  }

  Future<void> delete(String path, {bool auth = true}) async {
    await _dio.delete<dynamic>(
      path,
      options: Options(extra: {'auth': auth}),
    );
  }

  List<dynamic> _parsePaginatedResults(dynamic data) {
    if (data is Map<String, dynamic> && data['results'] is List) {
      return data['results'] as List<dynamic>;
    }
    throw ApiException('Expected paginated list response');
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data == null) return {};
    throw ApiException('Expected JSON object response');
  }

  Future<void> _refreshTokens() async {
    final refresh = await _tokenStorage.refreshToken;
    if (refresh == null || refresh.isEmpty) {
      throw ApiException('No refresh token');
    }
    final response = await Dio(BaseOptions(baseUrl: ApiConfig.baseUrl)).post<dynamic>(
      '/api/auth/token/refresh/',
      data: {'refresh': refresh},
    );
    final data = response.data as Map<String, dynamic>;
    final access = data['access'] as String?;
    if (access == null) throw ApiException('Refresh failed');
    final newRefresh = data['refresh'] as String? ?? refresh;
    await _tokenStorage.saveTokens(access: access, refresh: newRefresh);
  }
}

class _AuthInterceptor extends Interceptor {
  _AuthInterceptor(this._storage, this._dio, this._refresh);

  final TokenStorage _storage;
  final Dio _dio;
  final Future<void> Function() _refresh;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final needsAuth = options.extra['auth'] != false;
    if (needsAuth) {
      final token = await _storage.accessToken;
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 &&
        err.requestOptions.extra['auth'] != false &&
        err.requestOptions.extra['retried'] != true) {
      try {
        await _refresh();
        final token = await _storage.accessToken;
        final opts = err.requestOptions;
        opts.extra['retried'] = true;
        opts.headers['Authorization'] = 'Bearer $token';
        final response = await _dio.fetch(opts);
        handler.resolve(response);
        return;
      } catch (_) {
        await _storage.clear();
      }
    }
    handler.next(_wrapError(err));
  }

  DioException _wrapError(DioException err) {
    final data = err.response?.data;
    String message = err.message ?? 'Request failed';
    if (data is Map) {
      if (data['detail'] != null) {
        message = data['detail'].toString();
      } else if (data.isNotEmpty) {
        message = data.entries.map((e) => '${e.key}: ${e.value}').join(', ');
      }
    }
    return DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: ApiException(message, statusCode: err.response?.statusCode, details: data),
    );
  }
}
