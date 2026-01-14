import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../config/env.dart';
import '../../logging/app_logger.dart';

/// Interceptor for logging HTTP requests and responses
/// Only logs in debug/dev mode and sanitizes PII
class LoggingInterceptor extends Interceptor {
  LoggingInterceptor(this._logger);

  final AppLogger _logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!Env.isDebugMode) {
      handler.next(options);
      return;
    }

    final requestId = options.headers['X-Request-Id'] as String? ?? 'unknown';
    _logger.d('→ ${options.method} ${options.uri}', requestId: requestId);

    if (options.data != null && kDebugMode) {
      final sanitizedData = _sanitizeData(options.data);
      _logger.d('Request body: $sanitizedData', requestId: requestId);
    }

    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (!Env.isDebugMode) {
      handler.next(response);
      return;
    }

    final requestId =
        response.requestOptions.headers['X-Request-Id'] as String? ?? 'unknown';
    _logger.d(
      '← ${response.statusCode} ${response.requestOptions.uri}',
      requestId: requestId,
    );

    if (response.data != null && kDebugMode) {
      final sanitizedData = _sanitizeData(response.data);
      _logger.d('Response body: $sanitizedData', requestId: requestId);
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (!Env.isDebugMode) {
      handler.next(err);
      return;
    }

    final requestId =
        err.requestOptions.headers['X-Request-Id'] as String? ?? 'unknown';
    _logger.e(
      '✗ ${err.response?.statusCode ?? 'ERROR'} ${err.requestOptions.uri}',
      requestId: requestId,
      error: err,
    );

    handler.next(err);
  }

  /// Sanitize data to remove PII (passwords, tokens, etc.)
  dynamic _sanitizeData(dynamic data) {
    if (data is Map<String, dynamic>) {
      final sanitized = <String, dynamic>{};
      for (final entry in data.entries) {
        final key = entry.key.toLowerCase();
        if (key.contains('password') ||
            key.contains('token') ||
            key.contains('secret') ||
            key.contains('auth')) {
          sanitized[entry.key] = '***REDACTED***';
        } else {
          sanitized[entry.key] = entry.value;
        }
      }
      return sanitized;
    }
    return data;
  }
}
