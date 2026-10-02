import 'package:flutter/material.dart';
import '../core/services/api_service.dart';
import '../models/instructor_model.dart';

class InstructorsViewModel extends ChangeNotifier {
  final ApiService _apiService;

  List<InstructorModel> _instructors = [];
  bool _isLoading = false;
  String? _errorMessage;

  InstructorsViewModel({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  List<InstructorModel> get instructors => _instructors;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get isEmpty => _instructors.isEmpty && !_isLoading && !hasError;

  Future<void> fetchInstructors() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final team = await _apiService.getTeam();
      _instructors = team;
      if (_instructors.isEmpty) {
        _errorMessage = null;
      }
    } catch (e) {
      _errorMessage = 'Failed to load instructors. Please check your connection and try again.';
      _instructors = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
