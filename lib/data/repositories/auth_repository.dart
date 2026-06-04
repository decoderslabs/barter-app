import '../../core/auth/token_storage.dart';
import '../../core/config/api_config.dart';
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

  Future<bool> get isLoggedIn async {
    if (ApiConfig.useMockData) return true;
    return _tokens.hasTokens;
  }

  Future<UserDto> login({
    required String email,
    required String password,
  }) async {
    final data = await _client.postJson(
      '/api/auth/login/',
      body: {'email': email, 'password': password},
      auth: false,
    );
    await _tokens.saveTokens(
      access: data['access'] as String,
      refresh: data['refresh'] as String,
    );
    return getMe();
  }

  Future<UserDto> register({
    required String email,
    required String password,
    required String name,
    required String username,
    required String role,
  }) async {
    await _client.postJson(
      '/api/auth/register/',
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
    return login(email: email, password: password);
  }

  Future<UserDto> getMe() async {
    final data = await _client.getJson('/api/users/me/');
    return UserDto.fromJson(data);
  }

  Future<void> logout() async {
    try {
      await _client.postJson('/api/auth/logout/');
    } catch (_) {}
    await _tokens.clear();
  }

  Future<void> updateCreatorProfile({
    required List<String> niches,
    required List<String> contentTypes,
  }) async {
    await _client.patchJson(
      '/api/users/me/creator-profile/',
      body: {'niches': niches, 'content_types': contentTypes},
    );
  }

  Future<void> updateBrandProfile({
    required String companyName,
    required String website,
    String? industry,
  }) async {
    await _client.patchJson(
      '/api/users/me/brand-profile/',
      body: {
        'company_name': companyName,
        'website': website,
        if (industry != null) 'industry': industry,
      },
    );
  }

  Future<String> getOAuthUrl(String platform) async {
    final data = await _client.getJson('/api/auth/oauth/$platform/url/');
    return data['auth_url'] as String? ??
        data['url'] as String? ??
        data['authorization_url'] as String? ??
        '';
  }
}
