import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../data/services/api_service.dart';
import '../../data/services/auth_service.dart';
import '../../data/models/user_model.dart';
import '../../data/models/complaint_model.dart';
import '../../routes/app_routes.dart';

class ComplaintsController extends GetxController {
  final RxList<Complaint> complaints = <Complaint>[].obs;
  final RxBool isLoading = false.obs;
  final RxInt deletingId = (-1).obs;

  User? get user => AuthService.to.currentUser;

  @override
  void onInit() {
    super.onInit();
    loadComplaints();
  }

  Future<void> loadComplaints() async {
    isLoading.value = true;

    try {
      final response = await ApiService.get('/complaints/get_complaints.php', queryParams: {
        'user_id': user?.id.toString() ?? '',
        'user_type': user?.userType ?? '',
      });

      if (response['success'] == true) {
        final complaintsList = (response['complaints'] as List)
            .map((json) => Complaint.fromJson(json))
            .toList();
        complaints.assignAll(complaintsList);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load complaints');
    } finally {
      isLoading.value = false;
    }
  }

  void goToCreateComplaint() {
    Get.toNamed(AppRoutes.CREATE_COMPLAINT);
  }

  String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy HH:mm').format(date);
  }
  Future<void> deleteComplaintById(int complaintId) async {
    if (complaintId <= 0) return;

    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Confirm delete'),
        content: const Text('Are you sure you want to permanently delete this complaint?'),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('No')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Get.back(result: true),
            child: const Text('Yes, delete'),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    if (confirm != true) return;

    try {
      deletingId.value = complaintId;
      final resp = await ApiService.post('/complaints/delete_complaint.php', {
        'complaint_id': complaintId.toString(),
      });

      if (resp['success'] == true) {
        // remove locally
        final idx = complaints.indexWhere((c) => c.id == complaintId);
        if (idx != -1) complaints.removeAt(idx);

        Get.snackbar('Deleted', resp['message'] ?? 'Complaint deleted',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Error', resp['message'] ?? 'Failed to delete', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      deletingId.value = -1;
    }
  }
}