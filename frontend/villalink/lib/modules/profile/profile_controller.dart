import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/auth_service.dart';
import '../../data/models/user_model.dart';
import '../../routes/app_routes.dart';

class ProfileController extends GetxController {
  User? get user => AuthService.to.currentUser;

  void editProfile() {
    // Get.dialog(
    //   AlertDialog(
    //     title: const Text('Edit Profile'),
    //     content: const Text('Profile editing feature will be available in the next update.'),
    //     actions: [
    //       TextButton(
    //         onPressed: () => Get.back(),
    //         child: const Text('OK'),
    //       ),
    //     ],
    //   ),
    // );
    Get.toNamed(AppRoutes.EDIT_PROFILE);
  }

  void openSettings() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              onTap: () {
                Get.back();
                Get.snackbar('Settings', 'Notifications settings coming soon!');
              },
            ),
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Privacy & Security'),
              onTap: () {
                Get.back();
                Get.snackbar('Settings', 'Privacy settings coming soon!');
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Language'),
              onTap: () {
                Get.back();
                Get.snackbar('Settings', 'Language settings coming soon!');
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void openHelp() {
    Get.dialog(
      AlertDialog(
        title: const Text('Help & Support'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('For any queries or support:'),
            SizedBox(height: 10),
            Text('📧 Email: support@villalink.com'),
            Text('📞 Phone: +91 98765 43210'),
            Text('🕒 Support Hours: 9 AM - 6 PM'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Close')),
        ],
      ),
    );
  }

  void showAbout() {
    Get.dialog(
      AlertDialog(
        title: const Text('About VillaLink'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('VillaLink v1.0.0'),
            SizedBox(height: 10),
            Text(
              'A comprehensive society management application designed to streamline communication and operations within residential communities.',
            ),
            SizedBox(height: 10),
            Text('© 2024 VillaLink Solutions'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Close')),
        ],
      ),
    );
  }

  void showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              logout();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void logout() async {
    // Show loading dialog
    Get.dialog(
      const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text('Logging out...'),
          ],
        ),
      ),
      barrierDismissible: false,
    );

    // Simulate logout delay
    await Future.delayed(const Duration(seconds: 1));

    // Perform logout
    await AuthService.to.logout();

    // Close loading dialog and navigate to login
    Get.back(); // Close loading dialog
    Get.offAllNamed(AppRoutes.login);

    Get.snackbar(
      'Logged Out',
      'You have been successfully logged out.',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
