import 'slider_model.dart';

class AppSettingsModel {
  final String appName;
  final String? appLogo;
  final String primaryColor;
  final String secondaryColor;
  final List<SliderModel> sliders;

  AppSettingsModel({
    required this.appName,
    this.appLogo,
    required this.primaryColor,
    required this.secondaryColor,
    required this.sliders,
  });

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data =
        (json['data'] is Map<String, dynamic>)
            ? json['data'] as Map<String, dynamic>
            : json;

    final List<SliderModel> sliderList = [];
    if (data['sliders'] is List) {
      for (var item in data['sliders']) {
        if (item is Map<String, dynamic>) {
          sliderList.add(SliderModel.fromJson(item));
        }
      }
    }

    return AppSettingsModel(
      appName: data['app_name']?.toString() ?? 'EduZenvora',
      appLogo: data['app_logo']?.toString(),
      primaryColor: data['primary_color']?.toString() ?? '#5485c4',
      secondaryColor: data['secondary_color']?.toString() ?? '#000000',
      sliders: sliderList,
    );
  }

  factory AppSettingsModel.defaults() {
    return AppSettingsModel(
      appName: 'EduZenvora',
      appLogo: null,
      primaryColor: '#5485c4',
      secondaryColor: '#000000',
      sliders: const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'app_name': appName,
      'app_logo': appLogo,
      'primary_color': primaryColor,
      'secondary_color': secondaryColor,
      'sliders': sliders.map((s) => s.toJson()).toList(),
    };
  }
}
