import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:villalink/modules/complaints/update_complaint_controller.dart';

class UpdateComplaintView extends StatelessWidget {
  UpdateComplaintView({Key? key}) : super(key: key);
  final UpdateComplaintController controller = Get.put(UpdateComplaintController());

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final title = args?['title']?.toString() ?? 'Update Complaint';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(() {
            return IconButton(
              icon: controller.isLoading.value
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.save),
              onPressed: controller.isLoading.value ? null : controller.updateComplaint,
            );
          }),
        ],
      ),
      body: Obx(() {
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 8),

                    // IMPORTANT: set value to null when current status is not in options
                    DropdownButtonFormField<String>(
                      value: (controller.status.value.isNotEmpty &&
                          controller.statusOptions.contains(controller.status.value))
                          ? controller.status.value
                          : null,
                      items: controller.statusOptions
                          .map(
                            (s) => DropdownMenuItem(
                          value: s,
                          child: Text(_humanizeStatus(s)),
                        ),
                      )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) controller.status.value = v;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                      ),
                      validator: (val) => (val == null || val.isEmpty) ? 'Please select a status' : null,
                    ),

                    const SizedBox(height: 16),
                    const Text('Optional note', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: controller.noteController,
                      keyboardType: TextInputType.multiline,
                      minLines: 3,
                      maxLines: 6,
                      decoration: InputDecoration(
                        hintText: 'Add an internal note or comment (optional)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),

                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: controller.isLoading.value ? null : controller.updateComplaint,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              child: Text('Update Complaint'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: () {
                        controller.status.value = controller.initialStatus;
                        controller.noteController.clear();
                        Get.snackbar('Reset', 'Reverted changes', snackPosition: SnackPosition.BOTTOM);
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Revert changes'),
                    ),
                  ],
                ),
              ),
            ),
            if (controller.isLoading.value)
              const Opacity(opacity: 0.6, child: ModalBarrier(dismissible: false, color: Colors.black)),
            if (controller.isLoading.value) const Center(child: CircularProgressIndicator()),
          ],
        );
      }),
    );
  }

  // friendly label for status values
  static String _humanizeStatus(String s) {
    switch (s) {
      case 'in_progress':
        return 'In Progress';
      case 'resolved':
        return 'Resolved';
      case 'closed':
        return 'Closed';
      case 'pending':
      default:
        return s[0].toUpperCase() + s.substring(1).replaceAll('_', ' ');
    }
  }
}
