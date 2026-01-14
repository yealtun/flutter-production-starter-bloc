import 'package:dio/dio.dart';
import '../models/token_dto.dart';

/// Remote data source for authentication
abstract class AuthRemoteDataSource {
  Future<TokenDto> login(String email, String password);
  Future<TokenDto> refreshToken(String refreshToken);
}

/// Implementation of [AuthRemoteDataSource] with mock data
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._dio);

  // _dio is kept for future use when implementing real API calls
  // ignore: unused_field
  final Dio _dio;

  @override
  Future<TokenDto> login(String email, String password) async {
    // Mock implementation - simulate API delay
    await Future<void>.delayed(const Duration(seconds: 1));

    // Mock successful login for any email/password
    // In a real app, this would be: await _dio.post('/auth/login', data: {'email': email, 'password': password});
    return const TokenDto(
      accessToken: 'mock_access_token_12345',
      refreshToken: 'mock_refresh_token_12345',
      expiresIn: 3600,
    );
  }

  @override
  Future<TokenDto> refreshToken(String refreshToken) async {
    // Mock implementation
    await Future<void>.delayed(const Duration(milliseconds: 500));

    return const TokenDto(
      accessToken: 'mock_new_access_token_12345',
      refreshToken: 'mock_new_refresh_token_12345',
      expiresIn: 3600,
    );
  }
}
