import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:villalink/data/models/user_model.dart';
import 'package:villalink/modules/dashboard/dashboard_controller.dart';
import '../../shared/widgets/common_app_bar.dart';
import '../../shared/widgets/common_card.dart';
import '../../shared/widgets/common_button.dart';
import '../../shared/themes/app_colors.dart';
import '../../shared/utils/app_snackbar.dart';


class DashboardView extends StatelessWidget {
  DashboardView({Key? key}) : super(key: key);

  final controller =  Get.isRegistered<DashboardController>()
      ? Get.find<DashboardController>()
      : Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: AppColors.background,
      appBar: DashboardAppBar(
        userName: controller.user?.name ?? "User",
        onProfileTap: controller.goToProfile,
        onLogout: controller.logout,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    offset: const Offset(0, 4),
                    blurRadius: 16,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'VillaLink Dashboard',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(() => Text(
                    controller.user?.isPresident == true
                        ? 'President Panel - Manage your community'
                        : 'Member Panel - Stay connected',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  )),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Obx(() => Text(
                      controller.user?.isPresident == true ? 'Administrator' : 'Resident',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    )),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                DashboardCard(
                  title: 'Notices',
                  icon: Icons.announcement_outlined,
                  color: AppColors.warning,
                  onTap: controller.goToNotices,
                  subtitle: 'View announcements',
                ),
                DashboardCard(
                  title: 'Complaints',
                  icon: Icons.report_problem_outlined,
                  color: AppColors.error,
                  onTap: controller.goToComplaints,
                  subtitle: 'Submit issues',
                ),
                DashboardCard(
                  title: 'Maintenance',
                  icon: Icons.payment_outlined,
                  color: AppColors.success,
                  onTap: controller.goToMaintenance,
                  subtitle: 'Payment status',
                ),
                DashboardCard(
                  title: 'Profile',
                  icon: Icons.person_outline,
                  color: AppColors.info,
                  onTap: controller.goToProfile,
                  subtitle: 'Account settings',
                ),
              ],
            ),
            const SizedBox(height: 30),
            Obx(() {
              if (controller.user?.isPresident == true) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'President Actions',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: CommonButton.primary(
                            text: 'Create Notice',
                            icon: Icons.add_circle_outline,
                            onPressed: controller.goToCreateNotice,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CommonButton.secondary(
                            text: 'All Complaints',
                            icon: Icons.list_alt_outlined,
                            onPressed: controller.goToComplaints,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),
            const SizedBox(height: 30),
            // Member Management Section for President
            Obx(() {
              if (controller.user?.isPresident == true) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Member Management',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(() {
                      if (controller.isLoadingMembers.value) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        );
                      }
                      
                      if (controller.members.isEmpty) {
                        return CommonCard(
                          child: Column(
                            children: [
                              Icon(
                                Icons.people_outline,
                                size: 48,
                                color: AppColors.textLight,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No members found',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      
                      return Column(
                        children: controller.members.map((member) {
                          return MemberCard(
                            name: member.name,
                            email: member.email,
                            flatNumber: member.flatNumber,
                            isActive: member.isActive,
                            onToggle: () => _showToggleConfirmation(context, member),
                          );
                        }).toList(),
                      );
                    }),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    ));
  }

  void _showToggleConfirmation(BuildContext context, User member) {
    final isActivating = !member.isActive;
    final action = isActivating ? 'activate' : 'deactivate';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          '${action[0].toUpperCase()}${action.substring(1)} Member',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to $action ${member.name}?',
          style: const TextStyle(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CommonButton.outline(
                text: 'Cancel',
                size: ButtonSize.small,
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 12),
              CommonButton(
                text: '${action[0].toUpperCase()}${action.substring(1)}',
                size: ButtonSize.small,
                backgroundColor: isActivating ? AppColors.success : AppColors.error,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.of(context).pop();
                  controller.toggleMemberStatus(member);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}