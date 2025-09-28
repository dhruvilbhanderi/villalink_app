import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:villalink/modules/complaints/delete_complaint_controller.dart';


class DeleteComplaintView extends StatelessWidget {
  DeleteComplaintView({Key? key}) : super(key: key);

  final DeleteComplaintController controller = Get.put(DeleteComplaintController());

  @override
  Widget build(BuildContext context) {
    final title = controller.title ?? 'Complaint';
    final description = controller.description ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Complaint'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title,
                              style:
                              const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 8),
                          Text(
                            description,
                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Chip(
                                label: const Text('Destructive action'),
                                backgroundColor: Colors.red.shade50,
                                labelStyle: TextStyle(color: Colors.red.shade800),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'This will permanently remove the complaint.',
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: controller.isLoading.value ? null : () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                          controller.isLoading.value ? null : () => _confirmAndDelete(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(
                              width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                              : const Text('Delete', style: TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // loading overlay
            if (controller.isLoading.value)
              const Opacity(
                opacity: 0.6,
                child: ModalBarrier(dismissible: false, color: Colors.black),
              ),
            if (controller.isLoading.value)
              const Center(child: CircularProgressIndicator()),
          ],
        );
      }),
    );
  }

  Future<void> _confirmAndDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm delete'),
        content: const Text('Are you sure you want to permanently delete this complaint?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('No')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Yes, delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final resp = await controller.deleteComplaint();
      if (resp['success'] == true) {
        Get.snackbar('Deleted', resp['message'] ?? 'Complaint deleted', snackPosition: SnackPosition.BOTTOM);
        // return to previous screen with a result so list can update
        Get.back(result: {'deleted': true, 'complaint_id': controller.complaintId});
      } else {
        Get.snackbar('Error', resp['message'] ?? 'Failed to delete', snackPosition: SnackPosition.BOTTOM);
      }
    }
  }
}
