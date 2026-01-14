/// Subscription product model
class SubscriptionProduct {
  const SubscriptionProduct({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.currencyCode,
  });

  final String id;
  final String title;
  final String description;
  final double price;
  final String currencyCode;
}

/// Purchase result
enum PurchaseResult {
  success,
  cancelled,
  error,
  pending,
}

/// Subscription status
enum SubscriptionStatus {
  active,
  expired,
  cancelled,
  unknown,
}

/// Paywall service interface
/// This is a placeholder interface demonstrating paywall integration pattern
/// Real implementation would require in-app purchase SDK (RevenueCat, etc.)
abstract class PaywallService {
  /// Get available subscription products
  Future<List<SubscriptionProduct>> getProducts();

  /// Purchase a product
  Future<PurchaseResult> purchaseProduct(String productId);

  /// Restore previous purchases
  Future<void> restorePurchases();

  /// Get current subscription status stream
  Stream<SubscriptionStatus> get subscriptionStatus;

  /// Check if user has active subscription
  Future<bool> hasActiveSubscription();
}
