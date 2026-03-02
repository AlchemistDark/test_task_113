import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/order_controller.dart';

/// A screen that allows the user to create an order.
///
/// Displays a button, loading indicator, success information, or error message
/// based on the state of [OrderController].
class OrderScreen extends StatelessWidget {
  /// Creates an [OrderScreen].
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Order')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<OrderController>(
          builder: (context, controller, child) {
            // Show loading indicator
            if (controller.state == OrderState.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            // Show success details
            if (controller.state == OrderState.success &&
                controller.order != null) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 80),
                  const SizedBox(height: 16),
                  Text(
                    'Order created!',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text('Order ID: ${controller.order!.orderId}'),
                  Text('Status: ${controller.order!.status}'),
                  if (controller.order!.paymentUrl != null)
                    Text('Payment URL: ${controller.order!.paymentUrl}'),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => controller.reset(),
                    child: const Text('Create another'),
                  ),
                ],
              );
            }

            // Show error with retry button
            if (controller.state == OrderState.error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 60),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${controller.errorMessage}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => _createOrder(controller),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            // Initial state: show the create button
            return Center(
              child: ElevatedButton(
                onPressed: controller.state == OrderState.loading
                    ? null
                    : () => _createOrder(controller),
                child: const Text('Create Order'),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Helper method to trigger order creation with sample data.
  ///
  /// In a real app, you would take userId and serviceId from input fields.
  void _createOrder(OrderController controller) {
    controller.submitOrder(123, 456);
  }
}