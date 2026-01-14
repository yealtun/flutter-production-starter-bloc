import 'package:dio/dio.dart';
import '../models/item_dto.dart';

/// Remote data source for feed
abstract class FeedRemoteDataSource {
  Future<List<ItemDto>> getItems({required int page, required int limit});
}

/// Implementation using jsonplaceholder API
class FeedRemoteDataSourceImpl implements FeedRemoteDataSource {
  FeedRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<ItemDto>> getItems(
      {required int page, required int limit}) async {
    final response = await _dio.get<List<dynamic>>(
      '/posts',
      queryParameters: {
        '_page': page,
        '_limit': limit,
      },
    );

    if (response.data is List) {
      return (response.data as List)
          .map((json) => ItemDto.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    return [];
  }
}
