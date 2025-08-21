import 'package:get/get.dart';
import 'package:villalink/modules/auth/login/login_view.dart';
import 'package:villalink/modules/auth/register_view.dart';
import 'package:villalink/modules/auth/splash_view.dart';
import 'package:villalink/modules/complaints/complaints_view.dart';
import 'package:villalink/modules/complaints/create_complaint_view.dart';
import 'package:villalink/modules/dashboard/dashboard_view.dart';
import 'package:villalink/modules/maintenance/maintenance_view.dart';

import 'package:villalink/modules/notices/create_notice_view.dart';
import 'package:villalink/modules/notices/notices_view.dart';
import 'package:villalink/modules/profile/edit_profile_view.dart';

import 'package:villalink/modules/profile/profile_view.dart';
import 'package:villalink/routes/app_routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.SPLASH;

  static final routes = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () =>  SplashView(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginView(),

    ),
    GetPage(
      name: AppRoutes.REGISTER,
      page: () => RegisterView(),

    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => DashboardView(),
    ),
    GetPage(
      name: AppRoutes.PROFILE,
      page: () => ProfileView(),
    ),
    GetPage(
      name: AppRoutes.EDIT_PROFILE,
      page: () => EditProfileView(),
    ),

    GetPage(
      name: AppRoutes.NOTICES,
      page: () =>  NoticesView(),

    ),
    GetPage(
      name: AppRoutes.CREATE_NOTICE,
      page: () => CreateNoticeView(),
    ),
    GetPage(
      name: AppRoutes.COMPLAINTS,
      page: () => ComplaintsView(),

    ),
    GetPage(
      name: AppRoutes.CREATE_COMPLAINT,
      page: () => CreateComplaintView(),

    ),
    GetPage(
      name: AppRoutes.MAINTENANCE,
      page: () => MaintenanceView(),

    ),
  ];
}