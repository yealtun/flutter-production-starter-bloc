/// Firebase service interface
/// This is a placeholder interface demonstrating Firebase integration pattern
/// Real implementation would require Firebase SDK and configuration files
abstract class FirebaseService {
  /// Initialize Firebase services
  Future<void> initialize();

  /// Log an analytics event
  Future<void> logEvent(String name, Map<String, dynamic> parameters);

  /// Set a user property
  Future<void> setUserProperty(String name, String value);

  /// Set user ID
  Future<void> setUserId(String userId);

  /// Log a crash
  Future<void> recordError(dynamic error, StackTrace? stackTrace);

  /// Set custom key for crash reporting
  Future<void> setCustomKey(String key, dynamic value);
}
