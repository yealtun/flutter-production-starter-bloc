import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_production_starter_bloc/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_production_starter_bloc/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter_production_starter_bloc/features/auth/presentation/cubit/auth_state.dart';

class MockAuthCubit extends Mock implements AuthCubit {}

void main() {
  late MockAuthCubit mockAuthCubit;

  setUp(() {
    mockAuthCubit = MockAuthCubit();
    when(
      () => mockAuthCubit.state,
    ).thenReturn(const AuthState.unauthenticated());
    when(() => mockAuthCubit.stream).thenAnswer((_) => const Stream.empty());
  });

  testWidgets('Login screen displays login form', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AuthCubit>.value(
          value: mockAuthCubit,
          child: const LoginScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(
      find.text('Login'),
      findsAtLeastNWidgets(1),
    ); // AppBar title and/or button
    expect(
      find.byType(TextFormField),
      findsNWidgets(2),
    ); // Email and password fields
    expect(find.byType(ElevatedButton), findsOneWidget); // Login button
  });
}
