import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/api_service.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/models/user_model.dart';
import '../../../routes/app_routes.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;

  void togglePasswordVisibility() {
    obscurePassword.toggle();
  }

  void login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final response = await ApiService.post('/auth/login.php', {
        'email': emailController.text.trim(),
        'password': passwordController.text,
      });


      if (response['success'] == true) {
        final user = User.fromJson(response['user']);
        await AuthService.to.saveUser(user);

        Get.offAllNamed(AppRoutes.dashboard);
        Get.snackbar(
          'Success',
          'Welcome back, ${user.name}!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        print('-------> ${response['message']}');
        Get.snackbar(
          'Error',
          response['message'] ?? 'Login failed',
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

  void goToRegister() {
    Get.toNamed(AppRoutes.REGISTER);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}