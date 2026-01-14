# BLoC/Cubit State Management

## Overview

This project uses **flutter_bloc** with **Cubit** as the primary state management solution. Cubit is preferred for simple state flows, while Bloc is available for complex event handling.

## Cubit vs Bloc

### When to Use Cubit

- Simple state transitions
- Direct method calls
- No need for event transformation
- Most common use case

### When to Use Bloc

- Complex event handling
- Event transformation needed
- Event debouncing/throttling
- Event replay capabilities

## State Design

### Immutable States

States are defined using **freezed** for immutability:

```dart
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(Token token) = _Authenticated;
  const factory AuthState.error(ApiException error) = _Error;
}
```

### State Patterns

**Loading States**: Always include a loading state for async operations

**Success States**: Include data in success state

**Error States**: Include error details for user feedback

**Empty States**: Separate empty state from loading/error

## Side Effect Separation

### Navigation

Navigation is handled via `BlocListener`, not in Cubit:

```dart
BlocListener<AuthCubit, AuthState>(
  listener: (context, state) {
    state.maybeWhen(
      authenticated: (_) => context.go('/feed'),
      orElse: () {},
    );
  },
  child: ...,
)
```

### Toasts/Snackbars

User feedback via `BlocListener`:

```dart
BlocListener<AuthCubit, AuthState>(
  listener: (context, state) {
    state.maybeWhen(
      error: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message)),
        );
      },
      orElse: () {},
    );
  },
  child: ...,
)
```

## Best Practices

### 1. Keep Cubits Focused

Each Cubit should manage state for a single feature or screen.

### 2. Use Freezed for States

Freezed provides:
- Immutability
- Pattern matching
- Copy methods
- Equality comparison

### 3. Handle Errors Gracefully

Always include error states and handle them in UI.

### 4. Optimize Rebuilds

Use `BlocBuilder` with `buildWhen`:

```dart
BlocBuilder<FeedCubit, FeedState>(
  buildWhen: (previous, current) => previous != current,
  builder: (context, state) => ...,
)
```

### 5. Test State Transitions

Use `bloc_test` for testing state transitions:

```dart
blocTest<AuthCubit, AuthState>(
  'emits [loading, authenticated] when login succeeds',
  build: () => ...,
  act: (cubit) => cubit.login(...),
  expect: () => [...],
);
```

## Common Patterns

### Loading → Success

```dart
Future<void> loadData() async {
  emit(LoadingState());
  final result = await repository.getData();
  result.fold(
    onSuccess: (data) => emit(SuccessState(data)),
    onFailure: (error) => emit(ErrorState(error)),
  );
}
```

### Pagination

```dart
Future<void> loadMore() async {
  final currentState = state;
  currentState.maybeWhen(
    success: (items, meta) {
      if (meta.hasNextPage) {
        _loadNextPage();
      }
    },
    orElse: () {},
  );
}
```

### Refresh

```dart
Future<void> refresh() async {
  _resetPagination();
  await loadData();
}
```
