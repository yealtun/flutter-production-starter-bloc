/// A sealed class representing the result of an operation that can either
/// succeed with a value of type [T] or fail with a [Failure].
sealed class Result<T> {
  const Result();
}

/// Represents a successful result containing a value of type [T].
final class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;
}

/// Represents a failed result containing a [Failure].
final class Failure<T> extends Result<T> {
  const Failure(this.error);
  final Exception error;
}

/// Extension methods for [Result] to make it easier to work with.
extension ResultExtension<T> on Result<T> {
  /// Returns `true` if the result is a [Success].
  bool get isSuccess => this is Success<T>;

  /// Returns `true` if the result is a [Failure].
  bool get isFailure => this is Failure<T>;

  /// Returns the value if [Success], otherwise returns `null`.
  T? get valueOrNull => switch (this) {
        Success<T>(:final value) => value,
        Failure<T>() => null,
      };

  /// Returns the error if [Failure], otherwise returns `null`.
  Exception? get errorOrNull => switch (this) {
        Success<T>() => null,
        Failure<T>(:final error) => error,
      };

  /// Maps the value of a [Success] result using the provided function.
  Result<R> map<R>(R Function(T value) mapper) => switch (this) {
        Success<T>(:final value) => Success(mapper(value)),
        Failure<T>(:final error) => Failure<R>(error),
      };

  /// Maps the error of a [Failure] result using the provided function.
  Result<T> mapError(Exception Function(Exception error) mapper) =>
      switch (this) {
        Success<T>() => this,
        Failure<T>(:final error) => Failure<T>(mapper(error)),
      };

  /// Folds the result into a value of type [R].
  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(Exception error) onFailure,
  }) =>
      switch (this) {
        Success<T>(:final value) => onSuccess(value),
        Failure<T>(:final error) => onFailure(error),
      };
}
