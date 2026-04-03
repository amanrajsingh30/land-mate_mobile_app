import 'package:flutter/material.dart';
import 'package:landmate/features/auth/services/auth_api.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  Map<String, dynamic>? _user;
  bool _isLoading = true;

  bool get isLoggedIn => _isLoggedIn;
  Map<String, dynamic>? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> checkAuth() async {
    try {
      await AuthApi.getCsrfToken();
      final response = await AuthApi.getMe();

      _user = response.data;
      _isLoggedIn = true;
    } catch (e) {
      _isLoggedIn = false;
      _user = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  void setUser(Map<String, dynamic> userData) {
    _user = userData;
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    await AuthApi.logout();

    _user = null;
    _isLoggedIn = false;

    notifyListeners();
  }
}