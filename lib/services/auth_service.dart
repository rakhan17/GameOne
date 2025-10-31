import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthService {
  static const String _keyUsers = 'app_users';
  static const String _keyCurrentUser = 'current_user';
  static const String _keyIsLoggedIn = 'is_logged_in';

  // Hash password sederhana
  String _hashPassword(String password) {
    return password.split('').map((c) => c.codeUnitAt(0).toRadixString(16)).join();
  }

  // Register new user
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (username.length < 3) {
        return {'success': false, 'message': 'Username minimal 3 karakter'};
      }
      
      if (!_isValidEmail(email)) {
        return {'success': false, 'message': 'Format email tidak valid'};
      }
      
      if (password.length < 6) {
        return {'success': false, 'message': 'Password minimal 6 karakter'};
      }

      final usersJson = prefs.getString(_keyUsers) ?? '[]';
      final List<dynamic> users = json.decode(usersJson);

      final existingUser = users.firstWhere(
        (user) => user['username'] == username || user['email'] == email,
        orElse: () => null,
      );

      if (existingUser != null) {
        return {'success': false, 'message': 'Username atau email sudah terdaftar'};
      }

      final newUser = {
        'username': username,
        'email': email,
        'password': _hashPassword(password),
        'fullName': fullName ?? username,
        'createdAt': DateTime.now().toIso8601String(),
      };

      users.add(newUser);
      await prefs.setString(_keyUsers, json.encode(users));

      return {'success': true, 'message': 'Registrasi berhasil'};
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  // Login user
  Future<Map<String, dynamic>> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_keyUsers) ?? '[]';
      final List<dynamic> users = json.decode(usersJson);

      final user = users.firstWhere(
        (user) =>
            (user['username'] == usernameOrEmail ||
                user['email'] == usernameOrEmail) &&
            user['password'] == _hashPassword(password),
        orElse: () => null,
      );

      if (user == null) {
        return {'success': false, 'message': 'Username/email atau password salah'};
      }

      await prefs.setBool(_keyIsLoggedIn, true);
      
      final currentUser = Map<String, dynamic>.from(user);
      currentUser.remove('password');
      await prefs.setString(_keyCurrentUser, json.encode(currentUser));

      return {
        'success': true,
        'message': 'Login berhasil',
        'user': currentUser,
      };
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  // Logout user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
    await prefs.remove(_keyCurrentUser);
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Get current user
  Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_keyCurrentUser);
    
    if (userJson == null) return null;
    
    return json.decode(userJson) as Map<String, dynamic>;
  }

  // Update user profile
  Future<Map<String, dynamic>> updateProfile({
    required String username,
    String? fullName,
    String? email,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_keyUsers) ?? '[]';
      final List<dynamic> users = json.decode(usersJson);
      
      final userIndex = users.indexWhere((user) => user['username'] == username);
      
      if (userIndex == -1) {
        return {'success': false, 'message': 'User tidak ditemukan'};
      }

      if (fullName != null) users[userIndex]['fullName'] = fullName;
      if (email != null) {
        if (!_isValidEmail(email)) {
          return {'success': false, 'message': 'Format email tidak valid'};
        }
        users[userIndex]['email'] = email;
      }

      await prefs.setString(_keyUsers, json.encode(users));
      
      final updatedUser = Map<String, dynamic>.from(users[userIndex]);
      updatedUser.remove('password');
      await prefs.setString(_keyCurrentUser, json.encode(updatedUser));

      return {
        'success': true,
        'message': 'Profile berhasil diupdate',
        'user': updatedUser,
      };
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  // Change password
  Future<Map<String, dynamic>> changePassword({
    required String username,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getString(_keyUsers) ?? '[]';
      final List<dynamic> users = json.decode(usersJson);

      final userIndex = users.indexWhere(
        (user) =>
            user['username'] == username &&
            user['password'] == _hashPassword(oldPassword),
      );

      if (userIndex == -1) {
        return {'success': false, 'message': 'Password lama salah'};
      }

      if (newPassword.length < 6) {
        return {'success': false, 'message': 'Password baru minimal 6 karakter'};
      }

      users[userIndex]['password'] = _hashPassword(newPassword);
      await prefs.setString(_keyUsers, json.encode(users));

      return {'success': true, 'message': 'Password berhasil diubah'};
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  // Email validation
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }
}
