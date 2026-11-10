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

  Future<Map<String, dynamic>> uploadFile(
    String path, {
    required List<int> bytes,
    required String filename,
    String fieldName = 'file',
    bool auth = true,
  }) async {
    final formData = FormData.fromMap({
      fieldName: MultipartFile.fromBytes(bytes, filename: filename),
    });
    final response = await _dio.post<dynamic>(
      path,
      data: formData,
      options: Options(
        extra: {'auth': auth},
        headers: {'Content-Type': 'multipart/form-data'},
      ),
    );
    return _asMap(response.data);
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
      await _tokenStorage.clear();
      throw ApiException('Session expired. Please sign in again.', statusCode: 401);
    }
    try {
      final response = await Dio().post<dynamic>(
        '${ApiConfig.baseUrl}/auth/refresh',
        data: {'refresh_token': refresh},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      final data = response.data as Map<String, dynamic>;
      final access = data['access_token'] as String?;
      final newRefresh = data['refresh_token'] as String?;
      if (access == null) {
        await _tokenStorage.clear();
        throw ApiException('Session expired. Please sign in again.', statusCode: 401);
      }
      await _tokenStorage.saveTokens(
        access: access,
        refresh: newRefresh ?? refresh,
      );
    } on DioException catch (_) {
      await _tokenStorage.clear();
      throw ApiException('Session expired. Please sign in again.', statusCode: 401);
    }
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
    final statusCode = err.response?.statusCode;
    String message = err.message ?? 'Request failed';
    String? errorCode;

    if (data is Map) {
      // WP REST API error shape: { "code": "profile_incomplete", "message": "...", "data": {...} }
      if (data['code'] != null) {
        errorCode = data['code'].toString();
        message = data['message']?.toString() ?? message;
      } else if (data['detail'] != null) {
        message = data['detail'].toString();
      } else if ((data as Map).isNotEmpty) {
        message = data.entries.map((e) => '${e.key}: ${e.value}').join(', ');
      }
    }

    return DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: ApiException(
        message,
        statusCode: statusCode,
        details: data,
        errorCode: errorCode,
      ),
    );
  }
}
