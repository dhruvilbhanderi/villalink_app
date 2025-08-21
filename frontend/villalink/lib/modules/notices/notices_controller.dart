import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../data/services/api_service.dart';
import '../../data/services/auth_service.dart';
import '../../data/models/user_model.dart';
import '../../data/models/notice_model.dart';
import '../../routes/app_routes.dart';

class NoticesController extends GetxController {
  final RxList<Notice> notices = <Notice>[].obs;
  final RxBool isLoading = false.obs;

  User? get user => AuthService.to.currentUser;

  @override
  void onInit() {
    super.onInit();
    loadNotices();
  }

  Future<void> loadNotices() async {
    isLoading.value = true;

    try {
      final response = await ApiService.get('/notices/get_notices.php');

      if (response['success'] == true) {
        final noticesList = (response['notices'] as List)
            .map((json) => Notice.fromJson(json))
            .toList();
        notices.assignAll(noticesList);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load notices');
    } finally {
      isLoading.value = false;
    }
  }

  void goToCreateNotice() {
    Get.toNamed(AppRoutes.CREATE_NOTICE);
  }

  String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }
}