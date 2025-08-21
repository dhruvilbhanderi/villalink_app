import 'package:flutter/material.dart';

class Maintenance {
  final int id;
  final int userId;
  final double amount;
  final DateTime dueDate;
  final String status;
  final DateTime createdAt;

  Maintenance({
    required this.id,
    required this.userId,
    required this.amount,
    required this.dueDate,
    required this.status,
    required this.createdAt,
  });

  factory Maintenance.fromJson(Map<String, dynamic> json) {
    return Maintenance(
      id: int.parse(json['id'].toString()),
      userId: int.parse(json['user_id'].toString()),
      amount: double.parse(json['amount'].toString()),
      dueDate: DateTime.parse(json['due_date']),
      status: json['status'] ?? 'pending',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  bool get isPaid => status == 'paid';
  bool get isOverdue => !isPaid && DateTime.now().isAfter(dueDate);

  Color get statusColor {
    if (isPaid) return Colors.green;
    if (isOverdue) return Colors.red;
    return Colors.orange;
  }

  String get statusText {
    if (isPaid) return 'PAID';
    if (isOverdue) return 'OVERDUE';
    return 'PENDING';
  }
}