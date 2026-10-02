import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../core/services/api_service.dart';
import '../../../core/routes/app_routes.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  String _email = '';
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  // Getters
  String get email => _email;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  void setEmail(String value) {
    _email = value.trim();
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  Future<bool> sendResetLink(BuildContext context) async {
    if (_email.isEmpty) {
      _errorMessage = 'Email address is required.';
      notifyListeners();
      return false;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_email)) {
      _errorMessage = 'Please enter a valid email address.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.forgotPassword(_email);
      final data = jsonDecode(response.body);

      _isLoading = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        _successMessage = data['message'] ?? 'Password reset link has been sent to your email.';
        notifyListeners();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_successMessage!),
              backgroundColor: const Color(0xFF163A5F),
              duration: const Duration(seconds: 4),
            ),
          );
          
          await Future.delayed(const Duration(seconds: 2));
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, AppRoutes.login);
          }
        }
        return true;
      } else {
        _errorMessage = data['message'] ?? 'Something went wrong. Please try again.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Network error occurred. Please try again.';
      notifyListeners();
      return false;
    }
  }
}
