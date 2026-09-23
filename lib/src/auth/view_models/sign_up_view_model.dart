import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/api_service.dart';

class SignUpViewModel extends ChangeNotifier {
  String _fullName = '';
  String _email = '';
  String _phone = '';
  String _password = '';
  String _place = '';
  bool _acceptTerms = false;
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  // Getters
  String get fullName => _fullName;
  String get email => _email;
  String get phone => _phone;
  String get password => _password;
  String get place => _place;
  bool get acceptTerms => _acceptTerms;
  bool get isLoading => _isLoading;
  bool get obscurePassword => _obscurePassword;
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

  void setPhone(String value) {
    _phone = value.trim();
    _errorMessage = null;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    _errorMessage = null;
    notifyListeners();
  }

  void setPlace(String value) {
    _place = value.trim();
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

  Future<bool> createAccount(BuildContext context) async {
    if (_isLoading) return false;

    if (_fullName.isEmpty ||
        _email.isEmpty ||
        _phone.isEmpty ||
        _password.isEmpty ||
        _place.isEmpty) {
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

    if (!_acceptTerms) {
      _errorMessage = 'You must accept the Terms and Privacy Policy.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final apiService = ApiService();
      final response = await apiService.register(
        name: _fullName,
        email: _email,
        phone: _phone,
        password: _password,
        place: _place,
      );

      dynamic responseData;
      try {
        responseData = jsonDecode(response.body);
      } catch (_) {
        responseData = null;
      }

      final isSuccess = response.statusCode == 201 ||
          (responseData is Map && responseData['success'] == true);

      if (isSuccess) {
        final successMessage = (responseData is Map && responseData['message'] != null)
            ? responseData['message'].toString()
            : 'Account created successfully!';

        _isLoading = false;
        notifyListeners();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(successMessage),
              backgroundColor: const Color(0xFF163A5F),
            ),
          );
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
        return true;
      } else {
        String errorMsg = 'Registration failed. Please try again.';
        if (responseData is Map) {
          if (responseData['message'] != null &&
              responseData['message'].toString().trim().isNotEmpty) {
            errorMsg = responseData['message'].toString();
          } else if (responseData['errors'] is Map) {
            final errors = responseData['errors'] as Map;
            if (errors.isNotEmpty) {
              final firstVal = errors.values.first;
              if (firstVal is List && firstVal.isNotEmpty) {
                errorMsg = firstVal.first.toString();
              } else if (firstVal is String) {
                errorMsg = firstVal;
              }
            }
          }
        } else if (response.statusCode >= 500) {
          errorMsg = 'Server error. Please try again later.';
        }

        _isLoading = false;
        _errorMessage = errorMsg;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Unable to connect to server. Please check your connection.';
      notifyListeners();
      return false;
    }
  }
}
