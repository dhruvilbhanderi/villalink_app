import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/api_service.dart';

class UpdateComplaintController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Incoming data (pass Complaint or map via Get.arguments)
  late final int complaintId;
  late final String initialStatus;

  // Form fields
  final RxString status = ''.obs;
  final TextEditingController noteController = TextEditingController();

  // UI state
  final RxBool isLoading = false.obs;

  // Allowed statuses (match your backend values). Add any statuses your backend might use.
  final List<String> statusOptions = [
    'pending',
    'in_progress',
    'resolved',
    'closed', // include closed if your backend uses it
    // add more if your backend supports
  ];

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    if (args is Map<String, dynamic>) {
      complaintId = args['id'] is int ? args['id'] : int.parse(args['id'].toString());
      initialStatus = (args['status']?.toString() ?? 'pending');
    } else {
      // If caller passed a Complaint object
      final complaint = args;
      complaintId = complaint?.id ?? -1;
      initialStatus = complaint?.status ?? 'pending';
    }

    // If initialStatus exists in statusOptions, set it; otherwise leave blank (null selection)
    if (statusOptions.contains(initialStatus)) {
      status.value = initialStatus;
    } else {
      // leave status empty so the dropdown shows no selection,
      // forcing the user to explicitly choose one if needed
      status.value = '';
    }
  }

  @override
  void onClose() {
    noteController.dispose();
    super.onClose();
  }

  Future<void> updateComplaint() async {
    if (!formKey.currentState!.validate()) return;

    // If status is empty, validation should already have prevented this,
    // but protect again:
    if (status.value.isEmpty) {
      Get.snackbar('Error', 'Please select a status', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    try {
      final payload = {
        'complaint_id': complaintId.toString(),
        'status': status.value,
        //'note': noteController.text.trim(),
      };

      final response = await ApiService.post('/complaints/update_complaint.php', payload);

      if (response['success'] == true) {
        Get.snackbar('Success', response['message'] ?? 'Complaint updated');
        Get.back(result: {
          'updated': true,
          'complaint_id': complaintId,
          'status': status.value,
          'note': noteController.text.trim(),
        });
      } else {
        Get.snackbar('Error', response['message'] ?? 'Failed to update complaint',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
