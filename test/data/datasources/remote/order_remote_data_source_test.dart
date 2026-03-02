import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test_task_113/core/exceptions/api_exception.dart';
import 'package:test_task_113/data/datasources/remote/models/order_dto.dart';
import 'package:test_task_113/data/datasources/remote/order_remote_data_source.dart';

// Generating mocks
@GenerateMocks([Dio])
import 'order_remote_data_source_test.mocks.dart';

void main() {
  late OrderRemoteDataSource dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = OrderRemoteDataSource(dio: mockDio);
  });

  group('createOrder', () {
    const userId = 123;
    const serviceId = 456;
    final responseData = {
      'order_id': 1001,
      'status': 'pending',
      'payment_url': 'https://pay.example.com/1001',
    };

    test('should return OrderDto when response is successful (200)', () async {
      // arrange
      when(mockDio.post(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
        requestOptions: RequestOptions(path: ''),
        data: responseData,
        statusCode: 200,
      ));

      // act
      final result = await dataSource.createOrder(userId, serviceId);

      // assert
      expect(result, isA<OrderDto>());
      expect(result.orderId, 1001);
      expect(result.status, 'pending');
      expect(result.paymentUrl, 'https://pay.example.com/1001');
      verify(mockDio.post(
        '/orders',
        data: {'userId': userId, 'serviceId': serviceId},
        options: anyNamed('options'),
      )).called(1);
    });

    test('should throw ApiException when DioException (timeout) occurs', () async {
      // arrange
      when(mockDio.post(any, data: anyNamed('data'), options: anyNamed('options')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionTimeout,
      ));

      // act
      final call = dataSource.createOrder(userId, serviceId);

      // assert
      expect(call, throwsA(isA<ApiException>()));
      expect(
            () async => call,
        throwsA(predicate<ApiException>((e) => e.message.contains('timeout'))),
      );
    });

    test('should throw ApiException when DioException (connection error) occurs', () async {
      // arrange
      when(mockDio.post(any, data: anyNamed('data'), options: anyNamed('options')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionError,
      ));

      // act
      final call = dataSource.createOrder(userId, serviceId);

      // assert
      expect(call, throwsA(isA<ApiException>()));
      expect(
            () async => call,
        throwsA(predicate<ApiException>((e) => e.message.contains('No internet'))),
      );
    });

    test('should throw ApiException with server error message when 4xx/5xx', () async {
      // arrange
      when(mockDio.post(any, data: anyNamed('data'), options: anyNamed('options')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 400,
          data: {'message': 'Invalid parameters'},
        ),
        type: DioExceptionType.badResponse,
      ));

      // act
      final call = dataSource.createOrder(userId, serviceId);

      // assert
      expect(call, throwsA(isA<ApiException>()));
      expect(
            () async => call,
        throwsA(predicate<ApiException>((e) =>
        e.message == 'Invalid parameters' && e.statusCode == 400)),
      );
    });

    test('should throw ApiException with generic message when response has no message', () async {
      // arrange
      when(mockDio.post(any, data: anyNamed('data'), options: anyNamed('options')))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 500,
          data: 'Internal server error',
        ),
        type: DioExceptionType.badResponse,
      ));

      // act
      final call = dataSource.createOrder(userId, serviceId);

      // assert
      expect(call, throwsA(isA<ApiException>()));
      expect(
            () async => call,
        throwsA(predicate<ApiException>((e) =>
        e.message == 'Internal server error' && e.statusCode == 500)),
      );
    });
  });
}