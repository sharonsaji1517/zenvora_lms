import 'package:flutter/material.dart';
import '../../courses/models/course_model.dart';
import '../../../core/services/user_preferences_service.dart';

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

  String _fullName = 'Guest User';

  // Getters
  String get fullName => _fullName;
  String get firstName {
    if (_fullName.isEmpty) return 'User';
    return _fullName.split(' ').first;
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
      final prefsService = UserPreferencesService();
      _fullName = await prefsService.getFullName();
      final wishlist = await prefsService.getWishlist();

      // Simulate API/network call delay
      await Future.delayed(const Duration(milliseconds: 500));
      _categories = getMockCategories();
      _courses = getMockCourses();
      
      // Update favorite status from wishlist
      for (var course in _courses) {
        course.isFavorite = wishlist.contains(course.id);
      }
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

  Future<void> toggleFavorite(String courseId) async {
    final index = _courses.indexWhere((c) => c.id == courseId);
    if (index != -1) {
      _courses[index].isFavorite = !_courses[index].isFavorite;
      notifyListeners();
      
      final prefsService = UserPreferencesService();
      await prefsService.toggleWishlist(courseId);
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
