/// Represents an order entity in the domain layer.
class Order {
  /// Unique identifier of the order.
  final int orderId;

  /// Current status of the order (e.g., "pending", "confirmed").
  final String status;

  /// Optional URL for payment, if required.
  final String? paymentUrl;

  /// Creates an [Order] instance.
  const Order({
    required this.orderId,
    required this.status,
    this.paymentUrl,
  });
}