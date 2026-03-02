import 'package:flutter/material.dart';

import '../../domain/entities/order.dart';
import '../../domain/usecases/create_order_usecase.dart';
import '../../core/exceptions/api_exception.dart';

/// Possible states of the order creation process.
enum OrderState {
  /// No request has been made yet.
  initial,

  /// Request is in progress.
  loading,

  /// Order was created successfully.
  success,

  /// An error occurred.
  error,
}

/// Manages the state and logic for order creation in the presentation layer.
class OrderController extends ChangeNotifier {
  final CreateOrderUseCase createOrderUseCase;

  /// Creates an [OrderController] with the given [createOrderUseCase].
  OrderController({required this.createOrderUseCase});

  OrderState _state = OrderState.initial;
  Order? _order;
  String? _errorMessage;

  /// Current state of the controller.
  OrderState get state => _state;

  /// Created order (available only in [success] state).
  Order? get order => _order;

  /// Error message (available only in [error] state).
  String? get errorMessage => _errorMessage;

  /// Submits a request to create an order with the given [userId] and [serviceId].
  ///
  /// Switches state to [loading] immediately, then to [success] or [error].
  Future<void> submitOrder(int userId, int serviceId) async {
    _state = OrderState.loading;
    _errorMessage = null;
    _order = null;
    notifyListeners();

    try {
      final newOrder = await createOrderUseCase.execute(
        userId: userId,
        serviceId: serviceId,
      );
      _order = newOrder;
      _state = OrderState.success;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _state = OrderState.error;
    } catch (e) {
      _errorMessage = 'Unexpected error: $e';
      _state = OrderState.error;
    }
    notifyListeners();
  }

  /// Resets the controller to [initial] state.
  void reset() {
    _state = OrderState.initial;
    _order = null;
    _errorMessage = null;
    notifyListeners();
  }
}