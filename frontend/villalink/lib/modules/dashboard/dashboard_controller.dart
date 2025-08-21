import 'package:get/get.dart';
import '../../data/services/auth_service.dart';
import '../../data/models/user_model.dart';
import '../../routes/app_routes.dart';

class DashboardController extends GetxController {
  User? get user => AuthService.to.currentUser;

  void goToProfile() {
    Get.toNamed(AppRoutes.PROFILE);
  }

  void goToNotices() {
    Get.toNamed(AppRoutes.NOTICES);
  }

  void goToComplaints() {
    Get.toNamed(AppRoutes.COMPLAINTS);
  }

  void goToMaintenance() {
    Get.toNamed(AppRoutes.MAINTENANCE);
  }

  void goToCreateNotice() {
    Get.toNamed(AppRoutes.CREATE_NOTICE);
  }

  void logout() async {
    await AuthService.to.logout();
    Get.offAllNamed(AppRoutes.login);
  }
}