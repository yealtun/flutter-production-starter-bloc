# Optional Integrations

## Overview

This document describes integration patterns for optional services like Firebase, Paywall, MMP, and AI APIs. These are provided as interfaces and documentation only - no real implementations or keys are included.

## Firebase

### Interface

```dart
abstract class FirebaseService {
  Future<void> initialize();
  Future<void> logEvent(String name, Map<String, dynamic> parameters);
  Future<void> setUserProperty(String name, String value);
  Future<void> setUserId(String userId);
}
```

### Integration Approach

1. Add Firebase dependencies to `pubspec.yaml`
2. Add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
3. Initialize Firebase in `main.dart`
4. Implement `FirebaseService` interface
5. Register in DI container

### Documentation

- Firebase Analytics: User behavior tracking
- Firebase Crashlytics: Crash reporting
- Firebase Remote Config: Feature flags
- Firebase Cloud Messaging: Push notifications

## Paywall

### Interface

```dart
abstract class PaywallService {
  Future<List<SubscriptionProduct>> getProducts();
  Future<PurchaseResult> purchaseProduct(String productId);
  Future<void> restorePurchases();
  Stream<SubscriptionStatus> get subscriptionStatus;
}
```

### Integration Approach

1. Set up in-app purchases in App Store Connect / Play Console
2. Add revenue_cat or in_app_purchase package
3. Implement `PaywallService` interface
4. Register in DI container
5. Handle purchase flow in UI

### Documentation

- Product configuration
- Purchase flow
- Receipt validation
- Subscription management
- Restore purchases

## MMP (Mobile Measurement Partner)

### Interface

```dart
abstract class MmpService {
  Future<void> initialize(String apiKey);
  Future<void> trackEvent(String eventName, Map<String, dynamic> properties);
  Future<void> setUserAttributes(Map<String, dynamic> attributes);
  Future<void> setUserId(String userId);
}
```

### Integration Approach

1. Choose MMP provider (AppsFlyer, Adjust, Branch, etc.)
2. Add SDK dependency
3. Implement `MmpService` interface
4. Register in DI container
5. Track key events (install, purchase, etc.)

### Documentation

- Attribution tracking
- Deep linking
- Campaign measurement
- User acquisition analytics

## AI API

### Interface

```dart
abstract class AiService {
  Future<String> generateText(String prompt);
  Future<List<String>> generateImages(String prompt);
  Future<AiResponse> chat(List<ChatMessage> messages);
}
```

### Integration Approach

1. Choose AI provider (OpenAI, Anthropic, etc.)
2. Add HTTP client wrapper
3. Implement `AiService` interface
4. Handle rate limiting (429 errors)
5. Register in DI container

### Documentation

- API authentication
- Rate limiting handling
- Error handling
- Response parsing
- Cost optimization

## Implementation Notes

### No Real Keys

- All integrations are interface-only
- No actual API keys or credentials
- Documentation shows integration pattern
- Real implementation requires actual keys

### Abstraction Benefits

- Easy to swap implementations
- Testable with mocks
- Environment-specific implementations
- Gradual rollout capability

## Best Practices

1. **Abstract Interfaces**: Define clear interfaces
2. **Dependency Injection**: Register in DI container
3. **Error Handling**: Handle service-specific errors
4. **Feature Flags**: Control via feature flags
5. **Environment-Specific**: Different implementations per environment
