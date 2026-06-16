import '../entities/inventory_item.dart';
import '../entities/supply_request.dart';
import '../entities/notification_item.dart';
import '../entities/stock_movement.dart';

abstract class InventoryRepository {
  Future<List<InventoryItem>> getInventoryItems();
  Future<void> addInventoryItem(InventoryItem item);
  Future<void> updateInventoryItem(InventoryItem item);
  Future<void> deleteInventoryItem(String id);
  Future<List<SupplyRequest>> getSupplyRequests();
  Future<List<NotificationItem>> getNotifications();
  Future<List<Map<String, dynamic>>> getWarehouses();
  Future<List<StockMovement>> getMovements();
}
