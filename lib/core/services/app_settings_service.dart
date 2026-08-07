import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/app_settings_model.dart';
import 'api_service.dart';

class AppSettingsService {
  Future<AppSettingsModel?> getAppSettings() async {
    try {
      final uri = Uri.parse('${ApiService.baseUrl}/app-settings');
      final response = await http.get(
        uri,
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic> && data['success'] == true) {
          return AppSettingsModel.fromJson(data);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
