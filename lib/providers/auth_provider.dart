import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  bool _isLoggedIn = false;
  Map<String, dynamic>? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoggedIn => _isLoggedIn;
  Map<String, dynamic>? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  String get username => _currentUser?['username'] ?? '';
  String get email => _currentUser?['email'] ?? '';
  String get fullName => _currentUser?['fullName'] ?? '';

  // Initialize and check login status
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      _isLoggedIn = await _authService.isLoggedIn();
      if (_isLoggedIn) {
        _currentUser = await _authService.getCurrentUser();
      }
    } catch (e) {
      _errorMessage = 'Error saat inisialisasi: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Register new user
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    String? fullName,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _authService.register(
      username: username,
      email: email,
      password: password,
      fullName: fullName,
    );

    _isLoading = false;
    
    if (!result['success']) {
      _errorMessage = result['message'];
    }
    
    notifyListeners();
    return result;
  }

  // Login user
  Future<Map<String, dynamic>> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _authService.login(
      usernameOrEmail: usernameOrEmail,
      password: password,
    );

    if (result['success']) {
      _isLoggedIn = true;
      _currentUser = result['user'];
    } else {
      _errorMessage = result['message'];
    }

    _isLoading = false;
    notifyListeners();
    return result;
  }

  // Logout user
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _authService.logout();
    _isLoggedIn = false;
    _currentUser = null;
    _errorMessage = null;

    _isLoading = false;
    notifyListeners();
  }

  // Update profile
  Future<Map<String, dynamic>> updateProfile({
    String? fullName,
    String? email,
  }) async {
    if (_currentUser == null) {
      return {'success': false, 'message': 'User tidak ditemukan'};
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _authService.updateProfile(
      username: _currentUser!['username'],
      fullName: fullName,
      email: email,
    );

    if (result['success']) {
      _currentUser = result['user'];
    } else {
      _errorMessage = result['message'];
    }

    _isLoading = false;
    notifyListeners();
    return result;
  }

  // Change password
  Future<Map<String, dynamic>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    if (_currentUser == null) {
      return {'success': false, 'message': 'User tidak ditemukan'};
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _authService.changePassword(
      username: _currentUser!['username'],
      oldPassword: oldPassword,
      newPassword: newPassword,
    );

    if (!result['success']) {
      _errorMessage = result['message'];
    }

    _isLoading = false;
    notifyListeners();
    return result;
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
