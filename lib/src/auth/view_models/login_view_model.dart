import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/user_preferences_service.dart';
import '../../../core/services/api_service.dart';

class LoginViewModel extends ChangeNotifier {
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  // Getters
  String get email => _email;
  String get password => _password;
  bool get isLoading => _isLoading;
  bool get obscurePassword => _obscurePassword;
  String? get errorMessage => _errorMessage;

  void setEmail(String value) {
    _email = value.trim();
    _errorMessage = null;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    _errorMessage = null;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  Future<bool> login(BuildContext context) async {
    if (_email.isEmpty || _password.isEmpty) {
      _errorMessage = 'Email and password are required.';
      notifyListeners();
      return false;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_email)) {
      _errorMessage = 'Please enter a valid email address.';
      notifyListeners();
      return false;
    }

    if (_password.length < 6) {
      _errorMessage = 'Password must be at least 6 characters.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final apiService = ApiService();
      final response = await apiService.login(_email, _password);
      final responseData = jsonDecode(response.body);

      if (responseData["success"] == true) {
        final student = responseData["student"];
        final token = responseData["token"]?.toString() ?? '';
        final prefsService = UserPreferencesService();
        await prefsService.saveUserData(
          student?["name"]?.toString() ?? 'User',
          student?["email"]?.toString() ?? _email,
          token: token,
        );

        _isLoading = false;
        notifyListeners();

        if (context.mounted) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        }
        return true;
      } else {
        _isLoading = false;
        _errorMessage = responseData["message"] ?? 'Invalid credentials';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Unable to connect to server.';
      notifyListeners();
      return false;
    }
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    _errorMessage = 'Google Sign-In is not implemented yet.';
    notifyListeners();
  }
}
