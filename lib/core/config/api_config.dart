/// API configuration. Override with `--dart-define=API_BASE_URL=http://...`
/// and `--dart-define=USE_MOCK_DATA=false` for live backend.
class ApiConfig {
  ApiConfig._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8000',
  );

  static const bool useMockData = bool.fromEnvironment(
    'USE_MOCK_DATA',
    defaultValue: false,
  );

  static String apiPath(String path) {
    final normalized = path.startsWith('/') ? path : '/$path';
    return '$baseUrl$normalized';
  }
}
