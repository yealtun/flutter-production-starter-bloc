/// Environment configuration loaded from --dart-define flags
class Env {
  /// Application environment (dev, stage, prod)
  static const String appEnv = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'dev',
  );

  /// Base URL for the main API
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://jsonplaceholder.typicode.com',
  );

  /// Base URL for AI API (optional)
  static const String aiBaseUrl = String.fromEnvironment(
    'AI_BASE_URL',
    defaultValue: 'https://api.example.com/ai',
  );

  /// Check if running in development environment
  static bool get isDev => appEnv == 'dev';

  /// Check if running in staging environment
  static bool get isStage => appEnv == 'stage';

  /// Check if running in production environment
  static bool get isProd => appEnv == 'prod';

  /// Check if debug mode is enabled
  static bool get isDebugMode => isDev;

  Env._();
}
