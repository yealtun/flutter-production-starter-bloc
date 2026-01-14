import '../../../core/logging/app_logger.dart';

/// SDK wrapper demonstrating SDK integration pattern
class SdkWrapper {
  SdkWrapper(this._logger);

  final AppLogger _logger;
  bool _isInitialized = false;

  /// Initialize the SDK
  Future<void> init() async {
    try {
      _logger.i('SDK: Initializing...');
      // Simulate SDK initialization
      await Future<void>.delayed(const Duration(milliseconds: 500));
      _isInitialized = true;
      _logger.i('SDK: Initialized successfully');
    } catch (e) {
      _logger.e('SDK: Initialization failed', error: e);
      rethrow;
    }
  }

  /// Track an event
  Future<void> trackEvent(
    String eventName, {
    Map<String, dynamic>? properties,
  }) async {
    if (!_isInitialized) {
      throw StateError('SDK not initialized. Call init() first.');
    }

    try {
      _logger.d('SDK: Tracking event: $eventName', requestId: eventName);
      // Simulate event tracking
      await Future<void>.delayed(const Duration(milliseconds: 100));
      _logger.d('SDK: Event tracked successfully: $eventName');
    } catch (e) {
      _logger.e('SDK: Failed to track event: $eventName', error: e);
      rethrow;
    }
  }

  /// Check if SDK is initialized
  bool get isInitialized => _isInitialized;
}
