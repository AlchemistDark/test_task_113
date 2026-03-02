import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/remote/order_remote_data_source.dart';
import '../mappers/order_mapper.dart';

/// Implementation of [OrderRepository] using remote data source.
class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  final OrderMapper mapper;

  /// Creates an [OrderRepositoryImpl] with the given dependencies.
  OrderRepositoryImpl({
    required this.remoteDataSource,
    required this.mapper,
  });

  @override
  Future<Order> createOrder({required int userId, required int serviceId}) async {
    // Delegate to remote data source
    final dto = await remoteDataSource.createOrder(userId, serviceId);
    // Convert DTO to domain entity
    return mapper.toEntity(dto);
  }
}