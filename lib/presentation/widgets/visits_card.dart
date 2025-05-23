import 'package:flutter/material.dart';
import '../../domain/entities/visit.dart';

class VisitCard extends StatelessWidget {
  final Visit visit;
  final String customerName;

  const VisitCard({
    super.key,
    required this.visit,
    required this.customerName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    customerName,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                _buildStatusChip(visit.status),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${visit.visitDate.day}/${visit.visitDate.month}/${visit.visitDate.year}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            if (visit.location != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(child: Text(visit.location!)),
                ],
              ),
            ],
            if (visit.notes != null) ...[
              const SizedBox(height: 8),
              Text(visit.notes!, maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
            if (visit.activitiesDone.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Activities: ${visit.activitiesDone.length} completed',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'completed':
        color = Colors.green;
        break;
      case 'pending':
        color = Colors.orange;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}