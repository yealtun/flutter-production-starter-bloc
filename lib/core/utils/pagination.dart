/// Metadata for paginated responses
class PaginationMeta {
  const PaginationMeta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  final int page;
  final int limit;
  final int total;
  final int totalPages;

  /// Check if there are more pages available
  bool get hasNextPage => page < totalPages;

  /// Check if there is a previous page
  bool get hasPreviousPage => page > 1;

  /// Get the next page number, or null if no next page
  int? get nextPage => hasNextPage ? page + 1 : null;

  /// Get the previous page number, or null if no previous page
  int? get previousPage => hasPreviousPage ? page - 1 : null;

  PaginationMeta copyWith({
    int? page,
    int? limit,
    int? total,
    int? totalPages,
  }) {
    return PaginationMeta(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      total: total ?? this.total,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}
