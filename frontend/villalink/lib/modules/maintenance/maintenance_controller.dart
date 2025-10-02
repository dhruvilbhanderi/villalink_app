import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../data/services/api_service.dart';
import '../../data/services/auth_service.dart';
import '../../data/models/user_model.dart';
import '../../data/models/maintenance_model.dart';
import '../../shared/utils/app_snackbar.dart';
import '../../shared/widgets/common_button.dart';
import '../../shared/themes/app_colors.dart';

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
      if (Get.context != null) {
        AppSnackBar.showError(Get.context!, 'Failed to load maintenance records');
      }
    } finally {
      isLoading.value = false;
    }
  }

  void payMaintenance(Maintenance maintenance) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: const Icon(
                  Icons.payment_outlined,
                  color: AppColors.success,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),
              
              // Title
              const Text(
                'Confirm Payment',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              
              // Message
              Text(
                'Are you sure you want to pay ₹${maintenance.amount.toStringAsFixed(2)}?',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),
              
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: CommonButton.outline(
                      text: 'Cancel',
                      onPressed: () => Get.back(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CommonButton.success(
                      text: 'Pay Now',
                      onPressed: () => _processPayment(maintenance),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
        if (Get.context != null) {
          AppSnackBar.showSuccess(Get.context!, 'Payment processed successfully!');
        }
      } else {
        if (Get.context != null) {
          AppSnackBar.showError(Get.context!, response['message'] ?? 'Payment failed');
        }
      }
    } catch (e) {
      if (Get.context != null) {
        AppSnackBar.showError(Get.context!, 'Something went wrong. Please try again.');
      }
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
}