import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import 'auth_service.dart';

class MemberService {
  static const String baseUrl = 'http://192.168.165.215/villlink/villalink_app/backend/api';

  static Future<List<User>> getAllMembers() async {
    try {
      final user = AuthService.to.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/user/get_all_members.php?user_id=${user.id}'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          final List<dynamic> membersJson = data['members'];
          return membersJson.map((json) => User.fromJson(json)).toList();
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch members');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch members: $e');
    }
  }

  static Future<bool> toggleMemberStatus(int memberId, bool isActive) async {
    try {
      final user = AuthService.to.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/user/toggle_member_status.php'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'user_id': user.id,
          'member_id': memberId,
          'is_active': isActive,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return true;
        } else {
          throw Exception(data['message'] ?? 'Failed to update member status');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update member status: $e');
    }
  }
}
