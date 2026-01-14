import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/item.dart';
import '../../../../core/network/error/api_exception.dart';
import '../../../../core/utils/pagination.dart';

part 'feed_state.freezed.dart';

/// Feed state
@freezed
class FeedState with _$FeedState {
  const factory FeedState.loading() = _Loading;
  const factory FeedState.success(
    List<Item> items,
    PaginationMeta paginationMeta,
  ) = _Success;
  const factory FeedState.empty() = _Empty;
  const factory FeedState.error(ApiException error) = _Error;
}
