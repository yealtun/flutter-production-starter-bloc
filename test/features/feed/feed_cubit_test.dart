import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_production_starter_bloc/core/network/error/api_exception.dart';
import 'package:flutter_production_starter_bloc/core/utils/pagination.dart';
import 'package:flutter_production_starter_bloc/core/utils/result.dart';
import 'package:flutter_production_starter_bloc/features/feed/domain/entities/item.dart';
import 'package:flutter_production_starter_bloc/features/feed/domain/usecases/get_items_usecase.dart';
import 'package:flutter_production_starter_bloc/features/feed/presentation/cubit/feed_cubit.dart';
import 'package:flutter_production_starter_bloc/features/feed/presentation/cubit/feed_state.dart';

class MockGetItemsUseCase extends Mock implements GetItemsUseCase {}

void main() {
  late MockGetItemsUseCase mockGetItemsUseCase;
  late FeedCubit feedCubit;

  setUp(() {
    mockGetItemsUseCase = MockGetItemsUseCase();
    feedCubit = FeedCubit(mockGetItemsUseCase);
  });

  tearDown(() {
    feedCubit.close();
  });

  test('initial state should be loading', () {
    expect(feedCubit.state, const FeedState.loading());
  });

  blocTest<FeedCubit, FeedState>(
    'emits [loading, success] when items are loaded',
    build: () {
      when(() => mockGetItemsUseCase(page: any(named: 'page'), limit: any(named: 'limit')))
          .thenAnswer((_) async => const Success((
                [
                  Item(id: 1, title: 'Test', body: 'Body'),
                ],
                PaginationMeta(
                  page: 1,
                  limit: 10,
                  total: 1,
                  totalPages: 1,
                ),
              )));
      return feedCubit;
    },
    act: (cubit) => cubit.loadItems(),
    expect: () => [
      const FeedState.success(
        [Item(id: 1, title: 'Test', body: 'Body')],
        PaginationMeta(page: 1, limit: 10, total: 1, totalPages: 1),
      ),
    ],
  );

  blocTest<FeedCubit, FeedState>(
    'emits [loading, empty] when no items are returned',
    build: () {
      when(() => mockGetItemsUseCase(page: any(named: 'page'), limit: any(named: 'limit')))
          .thenAnswer((_) async => const Success((
                <Item>[],
                PaginationMeta(
                  page: 1,
                  limit: 10,
                  total: 0,
                  totalPages: 0,
                ),
              )));
      return feedCubit;
    },
    act: (cubit) => cubit.loadItems(),
    expect: () => [
      const FeedState.empty(),
    ],
  );

  blocTest<FeedCubit, FeedState>(
    'emits [loading, error] when loading fails',
    build: () {
      when(() => mockGetItemsUseCase(page: any(named: 'page'), limit: any(named: 'limit')))
          .thenAnswer((_) async => const Failure(NetworkFailure()));
      return feedCubit;
    },
    act: (cubit) => cubit.loadItems(),
    expect: () => [
      const FeedState.error(NetworkFailure()),
    ],
  );
}
