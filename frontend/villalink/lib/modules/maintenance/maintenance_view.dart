import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:villalink/data/models/maintenance_model.dart';
import 'package:villalink/modules/maintenance/maintenance_controller.dart';
import '../../shared/widgets/common_app_bar.dart';
import '../../shared/widgets/common_card.dart';
import '../../shared/widgets/common_button.dart';
import '../../shared/themes/app_colors.dart';

class MaintenanceView extends StatelessWidget {
  MaintenanceView({Key? key}) : super(key: key);
  final controller = Get.isRegistered<MaintenanceController>()
      ? Get.find<MaintenanceController>()
      : Get.put(MaintenanceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CommonAppBar(
        title: 'Maintenance',
      ),
      body: RefreshIndicator(
        onRefresh: controller.loadMaintenance,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            );
          }

          if (controller.maintenanceRecords.isEmpty) {
            return Center(
              child: CommonCard(
                margin: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.payment_outlined,
                      size: 80,
                      color: AppColors.textLight,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No Maintenance Records',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'No maintenance records found for your account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              // Summary Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Outstanding Amount Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: AppColors.successGradient,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.success.withOpacity(0.3),
                            offset: const Offset(0, 4),
                            blurRadius: 16,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Total Outstanding',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '₹${controller.totalOutstanding.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Stats Row
                    Row(
                      children: [
                        Expanded(
                          child: StatusCard(
                            title: 'Paid',
                            value: '${controller.paidCount}',
                            icon: Icons.check_circle_outlined,
                            color: AppColors.success,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StatusCard(
                            title: 'Pending',
                            value: '${controller.pendingCount}',
                            icon: Icons.pending_outlined,
                            color: AppColors.warning,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StatusCard(
                            title: 'Overdue',
                            value: '${controller.overdueCount}',
                            icon: Icons.warning_outlined,
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Maintenance Records List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.maintenanceRecords.length,
                  itemBuilder: (context, index) {
                    final maintenance = controller.maintenanceRecords[index];
                    return _buildMaintenanceCard(maintenance);
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildMaintenanceCard(Maintenance maintenance) {
    final isPresident = controller.user?.isPresident ?? false;
    
    return CommonCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Status Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      maintenance.statusColor.withOpacity(0.1),
                      maintenance.statusColor.withOpacity(0.2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Icon(
                  maintenance.isPaid
                      ? Icons.check_circle_outline
                      : maintenance.isOverdue
                          ? Icons.warning_outlined
                          : Icons.schedule_outlined,
                  color: maintenance.statusColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Name (for president) or Amount (for member)
                    if (isPresident && maintenance.userName != null) ...[
                      Text(
                        maintenance.userName!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (maintenance.flatNumber != null)
                        Text(
                          'Flat: ${maintenance.flatNumber}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      const SizedBox(height: 4),
                    ],
                    
                    // Amount
                    Text(
                      '₹${maintenance.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: isPresident ? 16 : 20,
                        fontWeight: FontWeight.bold,
                        color: maintenance.statusColor,
                      ),
                    ),
                    
                    // Due Date
                    Text(
                      'Due: ${controller.formatDate(maintenance.dueDate)}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: maintenance.statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: maintenance.statusColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  maintenance.statusText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: maintenance.statusColor,
                  ),
                ),
              ),
            ],
          ),
          
          // Pay Button (only for unpaid records and current user)
          if (!maintenance.isPaid && (!isPresident || maintenance.userId == controller.user?.id)) ...[
            const SizedBox(height: 16),
            CommonButton.success(
              text: 'Pay Now',
              icon: Icons.payment_outlined,
              width: double.infinity,
              onPressed: () => controller.payMaintenance(maintenance),
            ),
          ],
        ],
      ),
    );
  }
}
