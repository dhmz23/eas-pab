// lib/services/auth_service.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static const String _usersKey = 'registered_users';
  static const String _loggedInKey = 'logged_in_email';
  static const String _isLoggedInKey = 'is_logged_in';

  // Register new user
  static Future<bool> register(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    List<Map<String, dynamic>> users = [];

    if (usersJson != null) {
      final List<dynamic> decoded = json.decode(usersJson);
      users = decoded.cast<Map<String, dynamic>>();
    }

    // Check if email already exists
    final exists = users.any((u) => u['email'] == user.email);
    if (exists) return false;

    users.add(user.toJson());
    await prefs.setString(_usersKey, json.encode(users));
    return true;
  }

  // Login
  static Future<UserModel?> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);

    if (usersJson == null) return null;

    final List<dynamic> decoded = json.decode(usersJson);
    final users = decoded.cast<Map<String, dynamic>>();

    final userJson = users.firstWhere(
      (u) => u['email'] == email && u['password'] == password,
      orElse: () => {},
    );

    if (userJson.isEmpty) return null;

    final user = UserModel.fromJson(userJson);
    await prefs.setString(_loggedInKey, email);
    await prefs.setBool(_isLoggedInKey, true);
    return user;
  }

  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loggedInKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  // Check if logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Get current user
  static Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_loggedInKey);
    if (email == null) return null;

    final usersJson = prefs.getString(_usersKey);
    if (usersJson == null) return null;

    final List<dynamic> decoded = json.decode(usersJson);
    final users = decoded.cast<Map<String, dynamic>>();

    final userJson = users.firstWhere(
      (u) => u['email'] == email,
      orElse: () => {},
    );

    if (userJson.isEmpty) return null;
    return UserModel.fromJson(userJson);
  }

  // Update user profile
  static Future<bool> updateProfile(
    String email,
    String newName,
    String newEmail,
    String nim,
    String prodi, {
    String? photoPath,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);
    if (usersJson == null) return false;

    final List<dynamic> decoded = json.decode(usersJson);
    List<Map<String, dynamic>> users = decoded.cast<Map<String, dynamic>>();

    final idx = users.indexWhere((u) => u['email'] == email);
    if (idx == -1) return false;

    users[idx]['fullName'] = newName;
    users[idx]['email'] = newEmail;
    users[idx]['nim'] = nim;
    users[idx]['prodi'] = prodi;
    if (photoPath != null) {
      users[idx]['photoPath'] = photoPath;
    }

    await prefs.setString(_usersKey, json.encode(users));
    await prefs.setString(_loggedInKey, newEmail);
    return true;
  }
}
