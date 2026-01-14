import '../../../../core/utils/pagination.dart';
import '../../../../core/utils/result.dart';
import '../entities/item.dart';
import '../repositories/feed_repo.dart';

/// Use case for getting feed items
class GetItemsUseCase {
  GetItemsUseCase(this._repository);

  final FeedRepository _repository;

  Future<Result<(List<Item>, PaginationMeta)>> call({
    required int page,
    required int limit,
  }) {
    return _repository.getItems(page: page, limit: limit);
  }
}
