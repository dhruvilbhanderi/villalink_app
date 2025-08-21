import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/api_service.dart';
import '../../data/services/auth_service.dart';

class CreateNoticeController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final RxBool isLoading = false.obs;

  void createNotice() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final response = await ApiService.post('/notices/create_notice.php', {
        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
        'created_by': AuthService.to.currentUser?.id,
      });

      if (response['success'] == true) {
        Get.back();
        Get.snackbar(
          'Success',
          'Notice created successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to create notice',
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
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}