import 'dart:math';
import 'package:dio/dio.dart';

/// Maximum number of retry attempts
const _maxAttempts = 3;

/// Base delay in milliseconds
const _baseDelayMs = 1000;

/// Interceptor for retrying failed requests with exponential backoff
/// Only retries idempotent requests (GET)
class RetryInterceptor extends Interceptor {
  RetryInterceptor(this._dio);

  final Dio _dio;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Only retry GET requests (idempotent)
    if (err.requestOptions.method != 'GET') {
      handler.next(err);
      return;
    }

    // Don't retry if we've already retried
    final retryCount = err.requestOptions.extra['retryCount'] as int? ?? 0;
    if (retryCount >= _maxAttempts) {
      handler.next(err);
      return;
    }

    // Don't retry on certain status codes
    final statusCode = err.response?.statusCode;
    if (statusCode != null &&
        (statusCode == 401 || statusCode == 403 || statusCode == 404)) {
      handler.next(err);
      return;
    }

    // Calculate delay with exponential backoff and jitter
    final delay = _calculateDelay(retryCount);
    await Future<void>.delayed(delay);

    // Retry the request
    try {
      final opts = err.requestOptions;
      opts.extra['retryCount'] = retryCount + 1;
      final response = await _dio.fetch<dynamic>(opts);
      handler.resolve(response);
    } catch (e) {
      if (e is DioException) {
        handler.next(e);
      } else {
        handler.next(err);
      }
    }
  }

  /// Calculate delay with exponential backoff and jitter
  Duration _calculateDelay(int retryCount) {
    final exponentialDelay = _baseDelayMs * pow(2, retryCount);
    final jitter = Random().nextInt(500);
    final totalDelay = exponentialDelay + jitter;
    return Duration(milliseconds: totalDelay.toInt());
  }
}
