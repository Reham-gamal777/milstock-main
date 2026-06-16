import '../../domain/entities/stock_movement.dart';

class StockMovementModel extends StockMovement {
  const StockMovementModel({
    required super.id,
    required super.productId,
    required super.productName,
    required super.fromWarehouse,
    required super.toWarehouse,
    required super.quantity,
    required super.status,
    required super.timestamp,
  });

  factory StockMovementModel.fromJson(Map<String, dynamic> json) {
    return StockMovementModel(
      id: json['_id'] ?? json['id'] ?? '',
      productId: json['product_id'] ?? '',
      productName: json['product_name'] ?? 'Unknown Product',
      fromWarehouse: json['from_warehouse'] ?? '',
      toWarehouse: json['to_warehouse'] ?? '',
      quantity: json['quantity'] ?? 0,
      status: json['status'] ?? 'completed',
      timestamp: json['timestamp'] ?? json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product_name': productName,
      'from_warehouse': fromWarehouse,
      'to_warehouse': toWarehouse,
      'quantity': quantity,
      'status': status,
      'timestamp': timestamp,
    };
  }
}
