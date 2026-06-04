import 'package:dio/dio.dart';

import '../../core/auth/token_storage.dart';
import '../../core/config/api_config.dart';
import '../../core/network/api_exception.dart';
import '../../core/network/barter_api_client.dart';
import '../dto/user_dto.dart';

class AuthRepository {
  AuthRepository({
    BarterApiClient? client,
    TokenStorage? tokenStorage,
  })  : _client = client ?? BarterApiClient(),
        _tokens = tokenStorage ?? TokenStorage();

  final BarterApiClient _client;
  final TokenStorage _tokens;

  Future<bool> get isLoggedIn => _tokens.hasTokens;

  Future<UserDto> login({
    required String email,
    required String password,
  }) async {
    // WordPress JWT-Auth plugin uses a separate login URL and {username, password} body.
    // TODO(django-cutover): change back to POST /api/auth/login/ with {email, password}.
    try {
      final response = await Dio().post<dynamic>(
        ApiConfig.loginUrl,
        data: {'username': email, 'password': password},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      final data = response.data as Map<String, dynamic>;
      final token = data['token'] as String?;
      if (token == null) throw ApiException('Login failed: no token in response');
      // WP JWT has no separate refresh token — store the same token for both keys.
      await _tokens.saveTokens(access: token, refresh: token);
      return getMe();
    } on DioException catch (e) {
      final msg = (e.response?.data as Map?)?['message'] as String? ?? e.message ?? 'Login failed';
      throw ApiException(msg, statusCode: e.response?.statusCode);
    }
  }

  Future<UserDto> register({
    required String email,
    required String password,
    required String name,
    required String username,
    required String role,
  }) async {
    final data = await _client.postJson(
      '/register',
      body: {
        'email': email,
        'password': password,
        'password_confirm': password,
        'name': name,
        'username': username,
        'role': role,
      },
      auth: false,
    );
    final access = data['access_token'] as String?;
    final refresh = data['refresh_token'] as String?;
    if (access != null) {
      await _tokens.saveTokens(access: access, refresh: refresh ?? access);
      return getMe();
    }
    return login(email: email, password: password);
  }

  Future<UserDto> getMe() async {
    final data = await _client.getJson('/users/me');
    return UserDto.fromJson(data);
  }

  Future<void> logout() async {
    // WordPress has no server-side logout endpoint — just clear local tokens.
    // TODO(django-cutover): restore POST /api/auth/logout/ call here.
    await _tokens.clear();
  }

  Future<void> updateCreatorProfile({
    required List<String> niches,
    required List<String> contentTypes,
  }) async {
    // WordPress custom endpoint uses POST not PATCH.
    // TODO(django-cutover): change back to patchJson.
    await _client.postJson(
      '/users/me/creator-profile',
      body: {'niches': niches, 'content_types': contentTypes},
    );
  }

  Future<void> updateBrandProfile({
    required String companyName,
    required String website,
    String? industry,
  }) async {
    // WordPress custom endpoint uses POST not PATCH.
    // TODO(django-cutover): change back to patchJson.
    await _client.postJson(
      '/users/me/brand-profile',
      body: {
        'company_name': companyName,
        'website': website,
        if (industry != null) 'industry': industry,
      },
    );
  }

  Future<void> saveFcmToken(String token) async {
    await _client.postJson('/users/me/fcm-token', body: {'token': token});
  }

  Future<void> addSocialAccount(Map<String, dynamic> accountData) async {
    await _client.postJson('/users/me/social-accounts', body: accountData);
  }

  Future<String> getOAuthUrl(String platform) async {
    final data = await _client.getJson('/auth/oauth/$platform/url');
    return data['auth_url'] as String? ??
        data['url'] as String? ??
        data['authorization_url'] as String? ??
        '';
  }
}
