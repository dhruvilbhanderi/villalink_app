import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../data/services/api_service.dart';
import '../../data/services/auth_service.dart';
import '../../data/models/user_model.dart';
import '../../data/models/complaint_model.dart';
import '../../routes/app_routes.dart';

class ComplaintsController extends GetxController {
  final RxList<Complaint> complaints = <Complaint>[].obs;
  final RxBool isLoading = false.obs;

  User? get user => AuthService.to.currentUser;

  @override
  void onInit() {
    super.onInit();
    loadComplaints();
  }

  Future<void> loadComplaints() async {
    isLoading.value = true;

    try {
      final response = await ApiService.get('/complaints/get_complaints.php', queryParams: {
        'user_id': user?.id.toString() ?? '',
        'user_type': user?.userType ?? '',
      });

      if (response['success'] == true) {
        final complaintsList = (response['complaints'] as List)
            .map((json) => Complaint.fromJson(json))
            .toList();
        complaints.assignAll(complaintsList);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load complaints');
    } finally {
      isLoading.value = false;
    }
  }

  void goToCreateComplaint() {
    Get.toNamed(AppRoutes.CREATE_COMPLAINT);
  }

  String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy HH:mm').format(date);
  }
}