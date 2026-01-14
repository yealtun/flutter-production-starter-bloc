import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_production_starter_bloc/core/network/error/api_exception.dart';
import 'package:flutter_production_starter_bloc/core/network/error/error_mapper.dart';

void main() {
  group('ErrorMapper', () {
    test('should map 401 to AuthFailure', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 401,
        ),
        type: DioExceptionType.badResponse,
      );

      final result = mapDioError(error);
      expect(result, isA<AuthFailure>());
      expect(result.statusCode, 401);
    });

    test('should map 403 to PermissionFailure', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 403,
        ),
        type: DioExceptionType.badResponse,
      );

      final result = mapDioError(error);
      expect(result, isA<PermissionFailure>());
      expect(result.statusCode, 403);
    });

    test('should map 404 to NotFoundFailure', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 404,
        ),
        type: DioExceptionType.badResponse,
      );

      final result = mapDioError(error);
      expect(result, isA<NotFoundFailure>());
      expect(result.statusCode, 404);
    });

    test('should map 422 to ValidationFailure', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 422,
          data: {
            'errors': {
              'email': ['Invalid email'],
            },
          },
        ),
        type: DioExceptionType.badResponse,
      );

      final result = mapDioError(error);
      expect(result, isA<ValidationFailure>());
      final validationError = result as ValidationFailure;
      expect(validationError.fieldErrors['email'], isNotNull);
    });

    test('should map 429 to RateLimitFailure', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 429,
          headers: Headers.fromMap({
            'retry-after': ['60'],
          }),
        ),
        type: DioExceptionType.badResponse,
      );

      final result = mapDioError(error);
      expect(result, isA<RateLimitFailure>());
      final rateLimitError = result as RateLimitFailure;
      expect(rateLimitError.retryAfter, isNotNull);
    });

    test('should map 500 to ServerFailure', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 500,
        ),
        type: DioExceptionType.badResponse,
      );

      final result = mapDioError(error);
      expect(result, isA<ServerFailure>());
      expect(result.statusCode, 500);
    });

    test('should map timeout to NetworkFailure', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionTimeout,
      );

      final result = mapDioError(error);
      expect(result, isA<NetworkFailure>());
    });
  });
}
