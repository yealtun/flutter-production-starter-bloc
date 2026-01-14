import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'core/di/injector.dart';
import 'core/logging/app_logger.dart';
import 'features/ai_demo/data/ai_client.dart';
import 'features/ai_demo/presentation/screens/ai_demo_screen.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/feed/presentation/cubit/feed_cubit.dart';
import 'features/feed/presentation/screens/feed_screen.dart';
import 'features/sdk_demo/data/sdk_wrapper.dart';
import 'features/sdk_demo/presentation/screens/sdk_demo_screen.dart';
import 'features/settings/presentation/screens/settings_screen.dart';

/// Main app widget with routing
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<AuthCubit>()),
      ],
      child: MaterialApp.router(
        title: 'Flutter Production Starter BLoC',
        routerConfig: _createRouter(),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
      ),
    );
  }
}

GoRouter _createRouter() {
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      try {
        final authCubit = getIt<AuthCubit>();
        final authState = authCubit.state;
        final isLoggedIn = authState.maybeWhen(
          authenticated: (_) => true,
          orElse: () => false,
        );

        final isLoginRoute = state.matchedLocation == '/login';

        if (!isLoggedIn && !isLoginRoute) {
          return '/login';
        }
        if (isLoggedIn && isLoginRoute) {
          return '/feed';
        }
      } catch (e) {
        // If DI is not initialized yet, redirect to login
        if (state.matchedLocation != '/login') {
          return '/login';
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/feed',
        builder: (context, state) => BlocProvider(
          create: (_) => getIt<FeedCubit>(),
          child: const FeedScreen(),
        ),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/sdk-demo',
        builder: (context, state) => SdkDemoScreen(
          sdkWrapper: getIt<SdkWrapper>(),
          logger: getIt<AppLogger>(),
        ),
      ),
      GoRoute(
        path: '/ai-demo',
        builder: (context, state) => AiDemoScreen(
          aiClient: getIt<AiClient>(),
        ),
      ),
    ],
  );
}
