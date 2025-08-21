import 'package:get/get.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';

class SplashController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    print("=== Starting _checkAuthStatus ===");

    try {
      print("AuthService registered: ${Get.isRegistered<AuthService>()}");
      print("AuthService instance: ${AuthService.to}");

      await Future.delayed(const Duration(seconds: 2));
      print("Delay completed");

      print("isLoggedIn = ${AuthService.to.isLoggedIn}");
      print("currentUser = ${AuthService.to.currentUser}");

      if (AuthService.to.isLoggedIn) {
        print("Attempting navigation to dashboard");
        Get.offAllNamed(AppRoutes.dashboard);
        print("Navigation call completed");
      } else {
        print("Attempting navigation to login");
        Get.offAllNamed(AppRoutes.login);
        print("Navigation call completed");
      }
    } catch (e, stackTrace) {
      print("Error in _checkAuthStatus: $e");
      print("StackTrace: $stackTrace");
      Get.offAllNamed(AppRoutes.login);
    }

    print("=== _checkAuthStatus completed ===");
  }
}
