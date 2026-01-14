import 'dart:io';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../config/env.dart';
import '../logging/app_logger.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/retry_interceptor.dart';
import '../storage/local_storage.dart';

/// Dio HTTP client with interceptors and default configuration
class DioClient {
  DioClient({required LocalStorage storage, required AppLogger logger})
    : _storage = storage,
      _logger = logger {
    _dio = Dio(
      BaseOptions(
        baseUrl: Env.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: _getDefaultHeaders(),
      ),
    );

    _setupInterceptors();
    _setupAsyncHeaders();
  }

  final LocalStorage _storage;
  final AppLogger _logger;
  late final Dio _dio;

  Dio get dio => _dio;

  /// Get default headers including X-Request-Id, X-App-Version, X-Platform
  Map<String, String> _getDefaultHeaders() {
    return <String, String>{
      'X-Request-Id': _generateRequestId(),
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-Platform': Platform.operatingSystem,
    };
  }

  /// Setup async headers after Dio is initialized
  void _setupAsyncHeaders() {
    _getAppVersion().then((version) {
      _dio.options.headers['X-App-Version'] = version;
    });
  }

  /// Generate a unique request ID
  String _generateRequestId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        DateTime.now().microsecond.toString();
  }

  /// Get app version from package info
  Future<String> _getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return '${packageInfo.version}+${packageInfo.buildNumber}';
    } catch (e) {
      return 'unknown';
    }
  }

  /// Setup interceptors
  void _setupInterceptors() {
    _dio.interceptors.addAll([
      LoggingInterceptor(_logger),
      AuthInterceptor(_storage, _dio),
      RetryInterceptor(_dio),
    ]);
  }
}
