import 'package:flutter/material.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
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

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 1200));

    _isLoading = false;
    _successMessage = 'Password reset link sent successfully.';
    notifyListeners();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_successMessage!),
          backgroundColor: const Color(0xFF0F9F90),
          duration: const Duration(seconds: 4),
        ),
      );
    }
    return true;
  }
}
