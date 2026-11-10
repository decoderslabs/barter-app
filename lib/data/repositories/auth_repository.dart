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
    final data = await _client.postJson(
      '/auth/login',
      body: {'email': email, 'password': password},
      auth: false,
    );
    final access = data['access_token'] as String?;
    final refresh = data['refresh_token'] as String?;
    if (access == null) throw ApiException('Login failed: no token in response');
    await _tokens.saveTokens(access: access, refresh: refresh ?? access);
    if (data['user'] != null) {
      return UserDto.fromJson(data['user'] as Map<String, dynamic>);
    }
    return getMe();
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
    if (access == null) throw ApiException('Registration failed: no token in response');
    await _tokens.saveTokens(access: access, refresh: refresh ?? access);
    if (data['user'] != null) {
      return UserDto.fromJson(data['user'] as Map<String, dynamic>);
    }
    return getMe();
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
    List<String>? niches,
    List<String>? contentTypes,
    List<String>? interests,
  }) async {
    final body = <String, dynamic>{};
    if (niches != null) body['niches'] = niches;
    if (contentTypes != null) body['content_types'] = contentTypes;
    if (interests != null) body['interests'] = interests;
    await _client.postJson(
      '/users/me/creator-profile',
      body: body,
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

  /// Update basic user profile information
  /// PATCH /users/me
  Future<void> updateProfile({
    String? name,
    String? bio,
    String? locationCity,
    String? locationCountry,
    String? profilePhotoUrl,
    String? coverPhotoUrl,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (bio != null) body['bio'] = bio;
    if (locationCity != null) body['location_city'] = locationCity;
    if (locationCountry != null) body['location_country'] = locationCountry;
    if (profilePhotoUrl != null) body['profile_photo_url'] = profilePhotoUrl;
    if (coverPhotoUrl != null) body['cover_photo_url'] = coverPhotoUrl;
    
    if (body.isNotEmpty) {
      await _client.patchJson('/users/me', body: body);
    }
  }

  Future<void> addSocialAccount(Map<String, dynamic> accountData) async {
    await _client.postJson('/users/me/social-accounts', body: accountData);
  }

  /// Remove a connected social account
  /// DELETE /users/me/social-accounts/{platform}
  Future<void> removeSocialAccount(String platform) async {
    await _client.delete('/users/me/social-accounts/$platform');
  }

  /// Verify social account ownership via verification code
  /// POST /users/me/social-accounts/{platform}/verify
  Future<bool> verifySocialAccount(String platform, {String? verificationCode}) async {
    final data = await _client.postJson(
      '/users/me/social-accounts/$platform/verify',
      body: verificationCode != null ? {'code': verificationCode} : {},
    );
    return data['verified'] as bool? ?? false;
  }

  /// Get OAuth URL for social platform connection
  Future<String> getOAuthUrl(String platform) async {
    final data = await _client.getJson('/auth/oauth/$platform/url');
    return data['auth_url'] as String? ??
        data['url'] as String? ??
        data['authorization_url'] as String? ??
        '';
  }

  /// GET /users/me/profile-stats — barter score, deals history, completion
  Future<Map<String, dynamic>> getProfileStats() async {
    return _client.getJson('/users/me/profile-stats');
  }

  /// GET /users/me/deals-history — paginated
  Future<Map<String, dynamic>> getDealsHistory({int page = 1, int perPage = 10}) async {
    return _client.getJson(
      '/users/me/deals-history',
      queryParameters: {'page': page, 'per_page': perPage},
    );
  }
}
