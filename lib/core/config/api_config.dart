/// API configuration. Override with `--dart-define=API_BASE_URL=http://...`
class ApiConfig {
  ApiConfig._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://backend-barter.local/wp-json/barter/v1',
  );

  // WordPress JWT login is at a different path from the main API base
  static const String loginUrl = String.fromEnvironment(
    'LOGIN_URL',
    defaultValue: 'http://backend-barter.local/wp-json/jwt-auth/v1/token',
  );

  // Community WhatsApp invite URL
  static const String communityWhatsAppUrl = String.fromEnvironment(
    'COMMUNITY_WHATSAPP_URL',
    defaultValue: 'https://chat.whatsapp.com/BarterCreatorClub',
  );

  static String apiPath(String path) {
    final normalized = path.startsWith('/') ? path : '/$path';
    return '$baseUrl$normalized';
  }
}
