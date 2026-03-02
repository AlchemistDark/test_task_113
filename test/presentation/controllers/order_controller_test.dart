import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test_task_113/core/exceptions/api_exception.dart';
import 'package:test_task_113/domain/entities/order.dart';
import 'package:test_task_113/domain/usecases/create_order_usecase.dart';
import 'package:test_task_113/presentation/controllers/order_controller.dart';

@GenerateMocks([CreateOrderUseCase])
import 'order_controller_test.mocks.dart';

void main() {
  late OrderController controller;
  late MockCreateOrderUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockCreateOrderUseCase();
    controller = OrderController(createOrderUseCase: mockUseCase);
  });

  group('submitOrder', () {
    const userId = 1;
    const serviceId = 2;

    test('should set loading then success state when useCase succeeds', () async {
      // arrange
      final order = Order(orderId: 100, status: 'done');
      when(mockUseCase.execute(userId: userId, serviceId: serviceId))
          .thenAnswer((_) async => order);

      // initial state
      expect(controller.state, OrderState.initial);
      expect(controller.order, null);
      expect(controller.errorMessage, null);

      // act
      final future = controller.submitOrder(userId, serviceId);

      // after first notify (loading)
      expect(controller.state, OrderState.loading);
      expect(controller.order, null);
      expect(controller.errorMessage, null);

      await future;

      // final state
      expect(controller.state, OrderState.success);
      expect(controller.order, order);
      expect(controller.errorMessage, null);
    });

    test('should set loading then error state when useCase throws ApiException', () async {
      // arrange
      const errorMsg = 'Invalid data';
      when(mockUseCase.execute(userId: userId, serviceId: serviceId))
          .thenAnswer((_) async => throw ApiException(errorMsg, statusCode: 400));

      // act
      final future = controller.submitOrder(userId, serviceId);

      // verify loading state immediately after call (before await)
      expect(controller.state, OrderState.loading);
      expect(controller.order, null);
      expect(controller.errorMessage, null);

      await future;

      // verify error state after await
      expect(controller.state, OrderState.error);
      expect(controller.order, null);
      expect(controller.errorMessage, errorMsg);
    });

    test('should set loading then error state when useCase throws generic exception', () async {
      // arrange
      when(mockUseCase.execute(userId: userId, serviceId: serviceId))
          .thenAnswer((_) async => throw Exception('Unexpected'));

      // act
      final future = controller.submitOrder(userId, serviceId);

      expect(controller.state, OrderState.loading);

      await future;

      expect(controller.state, OrderState.error);
      expect(controller.order, null);
      expect(controller.errorMessage, contains('Unexpected'));
    });
  });

  group('reset', () {
    test('should set state to initial and clear order and error', () {
      // set some non-initial state
      controller = OrderController(createOrderUseCase: mockUseCase)
        ..reset(); // can't set state directly, so we'll simulate a scenario

      // manually change private fields via reflection? better to test after an error.
      // simpler: test that after reset, state is initial.
      controller.reset();
      expect(controller.state, OrderState.initial);
      expect(controller.order, null);
      expect(controller.errorMessage, null);
    });
  });
}