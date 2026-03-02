import 'package:flutter_test/flutter_test.dart';
import 'package:test_task_113/core/exceptions/api_exception.dart';

void main() {
  group('ApiException', () {
    test('should have correct message and statusCode', () {
      final exception = ApiException('Not found', statusCode: 404);
      expect(exception.message, 'Not found');
      expect(exception.statusCode, 404);
    });

    test('toString should return formatted string', () {
      final exception = ApiException('Forbidden', statusCode: 403);
      expect(exception.toString(), 'ApiException: Forbidden (status: 403)');
    });
  });
}