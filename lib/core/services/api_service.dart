import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/course_model.dart';
import '../../models/instructor_model.dart';
import '../../src/profile/models/student_profile_model.dart';
import '../../src/classroom/models/classroom_model.dart';
import 'user_preferences_service.dart';

class ApiService {
  static const String baseUrl = "https://eduzenvora.com/api";

  Future<http.Response> login(String email, String password) async {
    return await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );
  }

  Future<http.Response> forgotPassword(String email) async {
    return await http.post(
      Uri.parse('$baseUrl/forgot-password'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'email': email}),
    );
  }

  Future<http.Response> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String place,
  }) async {
    return await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'place': place,
      }),
    );
  }

  Future<http.Response> getCategories() async {
    return await http.get(
      Uri.parse('$baseUrl/categories'),
      headers: {'Accept': 'application/json'},
    );
  }

  Future<http.Response> getTopCategories() async {
    return await http.get(
      Uri.parse('$baseUrl/top-categories'),
      headers: {'Accept': 'application/json'},
    );
  }

  Future<http.Response> getCategoryCourses(String slug) async {
    return await http.get(
      Uri.parse('$baseUrl/category/$slug/courses'),
      headers: {'Accept': 'application/json'},
    );
  }

  Future<List<CourseModel>> fetchCategoryCourses(String slug) async {
    try {
      final response = await getCategoryCourses(slug);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List? rawList = (data['data'] is List)
            ? data['data']
            : (data['courses'] is List
                ? data['courses']
                : (data['category']?['courses'] is List
                    ? data['category']['courses']
                    : null));
        if (rawList != null) {
          return rawList.map((json) => CourseModel.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<CourseModel>> getCourses() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/courses'),
        headers: {'Accept': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['courses'] != null) {
          final List list = data['courses'];
          return list.map((json) => CourseModel.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<CourseModel?> getCourseById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/course/$id'),
        headers: {'Accept': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['course'] != null) {
          return CourseModel.fromJson(data['course']);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<http.Response> logout(String token) async {
    return await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<StudentProfileModel?> getStudentProfile() async {
    try {
      final token = await UserPreferencesService().getToken();
      if (token == null || token.isEmpty) {
        return null;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/student/profile'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['student'] != null) {
          return StudentProfileModel.fromJson(data['student']);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<http.Response> updateStudentProfile({
    required String token,
    required String name,
    required String phone,
    required String place,
  }) async {
    return await http.put(
      Uri.parse('$baseUrl/student/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'name': name, 'phone': phone, 'place': place}),
    );
  }

  Future<List<CourseModel>> getStudentDashboard() async {
    try {
      final token = await UserPreferencesService().getToken();
      if (token == null || token.isEmpty) {
        return [];
      }

      final response = await http.get(
        Uri.parse('$baseUrl/student/dashboard'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['courses'] != null) {
          final List list = data['courses'];
          return list.map((json) => CourseModel.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<ClassroomModel?> getStudentClassroom(int courseId) async {
    try {
      final token = await UserPreferencesService().getToken();
      if (token == null || token.isEmpty) {
        return null;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/student/classroom/$courseId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return ClassroomModel.fromJson(data);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<http.Response> enrollCourse(int courseId) async {
    final token = await UserPreferencesService().getToken();
    return await http.post(
      Uri.parse('$baseUrl/student/enroll/$courseId'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<http.Response> verifyRazorpayPayment({
    required int paymentId,
    required String razorpayPaymentId,
    required String razorpayOrderId,
    required String razorpaySignature,
  }) async {
    final token = await UserPreferencesService().getToken();
    return await http.post(
      Uri.parse('$baseUrl/payment/razorpay/verify'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'payment_id': paymentId,
        'razorpay_payment_id': razorpayPaymentId,
        'razorpay_order_id': razorpayOrderId,
        'razorpay_signature': razorpaySignature,
      }),
    );
  }

  Future<List<InstructorModel>> getTeam() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/team'),
        headers: {'Accept': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if ((data['success'] == true || data['status'] == true) &&
            data['team'] != null &&
            data['team'] is List) {
          final List list = data['team'];
          return list.map((json) => InstructorModel.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
