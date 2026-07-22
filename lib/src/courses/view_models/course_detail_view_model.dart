import 'package:flutter/material.dart';
import '../../../models/course_model.dart';

class CourseDetailViewModel extends ChangeNotifier {
  final CourseModel course;
  int _activeTabIndex = 0;
  final Set<String> _expandedModuleIds = {};
  bool _isEnrolling = false;

  CourseDetailViewModel({required this.course});

  // Getters
  int get activeTabIndex => _activeTabIndex;
  bool get isEnrolling => _isEnrolling;

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

  void toggleFavorite() {
    course.isFavorite = !course.isFavorite;
    notifyListeners();
  }

  Future<void> enrollInCourse(BuildContext context) async {
    if (course.isEnrolled) return;

    _isEnrolling = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1000));

    course.isEnrolled = true;
    course.progress = 0.0;
    _isEnrolling = false;
    notifyListeners();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully enrolled in "${course.name}"!'),
          backgroundColor: const Color(0xFF163A5F),
        ),
      );
    }
  }
}
