import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/item.dart';
import '../../domain/usecases/get_items_usecase.dart';
import '../../../../core/network/error/api_exception.dart';
import '../../../../core/utils/result.dart';
import 'feed_state.dart';

const _defaultPageSize = 10;

/// Cubit for managing feed state
class FeedCubit extends Cubit<FeedState> {
  FeedCubit(this._getItemsUseCase) : super(const FeedState.loading());

  final GetItemsUseCase _getItemsUseCase;
  int _currentPage = 1;
  final List<Item> _allItems = [];

  /// Load initial items
  Future<void> loadItems({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _allItems.clear();
      emit(const FeedState.loading());
    }

    final result = await _getItemsUseCase(
      page: _currentPage,
      limit: _defaultPageSize,
    );

    result.fold(
      onSuccess: (data) {
        final (items, meta) = data;
        if (refresh) {
          _allItems.clear();
        }
        _allItems.addAll(items);

        if (_allItems.isEmpty) {
          emit(const FeedState.empty());
        } else {
          _currentPage = meta.page;
          emit(FeedState.success(
            List.from(_allItems),
            meta,
          ));
        }
      },
      onFailure: (error) {
        final apiException = error is ApiException
            ? error
            : NetworkFailure(error.toString());
        emit(FeedState.error(apiException));
      },
    );
  }

  /// Load more items (pagination)
  Future<void> loadMore() async {
    final currentState = state;
    currentState.maybeWhen(
      success: (_, paginationMeta) {
        if (paginationMeta.hasNextPage) {
          _currentPage++;
          loadItems();
        }
      },
      orElse: () {},
    );
  }
}
