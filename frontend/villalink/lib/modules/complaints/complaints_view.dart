import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:villalink/data/models/complaint_model.dart';
import 'package:villalink/modules/complaints/complaints_controller.dart';
import 'package:villalink/modules/complaints/update_complaint_view.dart';

class ComplaintsView extends StatelessWidget {
  ComplaintsView({Key? key}) : super(key: key);

  final ComplaintsController controller = Get.isRegistered<ComplaintsController>()
      ? Get.find<ComplaintsController>()
      : Get.put(ComplaintsController());

  @override
  Widget build(BuildContext context) {
    // Determine role once per build
    final user = controller.user;
    final bool isPresident = (user?.userType?.toString().toLowerCase() == 'president');
    final bool isMember = (user?.userType?.toString().toLowerCase() == 'member');

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade600,
        title: const Text('Complaints', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          if (isMember) // only member can create complaint (if that's desired)
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: controller.goToCreateComplaint,
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.loadComplaints,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.complaints.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.report_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No complaints found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.complaints.length,
            itemBuilder: (context, index) {
              final Complaint complaint = controller.complaints[index];
              final bool isClosed = complaint.status.toLowerCase() == 'closed';
              // president can do both edit & delete; members only view
              final bool canEdit = isPresident && !isClosed;
              final bool canDelete = isPresident;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: Material(
                  borderRadius: BorderRadius.circular(12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top row: left+middle (expandable & blurable) + trailing (icons)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // LEFT + MIDDLE packaged into Expanded so we can blur only this area when closed
                                Expanded(
                                  child: Stack(
                                    children: [
                                      // Actual content (title, meta, description preview)
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // Left icon circle
                                              Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  color: complaint.statusColor.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Icon(
                                                  Icons.report_problem,
                                                  color: complaint.statusColor,
                                                  size: 20,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              // Title + meta
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      complaint.title,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Wrap(
                                                      crossAxisAlignment: WrapCrossAlignment.center,
                                                      spacing: 6,
                                                      runSpacing: 4,
                                                      children: [
                                                        Text(
                                                          'By ${complaint.createdByName}',
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: const TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        if (complaint.flatNumber != null) ...[
                                                          const Text('•', style: TextStyle(color: Colors.grey)),
                                                          Text(
                                                            'Flat ${complaint.flatNumber}',
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: const TextStyle(
                                                              fontSize: 12,
                                                              color: Colors.grey,
                                                            ),
                                                          ),
                                                        ],
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            complaint.description,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87,
                                              height: 1.4,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            controller.formatDate(complaint.createdAt),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),

                                      // If closed and NOT editable by this user, blur & block interactions on left+middle only.
                                      if (isClosed && !isPresident)
                                        Positioned.fill(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: BackdropFilter(
                                              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                                              child: Container(
                                                color: Colors.white.withOpacity(0.55),
                                                // AbsorbPointer blocks taps on underlying left+middle content.
                                                child: const SizedBox.expand(),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 8),

                                // TRAILING: status chip + icons (kept outside blur so interactive when allowed)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(maxWidth: 110),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: complaint.statusColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                complaint.status.toUpperCase(),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: complaint.statusColor,
                                                ),
                                              ),
                                            ),
                                            if (isClosed) ...[
                                              const SizedBox(width: 6),
                                              Icon(Icons.lock, size: 12, color: Colors.grey),
                                            ]
                                          ],
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Edit icon: only visible & active for president and when not closed
                                        if (canEdit)
                                          SizedBox(
                                            width: 36,
                                            height: 36,
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              icon: const Icon(Icons.edit, size: 18),
                                              onPressed: () async {
                                                final dynamic result = await Get.to(
                                                      () => UpdateComplaintView(),
                                                  arguments: {
                                                    'id': complaint.id,
                                                    'status': complaint.status,
                                                    'title': complaint.title,
                                                  },
                                                );

                                                if (result != null &&
                                                    result is Map<String, dynamic> &&
                                                    result['updated'] == true) {
                                                  final String updatedStatus =
                                                      result['status']?.toString() ?? complaint.status;
                                                  final int idx = controller.complaints
                                                      .indexWhere((c) => c.id == complaint.id);
                                                  if (idx != -1) {
                                                    final old = controller.complaints[idx];
                                                    final updatedComplaint = Complaint(
                                                      id: old.id,
                                                      title: old.title,
                                                      description: old.description,
                                                      status: updatedStatus,
                                                      createdByName: old.createdByName,
                                                      flatNumber: old.flatNumber,
                                                      createdAt: old.createdAt,
                                                    );
                                                    controller.complaints[idx] = updatedComplaint;
                                                  }
                                                }
                                              },
                                            ),
                                          )
                                        else
                                        // keep spacing consistent
                                          const SizedBox(width: 36, height: 36),

                                        const SizedBox(width: 8),

                                        // Delete icon: only visible & active for president
                                        SizedBox(
                                          width: 36,
                                          height: 36,
                                          child: Obx(() {
                                            final bool isDeleting = controller.deletingId.value == complaint.id;
                                            if (!canDelete) {
                                              // show greyed-out delete for members (or hide entirely if you prefer)
                                              return const SizedBox.shrink();
                                            }
                                            if (isDeleting) {
                                              return const Padding(
                                                padding: EdgeInsets.all(6.0),
                                                child: CircularProgressIndicator(strokeWidth: 2),
                                              );
                                            }
                                            return IconButton(
                                              padding: EdgeInsets.zero,
                                              icon: Icon(Icons.delete_outline, size: 18, color: Colors.red.shade700),
                                              onPressed: () => controller.deleteComplaintById(complaint.id),
                                            );
                                          }),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
