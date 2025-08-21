import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:villalink/data/models/user_model.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();

  final Rx<User?> _currentUser = Rx<User?>(null);
  User? get currentUser => _currentUser.value;
  bool get isLoggedIn => _currentUser.value != null;

  Future<void> init() async {
    await _loadUserFromStorage();
  }


  Future<void> _loadUserFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');
      if (userData != null) {
        final userJson = json.decode(userData);
        _currentUser.value = User.fromJson(userJson);
      }
    } catch (e) {
      print('Error loading user from storage: $e');
    }
  }

  Future<void> saveUser(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = json.encode(user.toJson());
      print("Saving user_data: $encoded"); // 👈
      await prefs.setString('user_data', encoded);
      _currentUser.value = user;
    } catch (e) {
      print('Error saving user: $e');
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_data');
      _currentUser.value = null;
    } catch (e) {
      print('Error during logout: $e');
    }
  }
}