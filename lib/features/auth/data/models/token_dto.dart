import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/token.dart';

part 'token_dto.freezed.dart';
part 'token_dto.g.dart';

/// Data Transfer Object for authentication token
@freezed
class TokenDto with _$TokenDto {
  const factory TokenDto({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    @JsonKey(name: 'expires_in') int? expiresIn,
  }) = _TokenDto;

  factory TokenDto.fromJson(Map<String, dynamic> json) =>
      _$TokenDtoFromJson(json);
}

/// Extension to convert DTO to domain entity
extension TokenDtoX on TokenDto {
  Token toDomain() {
    return Token(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresIn: expiresIn,
    );
  }
}
