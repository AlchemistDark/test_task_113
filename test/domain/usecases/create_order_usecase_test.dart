import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test_task_113/domain/entities/order.dart';
import 'package:test_task_113/domain/repositories/order_repository.dart';
import 'package:test_task_113/domain/usecases/create_order_usecase.dart';

@GenerateMocks([OrderRepository])
import 'create_order_usecase_test.mocks.dart';

void main() {
  late CreateOrderUseCase useCase;
  late MockOrderRepository mockRepository;

  setUp(() {
    mockRepository = MockOrderRepository();
    useCase = CreateOrderUseCase(mockRepository);
  });

  test('should call repository.createOrder with correct parameters and return order', () async {
    // arrange
    const userId = 123;
    const serviceId = 456;
    final order = Order(orderId: 1, status: 'created');
    when(mockRepository.createOrder(userId: userId, serviceId: serviceId))
        .thenAnswer((_) async => order);

    // act
    final result = await useCase.execute(userId: userId, serviceId: serviceId);

    // assert
    expect(result, order);
    verify(mockRepository.createOrder(userId: userId, serviceId: serviceId)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}