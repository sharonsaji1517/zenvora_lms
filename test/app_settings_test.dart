import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:zenvoraapp/models/app_settings_model.dart';
import 'package:zenvoraapp/models/slider_model.dart';
import 'package:zenvoraapp/core/services/app_settings_service.dart';
import 'package:zenvoraapp/core/utils/color_helper.dart';
import 'package:zenvoraapp/core/theme/app_theme.dart';
import 'package:zenvoraapp/viewmodels/app_settings_provider.dart';
import 'package:zenvoraapp/widgets/dynamic_logo_widget.dart';

class MockAppSettingsService extends AppSettingsService {
  final bool shouldFail;
  final AppSettingsModel? mockData;

  MockAppSettingsService({this.shouldFail = false, this.mockData});

  @override
  Future<AppSettingsModel?> getAppSettings() async {
    if (shouldFail) return null;
    return mockData ?? AppSettingsModel.defaults();
  }
}

void main() {
  group('ColorHelper tests', () {
    const fallbackColor = Colors.red;

    test('parses valid 6-digit hex string with #', () {
      final color = ColorHelper.parseHexColor('#5485C4', fallback: fallbackColor);
      expect(color.toARGB32(), 0xFF5485C4);
    });

    test('parses valid 6-digit hex string without #', () {
      final color = ColorHelper.parseHexColor('5485C4', fallback: fallbackColor);
      expect(color.toARGB32(), 0xFF5485C4);
    });

    test('parses valid 8-digit hex string', () {
      final color = ColorHelper.parseHexColor('#FF5485C4', fallback: fallbackColor);
      expect(color.toARGB32(), 0xFF5485C4);
    });

    test('returns fallback for null string', () {
      final color = ColorHelper.parseHexColor(null, fallback: fallbackColor);
      expect(color, fallbackColor);
    });

    test('returns fallback for empty string', () {
      final color = ColorHelper.parseHexColor('   ', fallback: fallbackColor);
      expect(color, fallbackColor);
    });

    test('returns fallback for invalid hex string', () {
      final color = ColorHelper.parseHexColor('INVALID_HEX', fallback: fallbackColor);
      expect(color, fallbackColor);
    });
  });

  group('AppTheme dynamic theme tests', () {
    test('getTheme generates ThemeData with dynamic primary and secondary colors', () {
      const customPrimary = Color(0xFF112233);
      const customSecondary = Color(0xFF445566);

      final theme = AppTheme.getTheme(primary: customPrimary, secondary: customSecondary);

      expect(theme.colorScheme.primary, customPrimary);
      expect(theme.colorScheme.secondary, customSecondary);
    });

    test('getTheme falls back to default Zenvora colors when parameters are null', () {
      final theme = AppTheme.getTheme();

      expect(theme.colorScheme.primary, AppTheme.primaryBlue);
      expect(theme.colorScheme.secondary, AppTheme.secondaryBlue);
    });
  });

  group('DynamicLogoWidget tests', () {
    testWidgets('renders fallback asset when appLogo is null or empty', (WidgetTester tester) async {
      final provider = AppSettingsProvider();
      await tester.pumpWidget(
        ChangeNotifierProvider<AppSettingsProvider>.value(
          value: provider,
          child: const MaterialApp(
            home: Scaffold(
              body: DynamicLogoWidget(width: 50, height: 50),
            ),
          ),
        ),
      );

      expect(find.byType(DynamicLogoWidget), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });
  });

  group('SliderModel tests', () {
    test('fromJson parses valid map correctly', () {
      final json = {
        'id': 2,
        'title': 'Test Banner',
        'image': 'https://example.com/banner.jpg',
        'order': 1,
      };

      final slider = SliderModel.fromJson(json);
      expect(slider.id, 2);
      expect(slider.title, 'Test Banner');
      expect(slider.image, 'https://example.com/banner.jpg');
      expect(slider.order, 1);
    });

    test('fromJson handles string IDs and orders safely', () {
      final json = {
        'id': '5',
        'title': 'Banner 2',
        'image': 'https://example.com/banner2.jpg',
        'order': '3',
      };

      final slider = SliderModel.fromJson(json);
      expect(slider.id, 5);
      expect(slider.order, 3);
    });
  });

  group('AppSettingsModel tests', () {
    test('fromJson parses API response format correctly', () {
      final json = {
        'success': true,
        'data': {
          'app_name': 'EduZenvora',
          'app_logo': 'https://example.com/logo.png',
          'primary_color': '#5485c4',
          'secondary_color': '#000000',
          'sliders': [
            {
              'id': 1,
              'title': 'Slider 1',
              'image': 'https://example.com/slide1.jpg',
              'order': 1,
            }
          ]
        }
      };

      final settings = AppSettingsModel.fromJson(json);
      expect(settings.appName, 'EduZenvora');
      expect(settings.appLogo, 'https://example.com/logo.png');
      expect(settings.primaryColor, '#5485c4');
      expect(settings.secondaryColor, '#000000');
      expect(settings.sliders.length, 1);
      expect(settings.sliders.first.title, 'Slider 1');
    });

    test('defaults returns safe initial state', () {
      final defaults = AppSettingsModel.defaults();
      expect(defaults.appName, 'EduZenvora');
      expect(defaults.appLogo, isNull);
      expect(defaults.primaryColor, '#5485c4');
      expect(defaults.secondaryColor, '#000000');
      expect(defaults.sliders, isEmpty);
    });
  });

  group('AppSettingsProvider tests', () {
    test('initial state uses safe defaults', () {
      final provider = AppSettingsProvider();
      expect(provider.appName, 'EduZenvora');
      expect(provider.appLogo, isNull);
      expect(provider.primaryColor, '#5485c4');
      expect(provider.secondaryColor, '#000000');
      expect(provider.sliders, isEmpty);
      expect(provider.isLoading, false);
      expect(provider.hasError, false);
    });

    test('fetchAppSettings updates state on successful fetch', () async {
      final customModel = AppSettingsModel(
        appName: 'Custom LMS',
        appLogo: 'https://example.com/logo.png',
        primaryColor: '#123456',
        secondaryColor: '#654321',
        sliders: [
          SliderModel(id: 1, title: 'T1', image: 'img1', order: 1),
        ],
      );

      final mockService = MockAppSettingsService(mockData: customModel);
      final provider = AppSettingsProvider(service: mockService);

      await provider.fetchAppSettings();

      expect(provider.appName, 'Custom LMS');
      expect(provider.appLogo, 'https://example.com/logo.png');
      expect(provider.primaryColor, '#123456');
      expect(provider.secondaryColor, '#654321');
      expect(provider.sliders.length, 1);
      expect(provider.isLoading, false);
      expect(provider.hasError, false);
    });

    test('fetchAppSettings preserves safe defaults and sets error state on failure', () async {
      final mockService = MockAppSettingsService(shouldFail: true);
      final provider = AppSettingsProvider(service: mockService);

      await provider.fetchAppSettings();

      expect(provider.appName, 'EduZenvora');
      expect(provider.isLoading, false);
      expect(provider.hasError, true);
      expect(provider.errorMessage, isNotNull);
    });
  });
}
