import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import 'logout_dialog.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showLogout;
  final VoidCallback? onLogout;
  final bool centerTitle;
  final Color? backgroundColor;

  const CommonAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.leading,
    this.showLogout = false,
    this.onLogout,
    this.centerTitle = false,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: centerTitle,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: leading,
        actions: [
          ...?actions,
          if (showLogout)
            IconButton(
              icon: const Icon(
                Icons.logout_outlined,
                color: Colors.white,
              ),
              onPressed: () => _showLogoutDialog(context),
            ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => LogoutDialog(
        onLogout: onLogout ?? () {},
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final VoidCallback? onProfileTap;
  final VoidCallback? onLogout;

  const DashboardAppBar({
    Key? key,
    required this.userName,
    this.onProfileTap,
    this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'VillaLink',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Welcome, $userName',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.account_circle_outlined,
              color: Colors.white,
              size: 28,
            ),
            onPressed: onProfileTap,
          ),
          IconButton(
            icon: const Icon(
              Icons.logout_outlined,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => LogoutDialog(
        onLogout: onLogout ?? () {},
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
