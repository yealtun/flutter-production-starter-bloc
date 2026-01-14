import 'analytics_service.dart';
import '../logging/app_logger.dart';

/// Dummy implementation of [AnalyticsService] for development
class DummyAnalyticsService implements AnalyticsService {
  DummyAnalyticsService(this._logger);

  final AppLogger _logger;

  @override
  void trackEvent(String eventName, {Map<String, dynamic>? properties}) {
    // Dummy implementation - log to console
    _logger.d('Analytics: Event tracked - $eventName');
    if (properties != null) {
      _logger.d('Properties: $properties');
    }
  }

  @override
  void trackScreenView(String screenName) {
    _logger.d('Analytics: Screen viewed - $screenName');
  }

  @override
  void setUserProperties(Map<String, dynamic> properties) {
    _logger.d('Analytics: User properties set - $properties');
  }

  @override
  void setUserId(String userId) {
    _logger.d('Analytics: User ID set - $userId');
  }
}
