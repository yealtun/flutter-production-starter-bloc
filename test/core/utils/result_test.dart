import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_production_starter_bloc/core/utils/result.dart';

void main() {
  group('Result', () {
    test('Success should contain value', () {
      const result = Success<int>(42);
      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
      expect(result.valueOrNull, 42);
      expect(result.errorOrNull, isNull);
    });

    test('Failure should contain error', () {
      final error = Exception('Test error');
      final result = Failure<int>(error);
      expect(result.isSuccess, isFalse);
      expect(result.isFailure, isTrue);
      expect(result.valueOrNull, isNull);
      expect(result.errorOrNull, error);
    });

    test('map should transform Success value', () {
      const result = Success<int>(5);
      final mapped = result.map((value) => value * 2);
      expect(mapped.valueOrNull, 10);
    });

    test('map should preserve Failure', () {
      final error = Exception('Test error');
      final result = Failure<int>(error);
      final mapped = result.map((value) => value * 2);
      expect(mapped.isFailure, isTrue);
      expect(mapped.errorOrNull, error);
    });

    test('fold should call onSuccess for Success', () {
      const result = Success<int>(42);
      final value = result.fold(
        onSuccess: (v) => v.toString(),
        onFailure: (_) => 'error',
      );
      expect(value, '42');
    });

    test('fold should call onFailure for Failure', () {
      final error = Exception('Test error');
      final result = Failure<int>(error);
      final value = result.fold(
        onSuccess: (v) => v.toString(),
        onFailure: (e) => e.toString(),
      );
      expect(value, contains('Test error'));
    });
  });
}
