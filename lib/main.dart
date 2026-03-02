import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/datasources/remote/order_remote_data_source.dart';
import 'data/mappers/order_mapper.dart';
import 'data/repositories/order_repository_impl.dart';
import 'domain/usecases/create_order_usecase.dart';
import 'presentation/controllers/order_controller.dart';
import 'presentation/screens/order_screen.dart';

void main() {
  // Setup dependencies
  // The API address wasn't specified in the task,
  // so I chose the classic: 'https://example.com/api'
  final dio = Dio(BaseOptions(baseUrl: 'https://example.com/api'));
  final remoteDataSource = OrderRemoteDataSource(dio: dio);
  final mapper = OrderMapper();
  final repository = OrderRepositoryImpl(
    remoteDataSource: remoteDataSource,
    mapper: mapper,
  );
  final useCase = CreateOrderUseCase(repository);
  final controller = OrderController(createOrderUseCase: useCase);

  runApp(MyApp(controller: controller));
}

/// Root widget of the application.
class MyApp extends StatelessWidget {
  final OrderController controller;

  const MyApp({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      child: MaterialApp(
        title: 'Order Creation Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const OrderScreen(),
      ),
    );
  }
}