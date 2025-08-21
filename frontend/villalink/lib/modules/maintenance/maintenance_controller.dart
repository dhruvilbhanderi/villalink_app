import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../data/services/api_service.dart';
import '../../data/services/auth_service.dart';
import '../../data/models/user_model.dart';
import '../../data/models/maintenance_model.dart';

class MaintenanceController extends GetxController {
  final RxList<Maintenance> maintenanceRecords = <Maintenance>[].obs;
  final RxBool isLoading = false.obs;

  User? get user => AuthService.to.currentUser;

  double get totalOutstanding {
    return maintenanceRecords
        .where((m) => !m.isPaid)
        .fold(0.0, (sum, m) => sum + m.amount);
  }

  int get paidCount => maintenanceRecords.where((m) => m.isPaid).length;
  int get pendingCount => maintenanceRecords.where((m) => !m.isPaid && !m.isOverdue).length;
  int get overdueCount => maintenanceRecords.where((m) => m.isOverdue).length;

  @override
  void onInit() {
    super.onInit();
    loadMaintenance();
  }

  Future<void> loadMaintenance() async {
    isLoading.value = true;

    try {
      final response = await ApiService.get('/maintenance/get_maintenance.php', queryParams: {
        'user_id': user?.id.toString() ?? '',
        'user_type': user?.userType ?? '',
      });

      if (response['success'] == true) {
        final maintenanceList = (response['maintenance'] as List)
            .map((json) => Maintenance.fromJson(json))
            .toList();
        maintenanceRecords.assignAll(maintenanceList);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load maintenance records');
    } finally {
      isLoading.value = false;
    }
  }

  void payMaintenance(Maintenance maintenance) {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirm Payment'),
        content: Text(
          'Are you sure you want to pay ₹${maintenance.amount.toStringAsFixed(2)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => _processPayment(maintenance),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
            ),
            child: const Text(
              'Confirm',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _processPayment(Maintenance maintenance) async {
    Get.back(); // Close dialog

    try {
      final response = await ApiService.post('/maintenance/update_payment.php', {
        'maintenance_id': maintenance.id,
        'status': 'paid',
      });

      if (response['success'] == true) {
        loadMaintenance(); // Refresh data
        Get.snackbar(
          'Success',
          'Payment processed successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Payment failed',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
}