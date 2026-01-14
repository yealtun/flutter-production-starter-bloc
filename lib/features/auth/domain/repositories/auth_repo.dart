import '../../../../core/utils/result.dart';
import '../entities/token.dart';

/// Authentication repository interface
abstract class AuthRepository {
  /// Login with email and password
  Future<Result<Token>> login(String email, String password);

  /// Refresh the access token using refresh token
  Future<Result<Token>> refreshToken(String refreshToken);

  /// Logout and clear stored tokens
  Future<Result<void>> logout();

  /// Get current stored token
  Future<Result<Token?>> getCurrentToken();
}
