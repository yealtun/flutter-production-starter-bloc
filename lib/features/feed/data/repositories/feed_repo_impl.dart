import 'package:dio/dio.dart';
import '../../../../core/network/error/api_exception.dart';
import '../../../../core/network/error/error_mapper.dart';
import '../../../../core/utils/pagination.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/item.dart';
import '../../domain/repositories/feed_repo.dart';
import '../datasources/feed_remote_ds.dart';
import '../models/item_dto.dart';

/// Implementation of [FeedRepository]
class FeedRepositoryImpl implements FeedRepository {
  FeedRepositoryImpl(this._remoteDataSource, this._dio);

  final FeedRemoteDataSource _remoteDataSource;
  // _dio is kept for future use when implementing direct API calls
  // ignore: unused_field
  final Dio _dio;

  @override
  Future<Result<(List<Item>, PaginationMeta)>> getItems({
    required int page,
    required int limit,
  }) async {
    try {
      final dtos = await _remoteDataSource.getItems(page: page, limit: limit);
      final items = dtos.map<Item>((dto) => dto.toDomain()).toList();

      // Calculate pagination metadata
      // Note: jsonplaceholder doesn't provide total count in headers,
      // so we'll estimate based on response
      final total = items.length < limit ? (page - 1) * limit + items.length : page * limit + 1;
      final totalPages = (total / limit).ceil();

      final meta = PaginationMeta(
        page: page,
        limit: limit,
        total: total,
        totalPages: totalPages,
      );

      return Success((items, meta));
    } on DioException catch (e) {
      return Failure(mapDioError(e));
    } catch (e) {
      return Failure(NetworkFailure(e.toString()));
    }
  }
}
