import '../../../../core/utils/pagination.dart';
import '../../../../core/utils/result.dart';
import '../entities/item.dart';

/// Feed repository interface
abstract class FeedRepository {
  /// Get items with pagination
  Future<Result<(List<Item>, PaginationMeta)>> getItems({
    required int page,
    required int limit,
  });
}
