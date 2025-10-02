import 'package:flutter/material.dart';
import '../themes/app_colors.dart';

enum SnackBarType { success, error, warning, info }

class AppSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    final snackBar = SnackBar(
      content: _buildSnackBarContent(message, type),
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      duration: duration,
      margin: const EdgeInsets.all(16),
      padding: EdgeInsets.zero,
      action: actionLabel != null
          ? SnackBarAction(
              label: actionLabel,
              textColor: Colors.white,
              onPressed: onActionPressed ?? () {},
            )
          : null,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    show(
      context,
      message: message,
      type: SnackBarType.success,
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  static void showError(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    show(
      context,
      message: message,
      type: SnackBarType.error,
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  static void showWarning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    show(
      context,
      message: message,
      type: SnackBarType.warning,
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  static void showInfo(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onActionPressed,
  }) {
    show(
      context,
      message: message,
      type: SnackBarType.info,
      duration: duration,
      actionLabel: actionLabel,
      onActionPressed: onActionPressed,
    );
  }

  static Widget _buildSnackBarContent(String message, SnackBarType type) {
    final config = _getSnackBarConfig(type);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: config.backgroundColor.withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              config.icon,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static _SnackBarConfig _getSnackBarConfig(SnackBarType type) {
    switch (type) {
      case SnackBarType.success:
        return _SnackBarConfig(
          backgroundColor: AppColors.success,
          icon: Icons.check_circle_outline,
        );
      case SnackBarType.error:
        return _SnackBarConfig(
          backgroundColor: AppColors.error,
          icon: Icons.error_outline,
        );
      case SnackBarType.warning:
        return _SnackBarConfig(
          backgroundColor: AppColors.warning,
          icon: Icons.warning_outlined,
        );
      case SnackBarType.info:
        return _SnackBarConfig(
          backgroundColor: AppColors.info,
          icon: Icons.info_outline,
        );
    }
  }
}

class _SnackBarConfig {
  final Color backgroundColor;
  final IconData icon;

  _SnackBarConfig({
    required this.backgroundColor,
    required this.icon,
  });
}
