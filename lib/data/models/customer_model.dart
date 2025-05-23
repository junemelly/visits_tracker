import 'package:visits_tracker/domain/entities/customer.dart';

class CustomerModel extends Customer {
  const CustomerModel({
    required super.id,
    required super.name,
    required super.createdAt,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Unknown Customer',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }
}