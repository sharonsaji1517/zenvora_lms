import 'package:flutter/material.dart';
import '../../../core/services/api_service.dart';
import '../models/classroom_model.dart';

class ClassroomViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  ClassroomModel? _classroom;
  ClassroomModel? get classroom => _classroom;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  int? _courseId;
  int? get courseId => _courseId;

  int get coursesCount => _classroom?.course != null ? 1 : 0;
  int get lessonsCount =>
      (_classroom?.videos.length ?? 0) +
      (_classroom?.pdfs.length ?? 0) +
      (_classroom?.ppts.length ?? 0) +
      (_classroom?.youtubeLinks.length ?? 0) +
      (_classroom?.privateVideos.length ?? 0);
  String get completionRate => _classroom != null ? '100%' : '0%';

  ClassroomViewModel();

  Future<void> fetchClassroom(int courseId) async {
    _courseId = courseId;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _apiService.getStudentClassroom(courseId);
      if (data != null && data.success) {
        _classroom = data;
        _errorMessage = null;
      } else {
        _errorMessage = 'Failed to load classroom content. Please try again.';
      }
    } catch (e) {
      debugPrint('Error fetching classroom: $e');
      _errorMessage = 'An error occurred while fetching classroom resources.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
