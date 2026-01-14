# Testing

## Overview

This project follows a comprehensive testing strategy with unit tests, bloc tests, repository tests, and integration tests.

## Testing Stack

- **flutter_test**: Core testing framework
- **mocktail**: Mocking library (replacement for mockito)
- **bloc_test**: Testing BLoC/Cubit state transitions
- **integration_test**: End-to-end testing

## Unit Tests

### Testing Utilities

**Location**: `test/core/utils/`

Test pure functions and utilities:

```dart
test('Success should contain value', () {
  const result = Success<int>(42);
  expect(result.isSuccess, isTrue);
  expect(result.valueOrNull, 42);
});
```

### Testing Error Mappers

**Location**: `test/core/network/`

Test error mapping logic:

```dart
test('should map 401 to AuthFailure', () {
  final error = DioException(...);
  final result = mapDioError(error);
  expect(result, isA<AuthFailure>());
});
```

## Bloc Tests

### Using bloc_test

**Location**: `test/features/*/`

Test state transitions:

```dart
blocTest<AuthCubit, AuthState>(
  'emits [loading, authenticated] when login succeeds',
  build: () {
    when(() => mockLoginUseCase(...))
        .thenAnswer((_) async => Success(...));
    return authCubit;
  },
  act: (cubit) => cubit.login('email', 'password'),
  expect: () => [
    const AuthState.loading(),
    const AuthState.authenticated(...),
  ],
);
```

### Testing Error Cases

```dart
blocTest<AuthCubit, AuthState>(
  'emits [loading, error] when login fails',
  build: () {
    when(() => mockLoginUseCase(...))
        .thenAnswer((_) async => Failure(AuthFailure()));
    return authCubit;
  },
  act: (cubit) => cubit.login('email', 'password'),
  expect: () => [
    const AuthState.loading(),
    const AuthState.error(AuthFailure()),
  ],
);
```

## Repository Tests

### Using mocktail

**Location**: `test/features/*/`

Mock data sources and test repository logic:

```dart
test('should return items with pagination metadata on success', () async {
  when(() => mockRemoteDataSource.getItems(...))
      .thenAnswer((_) async => []);
  
  final result = await repository.getItems(...);
  
  expect(result.isSuccess, isTrue);
  final (items, meta) = result.valueOrNull!;
  expect(items, isA<List<Item>>());
});
```

### Testing Error Handling

```dart
test('should return failure on error', () async {
  when(() => mockRemoteDataSource.getItems(...))
      .thenThrow(DioException(...));
  
  final result = await repository.getItems(...);
  
  expect(result.isFailure, isTrue);
  expect(result.errorOrNull, isA<NetworkFailure>());
});
```

## Integration Tests

### Smoke Tests

**Location**: `integration_test/`

Test basic app flow:

```dart
testWidgets('app launches and shows login screen', (tester) async {
  app.main();
  await tester.pumpAndSettle();
  
  expect(find.text('Login'), findsOneWidget);
});
```

### User Flows

Test complete user journeys:

```dart
testWidgets('can navigate to feed after login', (tester) async {
  // Enter credentials
  await tester.enterText(...);
  await tester.tap(find.text('Login'));
  await tester.pumpAndSettle();
  
  // Verify navigation
  expect(find.text('Feed'), findsOneWidget);
});
```

## Running Tests

### All Tests

```bash
fvm flutter test
```

### Specific Test File

```bash
fvm flutter test test/features/auth/auth_cubit_test.dart
```

### Integration Tests

```bash
fvm flutter test integration_test/
```

### With Coverage

```bash
fvm flutter test --coverage
```

## Best Practices

1. **Test Behavior, Not Implementation**: Focus on what the code does, not how
2. **Use Descriptive Test Names**: Test names should describe the scenario
3. **Arrange-Act-Assert**: Structure tests clearly
4. **Mock External Dependencies**: Use mocks for network, storage, etc.
5. **Test Edge Cases**: Include error cases, empty states, boundary conditions
6. **Keep Tests Fast**: Unit tests should run quickly
7. **Maintain Test Coverage**: Aim for high coverage of critical paths

## Test Organization

```
test/
  core/
    network/        # Network layer tests
    utils/          # Utility tests
  features/
    auth/           # Auth feature tests
    feed/           # Feed feature tests
```

## Mocking with mocktail

### Setup

```dart
class MockRepository extends Mock implements Repository {}
```

### Stubbing

```dart
when(() => mockRepository.getData())
    .thenAnswer((_) async => Success(data));
```

### Verification

```dart
verify(() => mockRepository.getData()).called(1);
```
