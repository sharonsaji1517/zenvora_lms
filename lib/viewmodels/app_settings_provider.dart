import 'package:flutter/material.dart';
import '../core/services/app_settings_service.dart';
import '../models/app_settings_model.dart';
import '../models/slider_model.dart';

class AppSettingsProvider extends ChangeNotifier {
  final AppSettingsService _service;

  AppSettingsModel _appSettings = AppSettingsModel.defaults();
  bool _isLoading = false;
  String? _errorMessage;

  AppSettingsProvider({AppSettingsService? service})
      : _service = service ?? AppSettingsService();

  // Getters
  AppSettingsModel get appSettings => _appSettings;
  AppSettingsModel get settings => _appSettings;

  String get appName => _appSettings.appName;
  String? get appLogo => _appSettings.appLogo;
  String get primaryColor => _appSettings.primaryColor;
  String get secondaryColor => _appSettings.secondaryColor;
  List<SliderModel> get sliders => List.unmodifiable(_appSettings.sliders);

  // Loading state
  bool get isLoading => _isLoading;
  bool get loading => _isLoading;

  // Error state
  String? get errorMessage => _errorMessage;
  String? get error => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get isError => _errorMessage != null;

  /// Fetches App Settings from the backend API.
  /// Stores latest settings in memory and fallback to safe defaults on failure.
  Future<void> fetchAppSettings() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _service.getAppSettings();
      if (result != null) {
        _appSettings = result;
        _errorMessage = null;
      } else {
        _errorMessage = 'Failed to load app settings from server.';
      }
    } catch (e) {
      _errorMessage = 'Error fetching app settings: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

typedef AppSettingsViewModel = AppSettingsProvider;
