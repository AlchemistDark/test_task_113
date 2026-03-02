/// Data Transfer Object for order data received from the API.
class OrderDto {
  /// Unique identifier of the order.
  final int orderId;

  /// Current status of the order.
  final String status;

  /// Optional payment URL.
  final String? paymentUrl;

  /// Creates an [OrderDto].
  const OrderDto({
    required this.orderId,
    required this.status,
    this.paymentUrl,
  });

  /// Factory constructor to create an [OrderDto] from JSON.
  factory OrderDto.fromJson(Map<String, dynamic> json) {
    return OrderDto(
      orderId: json['order_id'] as int,
      status: json['status'] as String,
      paymentUrl: json['payment_url'] as String?,
    );
  }
}