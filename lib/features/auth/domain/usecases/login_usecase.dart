import '../../../../core/utils/result.dart';
import '../entities/token.dart';
import '../repositories/auth_repo.dart';

/// Use case for user login
class LoginUseCase {
  LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<Token>> call(String email, String password) {
    return _repository.login(email, password);
  }
}
