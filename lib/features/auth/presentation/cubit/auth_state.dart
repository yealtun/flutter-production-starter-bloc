import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/token.dart';
import '../../../../core/network/error/api_exception.dart';

part 'auth_state.freezed.dart';

/// Authentication state
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(Token token) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.error(ApiException error) = _Error;
}
