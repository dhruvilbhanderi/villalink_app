import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/api_service.dart';

class UpdateComplaintController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Incoming data
  late final int complaintId;
  late final String initialStatus;

  // Form fields
  final RxString status = ''.obs;
  final TextEditingController noteController = TextEditingController();

  // UI state
  final RxBool isLoading = false.obs;

  // Allowed statuses (match your backend values).
  final List<String> statusOptions = [
    'pending',
    'in_progress',
    'resolved',
    'closed',
  ];

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args is Map<String, dynamic>) {
      complaintId = args['id'] is int
          ? args['id']
          : int.tryParse(args['id'].toString()) ?? -1;
      initialStatus = (args['status']?.toString() ?? 'pending');
    } else {
      // If caller passed a Complaint object
      final complaint = args;
      complaintId = complaint?.id ?? -1;
      initialStatus = complaint?.status ?? 'pending';
    }

    // Set dropdown initial value
    if (statusOptions.contains(initialStatus)) {
      status.value = initialStatus;
    } else {
      status.value = '';
    }
  }

  @override
  void onClose() {
    noteController.dispose();
    super.onClose();
  }

  bool _isSuccess(dynamic val) {
    if (val == null) return false;
    if (val is bool) return val;
    if (val is int) return val == 1;
    if (val is String) {
      return val.toLowerCase() == 'true' || val == '1';
    }
    return false;
  }

  Future<void> updateComplaint() async {
    if (!formKey.currentState!.validate()) return;

    if (status.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a status',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      final payload = {
        'complaint_id': complaintId.toString(),
        'status': status.value,
        'note': noteController.text.trim(),
      };

      final response = await ApiService.post(
        '/complaints/update_complaint.php',
        payload,
      );

      if (_isSuccess(response['success'])) {
        Get.snackbar(
          'Success',
          response['message'] ?? 'Complaint updated',
          snackPosition: SnackPosition.BOTTOM,
        );

        isLoading.value = false;
        Get.back(
          result: {
            'updated': true,
            'complaint_id': complaintId,
            'status': status.value,
            'note': noteController.text.trim(),
          },
        );
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to update complaint',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Network error: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
