import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/item.dart';

part 'item_dto.freezed.dart';
part 'item_dto.g.dart';

/// Data Transfer Object for feed item
@freezed
class ItemDto with _$ItemDto {
  const factory ItemDto({
    required int id,
    @JsonKey(name: 'user_id') int? userId,
    required String title,
    required String body,
  }) = _ItemDto;

  factory ItemDto.fromJson(Map<String, dynamic> json) =>
      _$ItemDtoFromJson(json);
}

/// Extension to convert DTO to domain entity
extension ItemDtoX on ItemDto {
  Item toDomain() {
    return Item(
      id: id,
      userId: userId,
      title: title,
      body: body,
    );
  }
}
