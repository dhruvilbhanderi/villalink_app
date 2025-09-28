import 'package:get/get.dart';
import 'package:villalink/data/services/api_service.dart';

class DeleteComplaintController extends GetxController {
  final RxBool isLoading = false.obs;

  // Complaint data passed via Get.arguments
  late final int complaintId;
  String? title;
  String? description;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      complaintId = args['id'] is int ? args['id'] : int.parse(args['id'].toString());
      title = args['title']?.toString();
      description = args['description']?.toString();
    } else {
      // fallback — mark invalid id so delete will fail if not provided
      complaintId = -1;
    }
  }

  Future<Map<String, dynamic>> deleteComplaint() async {
    if (complaintId <= 0) {
      return {'success': false, 'message': 'Invalid complaint id'};
    }

    isLoading.value = true;
    try {
      final payload = {'complaint_id': complaintId.toString()};
      final resp = await ApiService.post('/complaints/delete_complaint.php', payload);

      // resp should be Map<String,dynamic> with 'success' and 'message'
      return resp;
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    } finally {
      isLoading.value = false;
    }
  }
}
