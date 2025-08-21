import 'package:flutter/material.dart';
class Complaint {
  final int id;
  final String title;
  final String description;
  final String status;
  final String createdByName;
  final String? flatNumber;
  final DateTime createdAt;

  Complaint({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdByName,
    this.flatNumber,
    required this.createdAt,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      id: int.parse(json['id'].toString()),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'pending',
      createdByName: json['created_by_name'] ?? 'Unknown',
      flatNumber: json['flat_number'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Color get statusColor {
    switch (status) {
      case 'resolved':
        return Colors.green;
      case 'in_progress':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }
}