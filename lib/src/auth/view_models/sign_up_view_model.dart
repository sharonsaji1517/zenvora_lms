import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/user_preferences_service.dart';

class SignUpViewModel extends ChangeNotifier {
  String _fullName = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  bool _acceptTerms = false;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;

  // Getters
  String get fullName => _fullName;
  String get email => _email;
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  bool get acceptTerms => _acceptTerms;
  bool get isLoading => _isLoading;
  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;
  String? get errorMessage => _errorMessage;

  void setFullName(String value) {
    _fullName = value.trim();
    _errorMessage = null;
    notifyListeners();
  }

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

  void setConfirmPassword(String value) {
    _confirmPassword = value;
    _errorMessage = null;
    notifyListeners();
  }

  void setAcceptTerms(bool value) {
    _acceptTerms = value;
    _errorMessage = null;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  Future<bool> createAccount(BuildContext context) async {
    if (_fullName.isEmpty || _email.isEmpty || _password.isEmpty || _confirmPassword.isEmpty) {
      _errorMessage = 'All fields are required.';
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

    if (_password != _confirmPassword) {
      _errorMessage = 'Passwords do not match.';
      notifyListeners();
      return false;
    }

    if (!_acceptTerms) {
      _errorMessage = 'You must accept the Terms and Privacy Policy.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 1500));

    final prefsService = UserPreferencesService();
    await prefsService.saveUserData(_fullName, _email);

    _isLoading = false;
    notifyListeners();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully! Welcome to Easy Learn.'),
          backgroundColor: Color(0xFF163A5F),
        ),
      );
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
    return true;
  }
}
