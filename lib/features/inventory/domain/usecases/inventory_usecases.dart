import '../../../../core/usecase/usecase.dart';
import '../entities/inventory_item.dart';
import '../entities/supply_request.dart';
import '../entities/notification_item.dart';
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
