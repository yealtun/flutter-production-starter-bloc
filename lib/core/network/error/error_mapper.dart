import 'package:dio/dio.dart';
import 'api_exception.dart';

/// Maps Dio exceptions to domain-specific failures
ApiException mapDioError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
      return const NetworkFailure('Connection timeout or error');

    case DioExceptionType.badResponse:
      return _mapStatusCode(
        error.response?.statusCode,
        error.response?.data,
        error,
      );

    case DioExceptionType.cancel:
      return const NetworkFailure('Request cancelled');

    case DioExceptionType.unknown:
    default:
      return const NetworkFailure('Unknown network error');
  }
}

ApiException _mapStatusCode(
  int? statusCode,
  dynamic data,
  DioException? error,
) {
  if (statusCode == null) {
    return const NetworkFailure('Unknown error');
  }

  final message = _extractMessage(data);
  final fieldErrors = _extractFieldErrors(data);

  switch (statusCode) {
    case 401:
      return AuthFailure(message);
    case 403:
      return PermissionFailure(message);
    case 404:
      return NotFoundFailure(message);
    case 409:
      return ConflictFailure(message);
    case 422:
      return ValidationFailure(fieldErrors, message);
    case 429:
      final retryAfter = _extractRetryAfter(error?.response?.headers);
      return RateLimitFailure(retryAfter, message);
    case 500:
    case 502:
    case 503:
    case 504:
      return ServerFailure(message);
    default:
      return NetworkFailure(message, statusCode);
  }
}

String _extractMessage(dynamic data) {
  if (data is Map<String, dynamic>) {
    return data['message'] as String? ??
        data['error'] as String? ??
        'An error occurred';
  }
  if (data is String) {
    return data;
  }
  return 'An error occurred';
}

Map<String, List<String>> _extractFieldErrors(dynamic data) {
  if (data is Map<String, dynamic>) {
    final errors = data['errors'] as Map<String, dynamic>?;
    if (errors != null) {
      return errors.map(
        (key, value) => MapEntry(
          key,
          value is List
              ? value.map((e) => e.toString()).toList()
              : [value.toString()],
        ),
      );
    }
  }
  return {};
}

Duration? _extractRetryAfter(Headers? headers) {
  if (headers != null) {
    final retryAfterHeader = headers.value('retry-after');
    if (retryAfterHeader != null) {
      final seconds = int.tryParse(retryAfterHeader);
      if (seconds != null) {
        return Duration(seconds: seconds);
      }
    }
  }
  return null;
}
