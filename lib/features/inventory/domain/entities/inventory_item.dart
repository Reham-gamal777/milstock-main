class InventoryItem {
  final String id;
  final String name;
  final String category;
  final int quantity;
  final String status; // 'inStock', 'lowStock', 'outOfStock'
  final String lastUpdated;
  final String warehouse;
  final String? serialNumber;
  final String? expiryDate;
  final String? manufacturer;
  final String? notes;

  const InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.status,
    required this.lastUpdated,
    required this.warehouse,
    this.serialNumber,
    this.expiryDate,
    this.manufacturer,
    this.notes,
  });

  InventoryItem copyWith({
    String? id,
    String? name,
    String? category,
    int? quantity,
    String? status,
    String? lastUpdated,
    String? warehouse,
    String? serialNumber,
    String? expiryDate,
    String? manufacturer,
    String? notes,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      warehouse: warehouse ?? this.warehouse,
      serialNumber: serialNumber ?? this.serialNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      manufacturer: manufacturer ?? this.manufacturer,
      notes: notes ?? this.notes,
    );
  }
}
