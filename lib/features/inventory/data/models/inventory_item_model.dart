import '../../domain/entities/inventory_item.dart';

class InventoryItemModel extends InventoryItem {
  const InventoryItemModel({
    required super.id,
    required super.name,
    required super.category,
    required super.quantity,
    required super.status,
    required super.lastUpdated,
    required super.warehouse,
    super.serialNumber,
    super.expiryDate,
    super.manufacturer,
    super.notes,
  });

  factory InventoryItemModel.fromEntity(InventoryItem entity) {
    return InventoryItemModel(
      id: entity.id,
      name: entity.name,
      category: entity.category,
      quantity: entity.quantity,
      status: entity.status,
      lastUpdated: entity.lastUpdated,
      warehouse: entity.warehouse,
      serialNumber: entity.serialNumber,
      expiryDate: entity.expiryDate,
      manufacturer: entity.manufacturer,
      notes: entity.notes,
    );
  }

  factory InventoryItemModel.fromJson(Map<String, dynamic> json) {
    return InventoryItemModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      quantity: json['quantity'] ?? 0,
      status: json['status'] ?? 'inStock',
      lastUpdated: json['lastUpdated'] ?? '',
      warehouse: json['warehouse'] ?? '',
      serialNumber: json['serialNumber'],
      expiryDate: json['expiryDate'],
      manufacturer: json['manufacturer'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'quantity': quantity,
      'status': status,
      'lastUpdated': lastUpdated,
      'warehouse': warehouse,
      'serialNumber': serialNumber,
      'expiryDate': expiryDate,
      'manufacturer': manufacturer,
      'notes': notes,
    };
  }
}
