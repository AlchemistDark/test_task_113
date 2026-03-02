import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test_task_113/data/datasources/remote/models/order_dto.dart';
import 'package:test_task_113/data/datasources/remote/order_remote_data_source.dart';
import 'package:test_task_113/data/mappers/order_mapper.dart';
import 'package:test_task_113/data/repositories/order_repository_impl.dart';
import 'package:test_task_113/domain/entities/order.dart';

// Generating mocks
@GenerateMocks([OrderRemoteDataSource, OrderMapper])
import 'order_repository_impl_test.mocks.dart';

void main() {
  late OrderRepositoryImpl repository;
  late MockOrderRemoteDataSource mockDataSource;
  late MockOrderMapper mockMapper;

  setUp(() {
    mockDataSource = MockOrderRemoteDataSource();
    mockMapper = MockOrderMapper();
    repository = OrderRepositoryImpl(
      remoteDataSource: mockDataSource,
      mapper: mockMapper,
    );
  });

  group('createOrder', () {
    const userId = 1;
    const serviceId = 2;
    final dto = OrderDto(orderId: 10, status: 'new', paymentUrl: null);
    final entity = Order(orderId: 10, status: 'new', paymentUrl: null);

    test('should call remoteDataSource and mapper, return Order', () async {
      // arrange
      when(mockDataSource.createOrder(userId, serviceId))
          .thenAnswer((_) async => dto);
      when(mockMapper.toEntity(dto)).thenReturn(entity);

      // act
      final result = await repository.createOrder(userId: userId, serviceId: serviceId);

      // assert
      expect(result, entity);
      verify(mockDataSource.createOrder(userId, serviceId)).called(1);
      verify(mockMapper.toEntity(dto)).called(1);
    });

    test('should propagate exception from remoteDataSource', () async {
      // arrange
      when(mockDataSource.createOrder(userId, serviceId))
          .thenThrow(Exception('Network error'));

      // act
      final call = repository.createOrder(userId: userId, serviceId: serviceId);

      // assert
      expect(call, throwsException);
      verify(mockDataSource.createOrder(userId, serviceId)).called(1);
      verifyNever(mockMapper.toEntity(any));
    });
  });
}