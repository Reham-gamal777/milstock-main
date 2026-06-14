import '../../domain/entities/supply_request.dart';

class SupplyRequestModel extends SupplyRequest {
  const SupplyRequestModel({
    required super.id,
    required super.itemName,
    required super.unit,
    required super.quantity,
    required super.status,
    required super.time,
  });

  factory SupplyRequestModel.fromJson(Map<String, dynamic> json) {
    return SupplyRequestModel(
      id: json['id'] ?? '',
      itemName: json['itemName'] ?? '',
      unit: json['unit'] ?? '',
      quantity: json['quantity'] ?? 0,
      status: json['status'] ?? 'pending',
      time: json['time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemName': itemName,
      'unit': unit,
      'quantity': quantity,
      'status': status,
      'time': time,
    };
  }
}
