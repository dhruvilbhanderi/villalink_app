import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import 'common_button.dart';

class LogoutDialog extends StatelessWidget {
  final VoidCallback onLogout;

  const LogoutDialog({
    Key? key,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 16,
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
                color: AppColors.errorLight,
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.logout_outlined,
                color: AppColors.error,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            
            // Title
            const Text(
              'Logout Confirmation',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            
            // Message
            const Text(
              'Are you sure you want to logout from your account?',
              textAlign: TextAlign.center,
              style: TextStyle(
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
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CommonButton.danger(
                    text: 'Logout',
                    onPressed: () {
                      Navigator.of(context).pop();
                      onLogout();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
