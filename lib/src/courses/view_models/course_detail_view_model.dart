import 'package:flutter/material.dart';
import '../../../../core/services/api_service.dart';
import '../../../../models/course_model.dart';

class CourseDetailViewModel extends ChangeNotifier {
  final ApiService _apiService;
  final int courseId;

  CourseModel? _course;
  bool _isLoading = false;
  String? _errorMessage;
  int _activeTabIndex = 0;
  final Set<String> _expandedModuleIds = {};
  bool _isEnrolling = false;

  CourseDetailViewModel({
    required this.courseId,
    ApiService? apiService,
    CourseModel? initialCourse,
  })  : _apiService = apiService ?? ApiService(),
        _course = initialCourse;

  // Getters
  CourseModel? get course => _course;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get activeTabIndex => _activeTabIndex;
  bool get isEnrolling => _isEnrolling;

  Future<void> fetchCourseDetail() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final fetchedCourse = await _apiService.getCourseById(courseId);
      if (fetchedCourse != null) {
        _course = fetchedCourse;
        _errorMessage = null;
      } else {
        _errorMessage = 'Failed to load course details.';
      }
    } catch (e) {
      _errorMessage = 'An error occurred while loading the course: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool isModuleExpanded(String moduleId) {
    return _expandedModuleIds.contains(moduleId);
  }

  void setActiveTab(int index) {
    _activeTabIndex = index;
    notifyListeners();
  }

  void toggleModuleExpanded(String moduleId) {
    if (_expandedModuleIds.contains(moduleId)) {
      _expandedModuleIds.remove(moduleId);
    } else {
      _expandedModuleIds.add(moduleId);
    }
    notifyListeners();
  }

  Future<void> enrollInCourse(BuildContext context) async {
    if (_course == null || _course!.isEnrolled) return;

    _isEnrolling = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1000));

    if (_course != null) {
      _course!.isEnrolled = true;
      _course!.progress = 0.0;
    }
    _isEnrolling = false;
    notifyListeners();

    if (context.mounted && _course != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully enrolled in "${_course!.name}"!'),
          backgroundColor: const Color(0xFF163A5F),
        ),
      );
    }
  }
}
