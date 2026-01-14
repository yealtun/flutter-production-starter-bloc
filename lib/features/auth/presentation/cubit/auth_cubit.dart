import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repo.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/refresh_token_usecase.dart';
import '../../../../core/network/error/api_exception.dart';
import '../../../../core/utils/result.dart';
import 'auth_state.dart';

/// Cubit for managing authentication state
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._loginUseCase, this._refreshTokenUseCase, this._authRepository)
    : super(const AuthState.initial()) {
    _checkAuthStatus();
  }

  final LoginUseCase _loginUseCase;
  final RefreshTokenUseCase _refreshTokenUseCase;
  final AuthRepository _authRepository;

  /// Check if user is already authenticated
  Future<void> _checkAuthStatus() async {
    final result = await _authRepository.getCurrentToken();
    result.fold(
      onSuccess: (token) {
        if (token != null) {
          emit(AuthState.authenticated(token));
        } else {
          emit(const AuthState.unauthenticated());
        }
      },
      onFailure: (_) => emit(const AuthState.unauthenticated()),
    );
  }

  /// Login with email and password
  Future<void> login(String email, String password) async {
    emit(const AuthState.loading());
    final result = await _loginUseCase(email, password);
    result.fold(
      onSuccess: (token) => emit(AuthState.authenticated(token)),
      onFailure: (error) {
        final apiException = error is ApiException
            ? error
            : NetworkFailure(error.toString());
        emit(AuthState.error(apiException));
      },
    );
  }

  /// Logout
  Future<void> logout() async {
    emit(const AuthState.loading());
    final result = await _authRepository.logout();
    result.fold(
      onSuccess: (_) => emit(const AuthState.unauthenticated()),
      onFailure: (error) {
        final apiException = error is ApiException
            ? error
            : NetworkFailure(error.toString());
        emit(AuthState.error(apiException));
      },
    );
  }

  /// Refresh token
  Future<void> refreshToken(String refreshToken) async {
    final result = await _refreshTokenUseCase(refreshToken);
    result.fold(
      onSuccess: (token) => emit(AuthState.authenticated(token)),
      onFailure: (error) {
        final apiException = error is ApiException
            ? error
            : NetworkFailure(error.toString());
        emit(AuthState.error(apiException));
      },
    );
  }
}
