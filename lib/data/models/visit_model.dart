import 'package:visits_tracker/domain/entities/visit.dart';

class VisitModel extends Visit {
  const VisitModel({
    super.id,
    required super.customerId,
    required super.visitDate,
    required super.status,
    super.location,
    super.notes,
    required super.activitiesDone,
    required super.createdAt,
  });

  factory VisitModel.fromJson(Map<String, dynamic> json) {
    return VisitModel(
      id: json['id'] as int?,
      customerId: json['customer_id'] as int? ?? 0,
      visitDate: json['visit_date'] != null
          ? DateTime.parse(json['visit_date'] as String)
          : DateTime.now(),
      status: json['status'] as String? ?? 'Pending',
      location: json['location'] as String?,
      notes: json['notes'] as String?,
      activitiesDone: (json['activities_done'] as List?)
              ?.map((e) => int.tryParse(e.toString()) ?? 0)
          .toList() ??
          [],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'customer_id': customerId,
      'visit_date': visitDate.toIso8601String(),
      'status': status,
      if (location != null) 'location': location,
      if (notes != null) 'notes': notes,
      'activities_done': activitiesDone.map((e) => e.toString()).toList(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory VisitModel.fromEntity(Visit visit) {
    return VisitModel(
      id: visit.id,
      customerId: visit.customerId,
      visitDate: visit.visitDate,
      status: visit.status,
      location: visit.location,
      notes: visit.notes,
      activitiesDone: visit.activitiesDone,
      createdAt: visit.createdAt,
    );
  }
}