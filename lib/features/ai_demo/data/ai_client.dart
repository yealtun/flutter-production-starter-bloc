import 'package:dio/dio.dart';
import '../../../core/config/env.dart';
import '../../../core/network/error/api_exception.dart';
import '../../../core/network/error/error_mapper.dart';

/// AI client wrapper for AI API calls
class AiClient {
  AiClient(this._dio);

  final Dio _dio;

  /// Make an AI API call with 429 rate limit handling
  Future<String> callAiApi(String prompt) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '${Env.aiBaseUrl}/chat',
        data: {'prompt': prompt},
      );

      return response.data?['response'] as String? ?? 'No response';
    } on DioException catch (e) {
      if (e.response?.statusCode == 429) {
        final error = mapDioError(e);
        if (error is RateLimitFailure && error.retryAfter != null) {
          throw RateLimitFailure(
            error.retryAfter,
            'Rate limit exceeded. Please retry after ${error.retryAfter!.inSeconds} seconds.',
          );
        }
        throw const RateLimitFailure(
          null,
          'Rate limit exceeded. Please try again later.',
        );
      }
      throw mapDioError(e);
    }
  }
}
