import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/user_preferences_service.dart';
import '../models/student_profile_model.dart';

class EditProfileViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final UserPreferencesService _prefsService = UserPreferencesService();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController placeController = TextEditingController();

  StudentProfileModel? _profile;
  StudentProfileModel? get profile => _profile;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  EditProfileViewModel() {
    fetchStudentProfile();
  }

  Future<void> fetchStudentProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Temporary fallback from local storage while loading/fetching API
      final localName = await _prefsService.getFullName();
      final localEmail = await _prefsService.getEmail();
      fullNameController.text = localName;
      emailController.text = localEmail;

      // Primary source of truth: Student Profile API
      final fetchedProfile = await _apiService.getStudentProfile();

      if (fetchedProfile != null) {
        _profile = fetchedProfile;
        fullNameController.text = fetchedProfile.name;
        emailController.text = fetchedProfile.email;
        phoneController.text = fetchedProfile.phone ?? '';
        placeController.text = fetchedProfile.place ?? '';
        _errorMessage = null;
      } else {
        _errorMessage = 'Failed to load profile. Please try again.';
      }
    } catch (e) {
      debugPrint('Error fetching student profile: $e');
      _errorMessage = 'An error occurred while fetching profile data.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile(BuildContext context) async {
    final name = fullNameController.text.trim();
    final phone = phoneController.text.trim();
    final place = placeController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Name cannot be empty'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return false;
    }

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Phone cannot be empty'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return false;
    }

    if (place.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Place cannot be empty'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return false;
    }

    _isSaving = true;
    notifyListeners();

    try {
      final token = await _prefsService.getToken();
      if (token == null || token.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Authentication token missing. Please log in again.'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
        return false;
      }

      final response = await _apiService.updateStudentProfile(
        token: token,
        name: name,
        phone: phone,
        place: place,
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        // Save updated name and email locally in SharedPreferences
        await _prefsService.saveUserData(name, emailController.text.trim());

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully.'),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 3),
            ),
          );
          Navigator.pop(context, true);
        }
        return true;
      } else {
        final serverMessage = responseData['message'] ?? 'Failed to update profile.';
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
      debugPrint('Error updating profile: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: ${e.toString()}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    placeController.dispose();
    super.dispose();
  }
}
