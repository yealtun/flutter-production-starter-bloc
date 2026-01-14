import '../../../../core/utils/result.dart';
import '../entities/token.dart';
import '../repositories/auth_repo.dart';

/// Use case for refreshing access token
class RefreshTokenUseCase {
  RefreshTokenUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<Token>> call(String refreshToken) {
    return _repository.refreshToken(refreshToken);
  }
}
