class AppConstants {
  static const String appName = 'VillaLink';
  static const String appVersion = '1.0.0';

  // API Endpoints
  static const String loginEndpoint = '/auth/login.php';
  static const String registerEndpoint = '/auth/register.php';
  static const String logoutEndpoint = '/auth/logout.php';
  static const String profileEndpoint = '/user/profile.php';
  static const String updateProfileEndpoint = '/user/update_profile.php';
  static const String noticesEndpoint = '/notices/get_notices.php';
  static const String createNoticeEndpoint = '/notices/create_notice.php';
  static const String deleteNoticeEndpoint = '/notices/delete_notice.php';
  static const String complaintsEndpoint = '/complaints/get_complaints.php';
  static const String createComplaintEndpoint = '/complaints/create_complaint.php';
  static const String updateComplaintEndpoint = '/complaints/update_complaint.php';
  static const String maintenanceEndpoint = '/maintenance/get_maintenance.php';
  static const String createMaintenanceEndpoint = '/maintenance/create_maintenance.php';
  static const String updatePaymentEndpoint = '/maintenance/update_payment.php';

  // User Types
  static const String userTypePresident = 'president';
  static const String userTypeMember = 'member';

  // Storage Keys
  static const String userDataKey = 'user_data';
  static const String isLoggedInKey = 'is_logged_in';

  // Status Types
  static const String statusPending = 'pending';
  static const String statusInProgress = 'in_progress';
  static const String statusResolved = 'resolved';
  static const String statusPaid = 'paid';
}