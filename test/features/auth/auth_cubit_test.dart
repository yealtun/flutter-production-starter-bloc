import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_production_starter_bloc/core/network/error/api_exception.dart';
import 'package:flutter_production_starter_bloc/core/utils/result.dart';
import 'package:flutter_production_starter_bloc/features/auth/domain/entities/token.dart';
import 'package:flutter_production_starter_bloc/features/auth/domain/repositories/auth_repo.dart';
import 'package:flutter_production_starter_bloc/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_production_starter_bloc/features/auth/domain/usecases/refresh_token_usecase.dart';
import 'package:flutter_production_starter_bloc/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter_production_starter_bloc/features/auth/presentation/cubit/auth_state.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockLoginUseCase extends Mock implements LoginUseCase {}

class MockRefreshTokenUseCase extends Mock implements RefreshTokenUseCase {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockLoginUseCase mockLoginUseCase;
  late MockRefreshTokenUseCase mockRefreshTokenUseCase;
  late AuthCubit authCubit;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockLoginUseCase = MockLoginUseCase();
    mockRefreshTokenUseCase = MockRefreshTokenUseCase();
    // Setup default mock for getCurrentToken() which is called in AuthCubit constructor
    when(
      () => mockAuthRepository.getCurrentToken(),
    ).thenAnswer((_) async => const Success(null));
    authCubit = AuthCubit(
      mockLoginUseCase,
      mockRefreshTokenUseCase,
      mockAuthRepository,
    );
  });

  tearDown(() {
    authCubit.close();
  });

  test(
    'initial state should transition to unauthenticated after checking auth status',
    () async {
      // The constructor calls _checkAuthStatus() which is async
      // Wait for the async operation to complete
      await Future.delayed(const Duration(milliseconds: 100));
      expect(authCubit.state, const AuthState.unauthenticated());
    },
  );

  blocTest<AuthCubit, AuthState>(
    'emits [loading, authenticated] when login succeeds',
    build: () {
      when(
        () => mockAuthRepository.getCurrentToken(),
      ).thenAnswer((_) async => const Success(null));
      when(() => mockLoginUseCase(any(), any())).thenAnswer(
        (_) async =>
            const Success(Token(accessToken: 'token', refreshToken: 'refresh')),
      );
      return authCubit;
    },
    act: (cubit) => cubit.login('test@example.com', 'password'),
    expect: () => [
      const AuthState.loading(),
      const AuthState.authenticated(
        Token(accessToken: 'token', refreshToken: 'refresh'),
      ),
    ],
  );

  blocTest<AuthCubit, AuthState>(
    'emits [loading, error] when login fails',
    build: () {
      when(
        () => mockAuthRepository.getCurrentToken(),
      ).thenAnswer((_) async => const Success(null));
      when(
        () => mockLoginUseCase(any(), any()),
      ).thenAnswer((_) async => const Failure(AuthFailure()));
      return authCubit;
    },
    act: (cubit) => cubit.login('test@example.com', 'password'),
    expect: () => [
      const AuthState.loading(),
      const AuthState.error(AuthFailure()),
    ],
  );
}
