import '../../../../core/usecase/usecase.dart';
import '../entities/inventory_item.dart';
import '../entities/supply_request.dart';
import '../entities/notification_item.dart';
import '../entities/stock_movement.dart';
import '../repositories/inventory_repository.dart';

class GetInventoryItems implements UseCase<List<InventoryItem>, NoParams> {
  final InventoryRepository repository;

  GetInventoryItems(this.repository);

  @override
  Future<List<InventoryItem>> call(NoParams params) async {
    return await repository.getInventoryItems();
  }
}

class AddInventoryItem implements UseCase<void, InventoryItem> {
  final InventoryRepository repository;

  AddInventoryItem(this.repository);

  @override
  Future<void> call(InventoryItem item) async {
    await repository.addInventoryItem(item);
  }
}

class UpdateInventoryItem implements UseCase<void, InventoryItem> {
  final InventoryRepository repository;

  UpdateInventoryItem(this.repository);

  @override
  Future<void> call(InventoryItem item) async {
    await repository.updateInventoryItem(item);
  }
}

class DeleteInventoryItem implements UseCase<void, String> {
  final InventoryRepository repository;

  DeleteInventoryItem(this.repository);

  @override
  Future<void> call(String id) async {
    await repository.deleteInventoryItem(id);
  }
}

class GetSupplyRequests implements UseCase<List<SupplyRequest>, NoParams> {
  final InventoryRepository repository;

  GetSupplyRequests(this.repository);

  @override
  Future<List<SupplyRequest>> call(NoParams params) async {
    return await repository.getSupplyRequests();
  }
}

class GetNotifications implements UseCase<List<NotificationItem>, NoParams> {
  final InventoryRepository repository;

  GetNotifications(this.repository);

  @override
  Future<List<NotificationItem>> call(NoParams params) async {
    return await repository.getNotifications();
  }
}

class GetWarehouses implements UseCase<List<Map<String, dynamic>>, NoParams> {
  final InventoryRepository repository;

  GetWarehouses(this.repository);

  @override
  Future<List<Map<String, dynamic>>> call(NoParams params) async {
    return await repository.getWarehouses();
  }
}

class GetMovements implements UseCase<List<StockMovement>, NoParams> {
  final InventoryRepository repository;

  GetMovements(this.repository);

  @override
  Future<List<StockMovement>> call(NoParams params) async {
    return await repository.getMovements();
  }
}
