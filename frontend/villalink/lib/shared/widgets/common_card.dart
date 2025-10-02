import 'package:flutter/material.dart';
import '../themes/app_colors.dart';

class CommonCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;

  const CommonCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.all(0),
      child: Material(
        color: backgroundColor ?? Colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        elevation: elevation ?? 2,
        shadowColor: Colors.black.withOpacity(0.1),
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? BorderRadius.circular(16),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final String? subtitle;

  const DashboardCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.color,
    this.onTap,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.1),
                  color.withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Icon(
              icon,
              size: 32,
              color: color,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class StatusCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;

  const StatusCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          // const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class MemberCard extends StatelessWidget {
  final String name;
  final String email;
  final String? flatNumber;
  final bool isActive;
  final VoidCallback? onToggle;

  const MemberCard({
    Key? key,
    required this.name,
    required this.email,
    this.flatNumber,
    required this.isActive,
    this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isActive
                        ? [AppColors.success.withOpacity(0.1), AppColors.success.withOpacity(0.2)]
                        : [AppColors.error.withOpacity(0.1), AppColors.error.withOpacity(0.2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  Icons.person,
                  color: isActive ? AppColors.success : AppColors.error,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (flatNumber != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Flat: $flatNumber',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.successLight : AppColors.errorLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isActive ? Icons.check_circle : Icons.cancel,
                          size: 10,
                          color: isActive ? AppColors.success : AppColors.error,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          isActive ? 'Active' : 'Inactive',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: isActive ? AppColors.success : AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Switch(
                    value: isActive,
                    onChanged: (_) => onToggle?.call(),
                    activeColor: AppColors.success,
                    inactiveThumbColor: AppColors.error,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
