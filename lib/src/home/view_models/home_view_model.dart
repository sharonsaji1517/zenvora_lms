import 'package:flutter/material.dart';
import '../../courses/models/course_model.dart';

class HomeViewModel extends ChangeNotifier {
  int _currentBannerIndex = 0;
  String _selectedCategoryId = '';
  List<Course> _courses = [];
  List<CourseCategory> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  HomeViewModel() {
    // Rely on loadHomeData() called by the View
  }

  // Getters
  int get currentBannerIndex => _currentBannerIndex;
  String get selectedCategoryId => _selectedCategoryId;
  List<CourseCategory> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  List<Course> get rigAssociatedCourses => 
      _courses.where((c) => c.isRigAssociated).toList();

  List<Course> get rigCourses => rigAssociatedCourses;

  List<Course> get featuredCourses => 
      _courses.where((c) => c.isFeatured).toList();

  List<Course> get courses => _courses;

  Future<void> loadHomeData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate API/network call delay
      await Future.delayed(const Duration(milliseconds: 500));
      _categories = getMockCategories();
      _courses = getMockCourses();
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

  void toggleFavorite(String courseId) {
    final index = _courses.indexWhere((c) => c.id == courseId);
    if (index != -1) {
      _courses[index].isFavorite = !_courses[index].isFavorite;
      notifyListeners();
    }
  }

  // Filtered courses based on category selection (if grid is tapped)
  List<Course> getFilteredCourses() {
    if (_selectedCategoryId.isEmpty) {
      return _courses;
    }
    return _courses.where((c) => c.categoryId == _selectedCategoryId).toList();
  }
}
