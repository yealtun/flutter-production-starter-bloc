import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_production_starter_bloc/core/network/error/api_exception.dart';
import 'package:flutter_production_starter_bloc/core/utils/pagination.dart';
import 'package:flutter_production_starter_bloc/core/utils/result.dart';
import 'package:flutter_production_starter_bloc/features/feed/data/datasources/feed_remote_ds.dart';
import 'package:flutter_production_starter_bloc/features/feed/data/repositories/feed_repo_impl.dart';
import 'package:flutter_production_starter_bloc/features/feed/domain/entities/item.dart';

class MockFeedRemoteDataSource extends Mock implements FeedRemoteDataSource {}
class MockDio extends Mock implements Dio {}

void main() {
  late MockFeedRemoteDataSource mockRemoteDataSource;
  late MockDio mockDio;
  late FeedRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockFeedRemoteDataSource();
    mockDio = MockDio();
    repository = FeedRepositoryImpl(mockRemoteDataSource, mockDio);
  });

  group('getItems', () {
    test('should return items with pagination metadata on success', () async {
      when(() => mockRemoteDataSource.getItems(page: 1, limit: 10))
          .thenAnswer((_) async => []);

      final result = await repository.getItems(page: 1, limit: 10);

      result.fold(
        onSuccess: (data) {
          final (items, meta) = data;
          expect(items, isA<List<Item>>());
          expect(meta, isA<PaginationMeta>());
        },
        onFailure: (error) => fail('Expected success but got failure: $error'),
      );
    });

    test('should return failure on error', () async {
      when(() => mockRemoteDataSource.getItems(page: 1, limit: 10))
          .thenThrow(DioException(
            requestOptions: RequestOptions(path: '/test'),
            type: DioExceptionType.connectionTimeout,
          ));

      final result = await repository.getItems(page: 1, limit: 10);

      result.fold(
        onSuccess: (_) => fail('Expected failure but got success'),
        onFailure: (error) => expect(error, isA<NetworkFailure>()),
      );
    });
  });
}
