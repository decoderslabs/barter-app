/// API configuration. Override with `--dart-define=API_BASE_URL=http://...`
class ApiConfig {
  ApiConfig._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://bb.rootsofresin.com/wp-json/barter/v1',
  );

  // WordPress JWT login is at a different path from the main API base
  static const String loginUrl = String.fromEnvironment(
    'LOGIN_URL',
    defaultValue: 'https://bb.rootsofresin.com/wp-json/jwt-auth/v1/token',
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
