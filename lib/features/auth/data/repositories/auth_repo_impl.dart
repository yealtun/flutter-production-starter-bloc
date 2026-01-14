import 'package:dio/dio.dart';
import '../../../../core/network/error/api_exception.dart';
import '../../../../core/network/error/error_mapper.dart';
import '../../../../core/storage/local_storage.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/token.dart';
import '../../domain/repositories/auth_repo.dart';
import '../datasources/auth_remote_ds.dart';
import '../models/token_dto.dart';

const _accessTokenKey = 'access_token';
const _refreshTokenKey = 'refresh_token';

/// Implementation of [AuthRepository]
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource, this._storage);

  final AuthRemoteDataSource _remoteDataSource;
  final LocalStorage _storage;

  @override
  Future<Result<Token>> login(String email, String password) async {
    try {
      final dto = await _remoteDataSource.login(email, password);
      final token = dto.toDomain();

      // Store tokens
      await _storage.saveString(_accessTokenKey, token.accessToken);
      await _storage.saveString(_refreshTokenKey, token.refreshToken);

      return Success(token);
    } on DioException catch (e) {
      return Failure(mapDioError(e));
    } catch (e) {
      return Failure(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Result<Token>> refreshToken(String refreshToken) async {
    try {
      final dto = await _remoteDataSource.refreshToken(refreshToken);
      final token = dto.toDomain();

      // Update stored tokens
      await _storage.saveString(_accessTokenKey, token.accessToken);
      await _storage.saveString(_refreshTokenKey, token.refreshToken);

      return Success(token);
    } on DioException catch (e) {
      return Failure(mapDioError(e));
    } catch (e) {
      return Failure(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _storage.remove(_accessTokenKey);
      await _storage.remove(_refreshTokenKey);
      return const Success(null);
    } catch (e) {
      return Failure(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Result<Token?>> getCurrentToken() async {
    try {
      final accessToken = await _storage.getString(_accessTokenKey);
      final refreshToken = await _storage.getString(_refreshTokenKey);

      if (accessToken == null || refreshToken == null) {
        return const Success(null);
      }

      return Success(Token(
        accessToken: accessToken,
        refreshToken: refreshToken,
      ));
    } catch (e) {
      return Failure(NetworkFailure(e.toString()));
    }
  }
}
