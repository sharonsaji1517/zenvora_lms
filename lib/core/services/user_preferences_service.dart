import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class UserPreferencesService {
  static const String _keyFullName = 'user_full_name';
  static const String _keyEmail = 'user_email';
  static const String _keyToken = 'user_token';
  static const String _keyOnboardingCompleted = 'onboarding_completed';
  static const String _keyHasSeenOnboarding = 'has_seen_onboarding';
  static const String _keyIsLoggedIn = 'is_logged_in';

  Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyHasSeenOnboarding) ?? prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingCompleted, completed);
    await prefs.setBool(_keyHasSeenOnboarding, completed);
  }

  Future<bool> hasSeenOnboarding() async {
    return isOnboardingCompleted();
  }

  Future<void> setHasSeenOnboarding(bool completed) async {
    await setOnboardingCompleted(completed);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final bool loggedInFlag = prefs.getBool(_keyIsLoggedIn) ?? false;
    final token = prefs.getString(_keyToken);
    return loggedInFlag || (token != null && token.isNotEmpty);
  }

  Future<void> setIsLoggedIn(bool loggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, loggedIn);
  }

  Future<void> saveUserData(String fullName, String email, {String? token}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFullName, fullName);
    await prefs.setString(_keyEmail, email);
    if (token != null && token.isNotEmpty) {
      await prefs.setString(_keyToken, token);
    }
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  Future<String> getFullName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyFullName) ?? 'Guest User';
  }

  Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail) ?? 'guest@example.com';
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyFullName);
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyToken);
    await prefs.setBool(_keyIsLoggedIn, false);
  }

  Future<bool> logoutUser(BuildContext context) async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      debugPrint("Token not found");
      await clearUserData();
      debugPrint("Whether SharedPreferences is cleared: true");
      return true;
    }

    debugPrint("Saved token before API call: $token");
    final String url = "${ApiService.baseUrl}/logout";
    debugPrint("Logout API URL: $url");

    try {
      final response = await ApiService().logout(token);
      debugPrint("HTTP Status Code: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      final responseData = jsonDecode(response.body);
      final success = responseData["success"];
      debugPrint("Success value from JSON: $success");

      if (response.statusCode == 200 && success == true) {
        await clearUserData();
        debugPrint("Whether SharedPreferences is cleared: true");
        return true;
      } else {
        debugPrint("Whether SharedPreferences is cleared: false");
        final serverMessage = responseData["message"] ?? 'Logout failed from server.';
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(serverMessage),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
        return false;
      }
    } catch (e) {
      debugPrint("Whether SharedPreferences is cleared: false");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Network error: ${e.toString()}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
      return false;
    }
  }
}
