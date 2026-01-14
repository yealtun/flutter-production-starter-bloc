/// Analytics service interface
abstract class AnalyticsService {
  /// Track an event
  void trackEvent(String eventName, {Map<String, dynamic>? properties});

  /// Track a screen view
  void trackScreenView(String screenName);

  /// Set user properties
  void setUserProperties(Map<String, dynamic> properties);

  /// Set user ID
  void setUserId(String userId);
}
