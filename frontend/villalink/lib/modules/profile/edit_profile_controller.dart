import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:villalink/data/models/user_model.dart';
import 'package:villalink/data/services/api_service.dart';
import 'package:villalink/data/services/auth_service.dart';

class EditProfileController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Text Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final flatNumberController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Reactive Variables
  final RxBool isLoading = false.obs;
  final RxBool isChangingPassword = false.obs;
  final RxBool obscureCurrentPassword = true.obs;
  final RxBool obscureNewPassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;

  User? get user => AuthService.to.currentUser;

  @override
  void onInit() {
    super.onInit();
    initializeFields();
  }

  void initializeFields() {
    final currentUser = user;
    if (currentUser != null) {
      nameController.text = currentUser.name;
      emailController.text = currentUser.email;
      phoneController.text = currentUser.phone ?? '';
      flatNumberController.text = currentUser.flatNumber ?? '';
    }
  }

  void togglePasswordChange(bool value) {
    isChangingPassword.value = value;
    if (!value) {
      // Clear password fields when toggle is off
      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
    }
  }

  void toggleCurrentPasswordVisibility() {
    obscureCurrentPassword.toggle();
  }

  void toggleNewPasswordVisibility() {
    obscureNewPassword.toggle();
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.toggle();
  }

  void updateProfile() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      Map<String, dynamic> updateData = {
        'user_id': user?.id,
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'flat_number': flatNumberController.text.trim(),
      };

      // Add password data if changing password
      if (isChangingPassword.value) {
        updateData['current_password'] = currentPasswordController.text;
        updateData['new_password'] = newPasswordController.text;
      }

      final response = await ApiService.post(
        '/user/update_profile.php',
        updateData,
      );
      print("UpdateProfile API raw response: $response");

      if (response['success'] == true) {
        final currentUser = AuthService.to.currentUser;
        if (currentUser != null) {
          final updatedUser = User(
            id: currentUser.id,
            name: nameController.text,
            email: emailController.text,
            phone: phoneController.text,
            flatNumber: flatNumberController.text,
            userType: currentUser.userType,
          );
          await AuthService.to.saveUser(updatedUser);
        }

        if (isChangingPassword.value) {
          currentPasswordController.clear();
          newPasswordController.clear();
          confirmPasswordController.clear();
          isChangingPassword.value = false;
        }

        Get.back();

        Get.snackbar(
          'Success',
          response['message'] ?? 'Profile updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Update failed',
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
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    flatNumberController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
