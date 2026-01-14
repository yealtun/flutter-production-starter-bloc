# API Client

## Overview

The API client is built on **Dio** with custom interceptors and comprehensive error handling.

## Dio Client Configuration

### Base Configuration

```dart
DioClient(
  baseUrl: Env.apiBaseUrl,
  connectTimeout: 30 seconds,
  receiveTimeout: 30 seconds,
  sendTimeout: 30 seconds,
)
```

### Default Headers

Every request includes:
- `X-Request-Id`: Unique request identifier (UUID)
- `X-App-Version`: App version from package info
- `X-Platform`: Operating system (android, ios, linux, etc.)
- `Content-Type`: application/json
- `Accept`: application/json

## Interceptors

### 1. Logging Interceptor

**Purpose**: Log HTTP requests and responses for debugging

**Features**:
- Only logs in debug/dev mode
- Sanitizes PII (passwords, tokens, secrets)
- Includes request-id in logs
- Logs request/response bodies (sanitized)

**Configuration**:
- Enabled when `Env.isDebugMode == true`
- Automatically disabled in production

### 2. Auth Interceptor

**Purpose**: Handle authentication tokens and token refresh

**Features**:
- Attaches access token to requests
- Handles 401 responses
- Automatic token refresh on 401
- Retries original request after refresh

**Flow**:
1. Check for stored access token
2. Attach token to `Authorization` header
3. On 401: Attempt token refresh
4. Retry original request with new token
5. If refresh fails: Continue with error

### 3. Retry Interceptor

**Purpose**: Retry failed requests with exponential backoff

**Features**:
- Only retries idempotent requests (GET)
- Exponential backoff with jitter
- Maximum 3 retry attempts
- Skips retry for 401, 403, 404

**Backoff Calculation**:
```
delay = baseDelay * 2^retryCount + jitter
baseDelay = 1000ms
jitter = random(0-500ms)
```

## Error Mapping

HTTP status codes are mapped to domain exceptions:

| Status Code | Exception Type |
|------------|----------------|
| 401 | `AuthFailure` |
| 403 | `PermissionFailure` |
| 404 | `NotFoundFailure` |
| 409 | `ConflictFailure` |
| 422 | `ValidationFailure` (with field errors) |
| 429 | `RateLimitFailure` (with retry-after) |
| 5xx | `ServerFailure` |
| Timeout | `NetworkFailure` |

### Validation Errors

422 responses include field-level errors:

```json
{
  "message": "Validation failed",
  "errors": {
    "email": ["Invalid email format"],
    "password": ["Password too short"]
  }
}
```

Mapped to `ValidationFailure` with `fieldErrors` map.

### Rate Limiting

429 responses may include `Retry-After` header:

```
Retry-After: 60
```

Mapped to `RateLimitFailure` with `retryAfter` duration.

## Usage Example

```dart
final dioClient = getIt<DioClient>();
final response = await dioClient.dio.get('/api/items');
```

## Best Practices

1. **Always use Result<T>**: Wrap API calls in Result for type-safe error handling
2. **Handle specific errors**: Use pattern matching for different error types
3. **Log errors**: Include request-id in error logs
4. **Respect rate limits**: Handle 429 responses appropriately
5. **Validate responses**: Check response structure before using data
