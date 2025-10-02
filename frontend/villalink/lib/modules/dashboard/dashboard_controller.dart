import 'dart:developer';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/member_service.dart';
import '../../data/models/user_model.dart';
import '../../routes/app_routes.dart';
import '../../shared/utils/app_snackbar.dart';

class DashboardController extends GetxController {
  User? get user => AuthService.to.currentUser;
  
  final RxList<User> members = <User>[].obs;
  final RxBool isLoadingMembers = false.obs;

  void goToProfile() {
    Get.toNamed(AppRoutes.PROFILE);
  }

  void goToNotices() {
    Get.toNamed(AppRoutes.NOTICES);
  }

  void goToComplaints() {
    Get.toNamed(AppRoutes.COMPLAINTS);
  }

  void goToMaintenance() {
    Get.toNamed(AppRoutes.MAINTENANCE);
  }

  void goToCreateNotice() {
    Get.toNamed(AppRoutes.CREATE_NOTICE);
  }

  void logout() async {
    await AuthService.to.logout();
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  void onInit() {
    super.onInit();
    if (user?.isPresident == true) {
      loadMembers();
    }
  }

  Future<void> loadMembers() async {
    try {
      isLoadingMembers.value = true;
      final memberList = await MemberService.getAllMembers();
      members.value = memberList;
    } catch (e) {
      if (Get.context != null) {
        AppSnackBar.showError(Get.context!, 'Failed to load members: $e');
      }
      log("$e");
    } finally {
      isLoadingMembers.value = false;
    }
  }

  Future<void> toggleMemberStatus(User member) async {
    try {
      final newStatus = !member.isActive;
      await MemberService.toggleMemberStatus(member.id, newStatus);
      
      // Update the member in the list
      final index = members.indexWhere((m) => m.id == member.id);
      if (index != -1) {
        members[index] = User(
          id: member.id,
          name: member.name,
          email: member.email,
          phone: member.phone,
          flatNumber: member.flatNumber,
          userType: member.userType,
          isActive: newStatus,
        );
      }
      
      final statusText = newStatus ? 'activated' : 'deactivated';
      if (Get.context != null) {
        AppSnackBar.showSuccess(Get.context!, '${member.name} has been $statusText');
      }
    } catch (e) {
      if (Get.context != null) {
        AppSnackBar.showError(Get.context!, 'Failed to update member status: $e');
      }
    }
  }
}