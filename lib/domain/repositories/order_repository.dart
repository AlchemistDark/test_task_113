import '../entities/order.dart';

/// Abstract repository interface for order-related operations.
abstract class OrderRepository {
  /// Creates a new order with the given [userId] and [serviceId].
  ///
  /// Returns an [Order] object on success.
  /// Throws [ApiException] on failure.
  Future<Order> createOrder({required int userId, required int serviceId});
}