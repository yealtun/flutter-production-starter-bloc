import 'package:dio/dio.dart';
import '../../storage/local_storage.dart';

/// Storage key for access token
const _accessTokenKey = 'access_token';
const _refreshTokenKey = 'refresh_token';

/// Interceptor for attaching authentication tokens and handling 401 responses
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._storage, this._dio);

  final LocalStorage _storage;
  final Dio _dio;
  bool _isRefreshing = false;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.getString(_accessTokenKey);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;
      try {
        final refreshed = await _refreshToken(err.requestOptions);
        if (refreshed) {
          // Retry the original request
          final opts = err.requestOptions;
          final token = await _storage.getString(_accessTokenKey);
          if (token != null) {
            opts.headers['Authorization'] = 'Bearer $token';
          }
          final response = await _dio.fetch<dynamic>(opts);
          handler.resolve(response);
          return;
        }
      } catch (e) {
        // Refresh failed, continue with error
      } finally {
        _isRefreshing = false;
      }
    }
    handler.next(err);
  }

  /// Attempt to refresh the access token
  /// Returns true if refresh was successful
  Future<bool> _refreshToken(RequestOptions originalRequest) async {
    try {
      final refreshToken = await _storage.getString(_refreshTokenKey);
      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }

      // TODO: Implement actual refresh token API call
      // For now, this is a placeholder
      // In a real implementation, you would:
      // 1. Call your refresh token endpoint
      // 2. Save the new access token
      // 3. Return true if successful

      return false;
    } catch (e) {
      return false;
    }
  }
}
