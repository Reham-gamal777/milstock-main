import '../../domain/entities/inventory_item.dart';
import '../../domain/entities/supply_request.dart';
import '../../domain/entities/notification_item.dart';
import '../../domain/entities/stock_movement.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../datasources/inventory_local_datasource.dart';
import '../models/inventory_item_model.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryLocalDataSource localDataSource;

  InventoryRepositoryImpl({required this.localDataSource});

  @override
  Future<List<InventoryItem>> getInventoryItems() async {
    return await localDataSource.getInventoryItems();
  }

  @override
  Future<void> addInventoryItem(InventoryItem item) async {
    final model = InventoryItemModel.fromEntity(item);
    await localDataSource.addInventoryItem(model);
  }

  @override
  Future<void> updateInventoryItem(InventoryItem item) async {
    final model = InventoryItemModel.fromEntity(item);
    await localDataSource.updateInventoryItem(model);
  }

  @override
  Future<void> deleteInventoryItem(String id) async {
    await localDataSource.deleteInventoryItem(id);
  }

  @override
  Future<List<SupplyRequest>> getSupplyRequests() async {
    return await localDataSource.getSupplyRequests();
  }

  @override
  Future<List<NotificationItem>> getNotifications() async {
    return await localDataSource.getNotifications();
  }

  @override
  Future<List<Map<String, dynamic>>> getWarehouses() async {
    return await localDataSource.getWarehouses();
  }

  @override
  Future<List<StockMovement>> getMovements() async {
    return await localDataSource.getMovements();
  }
}
