import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/course_model.dart';

class ApiService {
  static const String baseUrl = "https://zenvora.trynet.work/api";

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

  Future<http.Response> getCategories() async {
    return await http.get(
      Uri.parse('$baseUrl/categories'),
      headers: {
        'Accept': 'application/json',
      },
    );
  }

  Future<List<CourseModel>> getCourses() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/courses'),
        headers: {
          'Accept': 'application/json',
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

  Future<CourseModel?> getCourseById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/course/$id'),
        headers: {
          'Accept': 'application/json',
        },
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
}
