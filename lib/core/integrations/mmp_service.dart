/// Mobile Measurement Partner service interface
/// This is a placeholder interface demonstrating MMP integration pattern
/// Real implementation would require MMP SDK (AppsFlyer, Adjust, Branch, etc.)
abstract class MmpService {
  /// Initialize MMP SDK
  Future<void> initialize(String apiKey);

  /// Track an event
  Future<void> trackEvent(String eventName, {Map<String, dynamic>? properties});

  /// Set user attributes
  Future<void> setUserAttributes(Map<String, dynamic> attributes);

  /// Set user ID
  Future<void> setUserId(String userId);

  /// Track purchase event
  Future<void> trackPurchase({
    required double revenue,
    required String currency,
    Map<String, dynamic>? properties,
  });

  /// Get deep link data
  Future<Map<String, dynamic>?> getDeepLinkData();
}
