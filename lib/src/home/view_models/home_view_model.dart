import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../models/category_model.dart';
import '../../../models/course_model.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/user_preferences_service.dart';

class HomeViewModel extends ChangeNotifier {
  int _currentBannerIndex = 0;
  String _selectedCategoryId = '';
  List<CourseModel> _courses = [];
  List<CourseModel> _enrolledCourses = [];
  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;

  HomeViewModel() {
    // Rely on loadHomeData() called by the View
  }

  String _fullName = 'Guest User';

  // Getters
  String get fullName => _fullName;
  String get firstName {
    if (_fullName.isEmpty) return 'User';
    return _fullName.split(' ').first;
  }

  int get currentBannerIndex => _currentBannerIndex;
  String get selectedCategoryId => _selectedCategoryId;
  List<CategoryModel> get categories => _categories;
  List<CourseModel> get courses => _courses;
  List<CourseModel> get enrolledCourses => _enrolledCourses;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<CourseModel> get rigAssociatedCourses => _courses;
  List<CourseModel> get rigCourses => _courses;
  List<CourseModel> get featuredCourses => _courses;

  Future<void> loadEnrolledCourses() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await UserPreferencesService().getToken();
      if (token == null || token.isEmpty) {
        _enrolledCourses = [];
        _errorMessage = 'Please log in to view your enrolled courses.';
      } else {
        final apiService = ApiService();
        _enrolledCourses = await apiService.getStudentDashboard();
        _courses = _enrolledCourses;
      }
    } catch (e) {
      _errorMessage = 'Failed to load enrolled courses. Please try again.';
      _enrolledCourses = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadTopCategories() async {
    try {
      final apiService = ApiService();
      final response = await apiService.getTopCategories();

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List? rawList = data['data'] ?? data['categories'];
        if ((data['status'] == true || data['success'] == true) && rawList != null) {
          _categories = rawList.map((item) => CategoryModel.fromJson(item)).toList();
        } else {
          _categories = [];
        }
      } else {
        _categories = [];
      }
    } catch (e) {
      _categories = [];
    }
    notifyListeners();
  }

  Future<void> loadCategories() async {
    await loadTopCategories();
  }

  Future<void> loadCourses() async {
    try {
      final apiService = ApiService();
      _courses = await apiService.getCourses();
    } catch (e) {
      _courses = [];
    }
    notifyListeners();
  }

  Future<void> loadHomeData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefsService = UserPreferencesService();
      _fullName = await prefsService.getFullName();

      await loadTopCategories();
      await loadCourses();
    } catch (e) {
      _errorMessage = 'Failed to load dashboard data. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setBannerIndex(int index) {
    _currentBannerIndex = index;
    notifyListeners();
  }

  void selectCategory(String categoryId) {
    if (_selectedCategoryId == categoryId) {
      _selectedCategoryId = ''; // Toggle off
    } else {
      _selectedCategoryId = categoryId;
    }
    notifyListeners();
  }

  List<CourseModel> getFilteredCourses() {
    if (_selectedCategoryId.isEmpty) {
      return _courses;
    }
    return _courses
        .where((c) => c.categoryId.toString() == _selectedCategoryId)
        .toList();
  }
}
