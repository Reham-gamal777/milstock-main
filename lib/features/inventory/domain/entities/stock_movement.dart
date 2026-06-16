class StockMovement {
  final String id;
  final String productId;
  final String productName;
  final String fromWarehouse;
  final String toWarehouse;
  final int quantity;
  final String status;
  final String timestamp;

  const StockMovement({
    required this.id,
    required this.productId,
    required this.productName,
    required this.fromWarehouse,
    required this.toWarehouse,
    required this.quantity,
    required this.status,
    required this.timestamp,
  });
}
