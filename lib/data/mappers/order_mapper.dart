import '../../domain/entities/order.dart';
import '../datasources/remote/models/order_dto.dart';

/// Mapper class to convert between [OrderDto] and [Order].
class OrderMapper {
  /// Converts an [OrderDto] to a domain [Order] entity.
  Order toEntity(OrderDto dto) {
    return Order(
      orderId: dto.orderId,
      status: dto.status,
      paymentUrl: dto.paymentUrl,
    );
  }

  /// Optionally, converts an [Order] entity back to an [OrderDto].
  /// Not used in this example but can be added for completeness.
  OrderDto toDto(Order entity) {
    return OrderDto(
      orderId: entity.orderId,
      status: entity.status,
      paymentUrl: entity.paymentUrl,
    );
  }
}