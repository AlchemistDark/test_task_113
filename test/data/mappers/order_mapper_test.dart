import 'package:flutter_test/flutter_test.dart';
import 'package:test_task_113/data/datasources/remote/models/order_dto.dart';
import 'package:test_task_113/data/mappers/order_mapper.dart';
import 'package:test_task_113/domain/entities/order.dart';

void main() {
  group('OrderMapper', () {
    test('toEntity should correctly convert OrderDto to Order', () {
      // arrange
      const dto = OrderDto(
        orderId: 42,
        status: 'confirmed',
        paymentUrl: 'https://pay.me/42',
      );
      final mapper = OrderMapper();

      // act
      final entity = mapper.toEntity(dto);

      // assert
      expect(entity.orderId, 42);
      expect(entity.status, 'confirmed');
      expect(entity.paymentUrl, 'https://pay.me/42');
    });

    test('toDto should correctly convert Order to OrderDto', () {
      // arrange
      final entity = Order(
        orderId: 99,
        status: 'cancelled',
        paymentUrl: null,
      );
      final mapper = OrderMapper();

      // act
      final dto = mapper.toDto(entity);

      // assert
      expect(dto.orderId, 99);
      expect(dto.status, 'cancelled');
      expect(dto.paymentUrl, null);
    });
  });
}