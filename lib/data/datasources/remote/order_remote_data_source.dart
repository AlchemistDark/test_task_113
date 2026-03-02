import 'package:dio/dio.dart';

import '../../../core/exceptions/api_exception.dart';
import 'models/order_dto.dart';

/// Remote data source for order operations.
/// Responsible for making HTTP requests to the order API.
class OrderRemoteDataSource {
  final Dio dio;

  /// Creates an [OrderRemoteDataSource] with the given [dio] client.
  OrderRemoteDataSource({required this.dio});

  /// Sends a POST request to create a new order.
  ///
  /// [userId] – identifier of the user.
  /// [serviceId] – identifier of the service.
  ///
  /// Returns an [OrderDto] on success.
  /// Throws [ApiException] on any error (network, timeout, server error).
  Future<OrderDto> createOrder(int userId, int serviceId) async {
    try {
      final response = await dio.post(
        '/orders',
        data: {
          'userId': userId,
          'serviceId': serviceId,
        },
        options: Options(
          contentType: Headers.jsonContentType,
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      // Successful response (status 2xx)
      return OrderDto.fromJson(response.data);
    } on DioException catch (e) {
      // Convert DioException to ApiException and rethrow.
      throw _handleDioError(e);
    }
  }

  /// Converts a [DioException] into an [ApiException] with a user-friendly message.
  ApiException _handleDioError(DioException e) {
    // Timeout errors
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return ApiException('Request timeout after 10 seconds');
    }

    // No internet connection / connection refused
    if (e.type == DioExceptionType.connectionError) {
      return ApiException('No internet connection');
    }

    // Server responded with an error status (4xx, 5xx)
    if (e.response != null) {
      final statusCode = e.response!.statusCode;
      String message = 'Server error';

      // Try to extract error message from response body
      try {
        final data = e.response!.data;
        if (data is Map && data.containsKey('message')) {
          message = data['message'] as String;
        } else if (data is String) {
          message = data;
        }
      } catch (_) {
        // ignore
      }

      return ApiException(
        message,
        statusCode: statusCode,
      );
    }

    // Other errors (cancelled, etc.)
    return ApiException('Unexpected error: ${e.message}');
  }
}