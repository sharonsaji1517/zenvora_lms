import 'package:flutter/material.dart';
import '../../src/auth/views/login_screen.dart';
import '../../src/auth/views/forgot_password_screen.dart';
import '../../src/auth/views/sign_up_screen.dart';
import '../../src/home/views/home_screen.dart';
import '../../src/courses/views/course_detail_screen.dart';
import '../../src/courses/views/course_enrollment_screen.dart';
import '../../src/courses/views/course_success_screen.dart';
import '../../src/courses/views/my_courses_screen.dart';
import '../../screens/profile_screen.dart';
import '../../screens/settings_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String signUp = '/signup';
  static const String home = '/home';
  static const String courseDetail = '/course-detail';
  static const String courseEnrollment = '/course-enrollment';
  static const String enrollmentSuccess = '/enrollment-success';
  static const String myCourses = '/my-courses';
  static const String profile = '/profile';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => const LoginScreen(),
      forgotPassword: (context) => const ForgotPasswordScreen(),
      signUp: (context) => const SignUpScreen(),
      home: (context) => const HomeScreen(),
      courseDetail: (context) => const CourseDetailScreen(),
      courseEnrollment: (context) => const CourseEnrollmentScreen(),
      enrollmentSuccess: (context) => const CourseSuccessScreen(),
      myCourses: (context) => const MyCoursesScreen(),
      profile: (context) => const ProfileScreen(),
      settings: (context) => const SettingsScreen(),
    };
  }
}
