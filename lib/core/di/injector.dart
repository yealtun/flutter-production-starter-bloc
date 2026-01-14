import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../analytics/analytics_service.dart';
import '../analytics/dummy_analytics_service.dart';
import '../logging/app_logger.dart';
import '../network/dio_client.dart';
import '../storage/local_storage.dart';
import '../storage/shared_prefs_storage.dart';
import '../../features/auth/data/datasources/auth_remote_ds.dart';
import '../../features/auth/data/repositories/auth_repo_impl.dart';
import '../../features/auth/domain/repositories/auth_repo.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/refresh_token_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/feed/data/datasources/feed_remote_ds.dart';
import '../../features/feed/data/repositories/feed_repo_impl.dart';
import '../../features/feed/domain/repositories/feed_repo.dart';
import '../../features/feed/domain/usecases/get_items_usecase.dart';
import '../../features/feed/presentation/cubit/feed_cubit.dart';
import '../../features/sdk_demo/data/sdk_wrapper.dart';
import '../../features/ai_demo/data/ai_client.dart';

/// Global service locator instance
final getIt = GetIt.instance;

/// Initialize dependency injection container
Future<void> initInjector() async {
  // Core services
  final sharedPrefs = await SharedPreferences.getInstance();
  final storage = SharedPrefsStorage(sharedPrefs);
  getIt.registerSingleton<LocalStorage>(storage);

  final logger = AppLogger();
  getIt.registerSingleton<AppLogger>(logger);

  final dioClient = DioClient(storage: storage, logger: logger);
  getIt.registerSingleton<DioClient>(dioClient);
  getIt.registerSingleton<Dio>(dioClient.dio);

  final analyticsService = DummyAnalyticsService(logger);
  getIt.registerSingleton<AnalyticsService>(analyticsService);

  // Auth feature
  final authRemoteDs = AuthRemoteDataSourceImpl(getIt<Dio>());
  getIt.registerSingleton<AuthRemoteDataSource>(authRemoteDs);

  final authRepo = AuthRepositoryImpl(authRemoteDs, storage);
  getIt.registerSingleton<AuthRepository>(authRepo);

  final loginUseCase = LoginUseCase(authRepo);
  getIt.registerSingleton<LoginUseCase>(loginUseCase);

  final refreshTokenUseCase = RefreshTokenUseCase(authRepo);
  getIt.registerSingleton<RefreshTokenUseCase>(refreshTokenUseCase);

  final authCubit = AuthCubit(loginUseCase, refreshTokenUseCase, authRepo);
  getIt.registerSingleton<AuthCubit>(authCubit);

  // Feed feature
  final feedRemoteDs = FeedRemoteDataSourceImpl(getIt<Dio>());
  getIt.registerSingleton<FeedRemoteDataSource>(feedRemoteDs);

  final feedRepo = FeedRepositoryImpl(feedRemoteDs, getIt<Dio>());
  getIt.registerSingleton<FeedRepository>(feedRepo);

  final getItemsUseCase = GetItemsUseCase(feedRepo);
  getIt.registerSingleton<GetItemsUseCase>(getItemsUseCase);

  getIt.registerFactory<FeedCubit>(() => FeedCubit(getItemsUseCase));

  // SDK Demo
  final sdkWrapper = SdkWrapper(logger);
  getIt.registerSingleton<SdkWrapper>(sdkWrapper);

  // AI Demo
  final aiClient = AiClient(getIt<Dio>());
  getIt.registerSingleton<AiClient>(aiClient);
}
