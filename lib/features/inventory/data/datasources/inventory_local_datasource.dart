import 'dart:convert';
import 'package:milstock/core/network/api_client.dart';
import 'package:milstock/features/inventory/data/models/inventory_item_model.dart';
import 'package:milstock/features/inventory/data/models/supply_request_model.dart';
import 'package:milstock/features/inventory/data/models/notification_model.dart';
import 'package:milstock/features/inventory/data/models/stock_movement_model.dart';

abstract class InventoryLocalDataSource {
  Future<List<InventoryItemModel>> getInventoryItems();
  Future<void> addInventoryItem(InventoryItemModel item);
  Future<void> updateInventoryItem(InventoryItemModel item);
  Future<void> deleteInventoryItem(String id);
  Future<List<SupplyRequestModel>> getSupplyRequests();
  Future<List<NotificationModel>> getNotifications();
  Future<List<Map<String, dynamic>>> getWarehouses();
  Future<List<StockMovementModel>> getMovements();
}

class InventoryLocalDataSourceImpl implements InventoryLocalDataSource {
  final ApiClient apiClient;

  InventoryLocalDataSourceImpl({required this.apiClient});

  // Mock data as fallback
  final List<InventoryItemModel> _mockItems = [
    const InventoryItemModel(
      id: 'INV-001',
      name: 'itemMre',
      category: 'Food',
      quantity: 2500,
      status: 'inStock',
      lastUpdated: '2026-06-14',
      warehouse: 'whA',
    ),
    const InventoryItemModel(
      id: 'INV-002',
      name: 'itemFirstAid',
      category: 'Medical',
      quantity: 150,
      status: 'lowStock',
      lastUpdated: '2026-06-12',
      warehouse: 'whB',
    ),
    const InventoryItemModel(
      id: 'INV-003',
      name: 'itemBoots',
      category: 'Equipment',
      quantity: 500,
      status: 'inStock',
      lastUpdated: '2026-06-10',
      warehouse: 'whA',
    ),
  ];

  final List<SupplyRequestModel> _mockRequests = [
    const SupplyRequestModel(
      id: 'REQ-1234',
      itemName: 'itemMreX500',
      unit: 'unitFirstCompany',
      quantity: 500,
      status: 'pending',
      time: 'time10m',
    ),
    const SupplyRequestModel(
      id: 'REQ-1233',
      itemName: 'itemMedicalEquipX200',
      unit: 'unitInfantry',
      quantity: 200,
      status: 'approved',
      time: 'time1hAgo',
    ),
  ];

  final List<NotificationModel> _mockNotifications = [
    const NotificationModel(
      id: '1',
      category: 'inventory',
      titleKey: 'notificationLowStock',
      message: 'msgLowStock',
      time: 'time5m',
      type: 'error',
      isRead: false,
    ),
    const NotificationModel(
      id: '2',
      category: 'validity',
      titleKey: 'notificationExpiration',
      message: 'msgExpiration',
      time: 'time1h',
      type: 'warning',
      isRead: false,
    ),
    const NotificationModel(
      id: '3',
      category: 'requests',
      titleKey: 'notificationApproved',
      message: 'msgApproved',
      time: 'time2h',
      type: 'success',
      isRead: false,
    ),
    const NotificationModel(
      id: '4',
      category: 'system',
      titleKey: 'notificationSystem',
      message: 'msgAudit',
      time: 'time5h',
      type: 'info',
      isRead: true,
    ),
    const NotificationModel(
      id: '5',
      category: 'requests',
      titleKey: 'notificationReview',
      message: 'msgReview',
      time: 'time1d',
      type: 'info',
      isRead: true,
    ),
  ];

  @override
  Future<List<InventoryItemModel>> getInventoryItems() async {
    try {
      final response = await apiClient.get('/products');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => InventoryItemModel.fromJson(item)).toList();
      }
      return _mockItems;
    } catch (e) {
      return _mockItems;
    }
  }

  @override
  Future<void> addInventoryItem(InventoryItemModel item) async {
    try {
      final response = await apiClient.post('/products', item.toJson());
      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      }
      _mockItems.insert(0, item);
    } catch (e) {
      _mockItems.insert(0, item);
    }
  }

  @override
  Future<void> updateInventoryItem(InventoryItemModel item) async {
    try {
      final response = await apiClient.put('/products/${item.id}', item.toJson());
      if (response.statusCode == 200) {
        return;
      }
      _updateLocalMock(item);
    } catch (e) {
      _updateLocalMock(item);
    }
  }

  void _updateLocalMock(InventoryItemModel item) {
    final index = _mockItems.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _mockItems[index] = item;
    }
  }

  @override
  Future<void> deleteInventoryItem(String id) async {
    try {
      final response = await apiClient.delete('/products/$id');
      if (response.statusCode == 200 || response.statusCode == 204) {
        return;
      }
      _mockItems.removeWhere((item) => item.id == id);
    } catch (e) {
      _mockItems.removeWhere((item) => item.id == id);
    }
  }

  @override
  Future<List<SupplyRequestModel>> getSupplyRequests() async {
    try {
      final response = await apiClient.get('/orders');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => SupplyRequestModel.fromJson(item)).toList();
      }
      return _mockRequests;
    } catch (e) {
      return _mockRequests;
    }
  }

  @override
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await apiClient.get('/notifications');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => NotificationModel.fromJson(item)).toList();
      }
      return _mockNotifications;
    } catch (e) {
      return _mockNotifications;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getWarehouses() async {
    try {
      final response = await apiClient.get('/warehouses');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      return [
        {'id': 'Warehouse A', 'name': 'whA'},
        {'id': 'Warehouse B', 'name': 'whB'},
        {'id': 'Warehouse C', 'name': 'whC'},
      ];
    }
  }

  @override
  Future<List<StockMovementModel>> getMovements() async {
    try {
      final response = await apiClient.get('/movements');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => StockMovementModel.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
