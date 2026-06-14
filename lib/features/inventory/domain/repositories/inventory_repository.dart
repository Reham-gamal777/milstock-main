import '../entities/inventory_item.dart';
import '../entities/supply_request.dart';
import '../entities/notification_item.dart';

abstract class InventoryRepository {
  Future<List<InventoryItem>> getInventoryItems();
  Future<void> addInventoryItem(InventoryItem item);
  Future<List<SupplyRequest>> getSupplyRequests();
  Future<List<NotificationItem>> getNotifications();
}
