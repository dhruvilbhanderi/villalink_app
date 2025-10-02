import 'package:flutter/material.dart';
import '../themes/app_colors.dart';

enum ButtonSize { small, medium, large }

class CommonButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final ButtonSize size;
  final bool isOutlined;
  final bool isLoading;
  final double? width;

  const CommonButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.size = ButtonSize.medium,
    this.isOutlined = false,
    this.isLoading = false,
    this.width,
  }) : super(key: key);

  // Primary button
  const CommonButton.primary({
    Key? key,
    required this.text,
    this.onPressed,
    this.icon,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.width,
  }) : backgroundColor = AppColors.primary,
       textColor = Colors.white,
       borderColor = null,
       isOutlined = false,
       super(key: key);

  // Secondary button
  const CommonButton.secondary({
    Key? key,
    required this.text,
    this.onPressed,
    this.icon,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.width,
  }) : backgroundColor = AppColors.secondary,
       textColor = Colors.white,
       borderColor = null,
       isOutlined = false,
       super(key: key);

  // Success button
  const CommonButton.success({
    Key? key,
    required this.text,
    this.onPressed,
    this.icon,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.width,
  }) : backgroundColor = AppColors.success,
       textColor = Colors.white,
       borderColor = null,
       isOutlined = false,
       super(key: key);

  // Danger button
  const CommonButton.danger({
    Key? key,
    required this.text,
    this.onPressed,
    this.icon,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.width,
  }) : backgroundColor = AppColors.error,
       textColor = Colors.white,
       borderColor = null,
       isOutlined = false,
       super(key: key);

  // Outline button
  const CommonButton.outline({
    Key? key,
    required this.text,
    this.onPressed,
    this.icon,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.width,
    Color? borderColor,
  }) : backgroundColor = Colors.transparent,
       textColor = borderColor ?? AppColors.primary,
       borderColor = borderColor ?? AppColors.primary,
       isOutlined = true,
       super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonHeight = _getButtonHeight();
    final fontSize = _getFontSize();
    final padding = _getPadding();

    return SizedBox(
      width: width,
      height: buttonHeight,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: textColor,
                side: BorderSide(
                  color: borderColor ?? AppColors.primary,
                  width: 1.5,
                ),
                padding: padding,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _buildButtonContent(fontSize),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                foregroundColor: textColor,
                elevation: 2,
                padding: padding,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _buildButtonContent(fontSize),
            ),
    );
  }

  Widget _buildButtonContent(double fontSize) {
    if (isLoading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              textColor ?? Colors.white,
            ),
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: fontSize + 2),
          const SizedBox(width: 8),
          // Allow the text to shrink / ellipsize instead of overflowing
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    }

    // No icon: make single-line text ellipsize too (helps when placed inside tight layouts)
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
      ),
    );
  }


  double _getButtonHeight() {
    switch (size) {
      case ButtonSize.small:
        return 36;
      case ButtonSize.medium:
        return 48;
      case ButtonSize.large:
        return 56;
    }
  }

  double _getFontSize() {
    switch (size) {
      case ButtonSize.small:
        return 14;
      case ButtonSize.medium:
        return 16;
      case ButtonSize.large:
        return 18;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }
}
