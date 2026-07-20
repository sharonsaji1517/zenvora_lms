import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/user_preferences_service.dart';

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

  // Simulates login validation & processing
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

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 1200));

    // Save user data to SharedPreferences on successful login simulation
    final prefsService = UserPreferencesService();
    String nameToSave = 'Guest User';
    if (_email == 'sharon@gmail.com') {
      nameToSave = 'Sharon Saji';
    } else {
      // Try to preserve existing name if the email matches
      final currentEmail = await prefsService.getEmail();
      if (currentEmail == _email) {
        nameToSave = await prefsService.getFullName();
      }
    }
    await prefsService.saveUserData(nameToSave, _email);

    _isLoading = false;
    notifyListeners();

    // Navigate to home screen
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
    return true;
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    // Simulate Google Sign In delay
    await Future.delayed(const Duration(milliseconds: 1500));

    // Save default user data for demonstration/testing
    final prefsService = UserPreferencesService();
    final currentName = await prefsService.getFullName();
    final currentEmail = await prefsService.getEmail();
    if (currentName == 'Guest User' && currentEmail == 'guest@example.com') {
      await prefsService.saveUserData('Sharon Saji', 'sharon@gmail.com');
    }

    _isLoading = false;
    notifyListeners();

    if (context.mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }
}
