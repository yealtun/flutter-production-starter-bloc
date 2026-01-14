# Observability

## Overview

Observability in this project includes logging, analytics, crash reporting, and alerting concepts.

## Logging

### AppLogger

The `AppLogger` wrapper provides structured logging with levels:

```dart
logger.d('Debug message', requestId: 'req-123');
logger.i('Info message', requestId: 'req-123');
logger.w('Warning message', requestId: 'req-123');
logger.e('Error message', requestId: 'req-123', error: exception);
logger.f('Fatal message', requestId: 'req-123', error: exception);
```

### Request ID

Every request includes a unique request ID:
- Generated per request
- Included in logs
- Helps trace requests across services

### Log Levels

- **Debug**: Development-only detailed logs
- **Info**: General information
- **Warning**: Potential issues
- **Error**: Errors that don't crash the app
- **Fatal**: Critical errors

### PII Sanitization

Logs automatically sanitize PII:
- Passwords
- Tokens
- Secrets
- Auth headers

## Analytics

### AnalyticsService Interface

Abstract interface for analytics:

```dart
abstract class AnalyticsService {
  void trackEvent(String eventName, {Map<String, dynamic>? properties});
  void trackScreenView(String screenName);
  void setUserProperties(Map<String, dynamic> properties);
  void setUserId(String userId);
}
```

### Implementation

- **Development**: `DummyAnalyticsService` (prints to console)
- **Production**: Replace with real analytics service (Firebase, Mixpanel, etc.)

### Usage

```dart
final analytics = getIt<AnalyticsService>();
analytics.trackEvent('button_clicked', properties: {'screen': 'feed'});
analytics.trackScreenView('feed_screen');
```

## Crash Reporting

### Integration Approach

Crash reporting should be:
- Behind environment flag
- Optional (can be disabled)
- Abstracted via interface

### Example Structure

```dart
abstract class CrashReportingService {
  void recordError(dynamic error, StackTrace? stackTrace);
  void setUserId(String userId);
  void setCustomKey(String key, dynamic value);
}
```

### Firebase Crashlytics Example

```dart
class CrashlyticsService implements CrashReportingService {
  @override
  void recordError(dynamic error, StackTrace? stackTrace) {
    if (Env.isProd) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    }
  }
}
```

### Implementation Notes

- Crash reporting is optional and behind environment flag
- Use `FirebaseService` interface (see `core/integrations/firebase_service.dart`)
- Initialize only in production environment
- Abstract implementation allows easy swapping of crash reporting providers

## Alerting Concepts

### Crash Spike

Monitor crash rate:
- Baseline: Normal crash rate
- Alert: Spike above threshold (e.g., 2x baseline)
- Action: Investigate recent releases/changes

### 5xx Spike

Monitor server errors:
- Track 5xx response rate
- Alert on sudden increase
- Correlate with deployment times

### Latency Spike

Monitor API response times:
- Track p50, p95, p99 latencies
- Alert on significant increase
- Check for infrastructure issues

## Best Practices

1. **Structured Logging**: Use consistent log format
2. **Request Tracing**: Include request-id in all logs
3. **Error Context**: Log errors with full context
4. **Performance Monitoring**: Track key metrics
5. **User Privacy**: Never log PII
6. **Alert Thresholds**: Set appropriate alert levels

## Monitoring Dashboard

Key metrics to monitor:
- Crash rate
- API error rate (by status code)
- API latency (p50, p95, p99)
- User session duration
- Feature usage
- Error trends over time
