import '../models/inventory_item_model.dart';
import '../models/supply_request_model.dart';
import '../models/notification_model.dart';

abstract class InventoryLocalDataSource {
  Future<List<InventoryItemModel>> getInventoryItems();
  Future<void> addInventoryItem(InventoryItemModel item);
  Future<List<SupplyRequestModel>> getSupplyRequests();
  Future<List<NotificationModel>> getNotifications();
}

class InventoryLocalDataSourceImpl implements InventoryLocalDataSource {
  // Mock database
  final List<InventoryItemModel> _items = [
    const InventoryItemModel(
      id: 'INV-001',
      name: 'MRE Rations Type A',
      category: 'Food',
      quantity: 2500,
      status: 'inStock',
      lastUpdated: '2026-06-14',
      warehouse: 'Warehouse A',
      serialNumber: 'SN-MRE-9482',
      expiryDate: '2027-12-31',
      manufacturer: 'Alpha Company',
      notes: 'Standard field rations. Store in cool, dry place.',
    ),
    const InventoryItemModel(
      id: 'INV-002',
      name: 'First Aid Kit',
      category: 'Medical',
      quantity: 150,
      status: 'lowStock',
      lastUpdated: '2026-06-12',
      warehouse: 'Warehouse B',
      serialNumber: 'SN-MED-1029',
      expiryDate: '2026-09-15',
      manufacturer: 'Medical Supplies Inc',
      notes: 'Contains bandages, antiseptics, and emergency tools.',
    ),
    const InventoryItemModel(
      id: 'INV-003',
      name: 'Water Purification Tablets',
      category: 'Supplies',
      quantity: 5000,
      status: 'inStock',
      lastUpdated: '2026-06-13',
      warehouse: 'Warehouse C',
      serialNumber: 'SN-WTR-3928',
      expiryDate: '2029-01-20',
      manufacturer: 'AquaPure Corp',
      notes: '1 tablet purifies 1 liter of fresh water.',
    ),
    const InventoryItemModel(
      id: 'INV-004',
      name: 'Combat Boots',
      category: 'Equipment',
      quantity: 500,
      status: 'inStock',
      lastUpdated: '2026-06-10',
      warehouse: 'Warehouse A',
      serialNumber: 'SN-BT-4029',
      expiryDate: 'N/A',
      manufacturer: 'Vanguard Leather',
      notes: 'All-weather terrain boots.',
    ),
  ];

  final List<SupplyRequestModel> _requests = [
    const SupplyRequestModel(
      id: 'REQ-1234',
      itemName: 'MRE Rations Type A x 500',
      unit: 'Alpha Company',
      quantity: 500,
      status: 'pending',
      time: '10 min ago',
    ),
    const SupplyRequestModel(
      id: 'REQ-1233',
      itemName: 'Medical Supplies x 200',
      unit: 'Bravo Unit',
      quantity: 200,
      status: 'approved',
      time: '1 hour ago',
    ),
    const SupplyRequestModel(
      id: 'REQ-1232',
      itemName: 'Water Bottles x 1000',
      unit: 'Charlie Battalion',
      quantity: 1000,
      status: 'delivered',
      time: '3 hours ago',
    ),
  ];

  final List<NotificationModel> _notifications = [
    const NotificationModel(
      id: 'N-001',
      message: 'Medical supplies running low at Warehouse B',
      time: '5 min ago',
      type: 'error',
    ),
    const NotificationModel(
      id: 'N-002',
      message: '50 items expiring within 7 days in Warehouse A',
      time: '15 min ago',
      type: 'warning',
    ),
    const NotificationModel(
      id: 'N-003',
      message: 'Request REQ-1233 approved for Bravo Unit',
      time: '2 hours ago',
      type: 'info',
    ),
    const NotificationModel(
      id: 'N-004',
      message: 'Monthly inventory report ready for download',
      time: '1 day ago',
      type: 'info',
    ),
  ];

  @override
  Future<List<InventoryItemModel>> getInventoryItems() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_items);
  }

  @override
  Future<void> addInventoryItem(InventoryItemModel item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _items.insert(0, item);
  }

  @override
  Future<List<SupplyRequestModel>> getSupplyRequests() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_requests);
  }

  @override
  Future<List<NotificationModel>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_notifications);
  }
}
