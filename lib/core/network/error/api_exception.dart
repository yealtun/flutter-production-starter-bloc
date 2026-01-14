/// Base class for all API-related exceptions
abstract class ApiException implements Exception {
  const ApiException(this.message, this.statusCode);
  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

/// Authentication failure (401)
class AuthFailure extends ApiException {
  const AuthFailure([
    super.message = 'Authentication failed',
    super.statusCode = 401,
  ]);
}

/// Permission failure (403)
class PermissionFailure extends ApiException {
  const PermissionFailure([
    super.message = 'Permission denied',
    super.statusCode = 403,
  ]);
}

/// Not found failure (404)
class NotFoundFailure extends ApiException {
  const NotFoundFailure([
    super.message = 'Resource not found',
    super.statusCode = 404,
  ]);
}

/// Conflict failure (409)
class ConflictFailure extends ApiException {
  const ConflictFailure([
    super.message = 'Resource conflict',
    super.statusCode = 409,
  ]);
}

/// Validation failure (422)
class ValidationFailure extends ApiException {
  const ValidationFailure(
    this.fieldErrors, [
    super.message = 'Validation failed',
    super.statusCode = 422,
  ]);
  final Map<String, List<String>> fieldErrors;
}

/// Rate limit failure (429)
class RateLimitFailure extends ApiException {
  const RateLimitFailure(
    this.retryAfter, [
    super.message = 'Rate limit exceeded',
    super.statusCode = 429,
  ]);
  final Duration? retryAfter;
}

/// Server failure (5xx)
class ServerFailure extends ApiException {
  const ServerFailure([super.message = 'Server error', super.statusCode = 500]);
}

/// Network failure (timeout, socket errors, etc.)
class NetworkFailure extends ApiException {
  const NetworkFailure([super.message = 'Network error', super.statusCode]);
}
