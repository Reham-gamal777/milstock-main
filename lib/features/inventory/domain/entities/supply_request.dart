class SupplyRequest {
  final String id;
  final String itemName;
  final String unit;
  final int quantity;
  final String status; // 'pending', 'approved', 'delivered'
  final String time;

  const SupplyRequest({
    required this.id,
    required this.itemName,
    required this.unit,
    required this.quantity,
    required this.status,
    required this.time,
  });

  SupplyRequest copyWith({
    String? id,
    String? itemName,
    String? unit,
    int? quantity,
    String? status,
    String? time,
  }) {
    return SupplyRequest(
      id: id ?? this.id,
      itemName: itemName ?? this.itemName,
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
      time: time ?? this.time,
    );
  }
}
