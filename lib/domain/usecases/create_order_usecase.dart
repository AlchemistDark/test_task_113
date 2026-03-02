import '../entities/order.dart';
import '../repositories/order_repository.dart';

/// Use case for creating an order.
/// Encapsulates the business logic of order creation.
class CreateOrderUseCase {
  final OrderRepository repository;

  /// Creates a [CreateOrderUseCase] with the given [repository].
  CreateOrderUseCase(this.repository);

  /// Executes the use case to create an order.
  ///
  /// [userId] – identifier of the user.
  /// [serviceId] – identifier of the service.
  ///
  /// Returns an [Order] on success, throws [ApiException] on failure.
  Future<Order> execute({required int userId, required int serviceId}) {
    return repository.createOrder(userId: userId, serviceId: serviceId);
  }
}