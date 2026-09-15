import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/color_helper.dart';
import 'viewmodels/app_settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appSettingsProvider = AppSettingsProvider();
  await appSettingsProvider.fetchAppSettings();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppSettingsProvider>.value(
          value: appSettingsProvider,
        ),
      ],
      child: const ZenvoraApp(),
    ),
  );
}

class ZenvoraApp extends StatelessWidget {
  const ZenvoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsProvider>();

    final primaryColor = ColorHelper.parseHexColor(
      settings.primaryColor,
      fallback: AppTheme.primaryBlue,
    );
    final secondaryColor = ColorHelper.parseHexColor(
      settings.secondaryColor,
      fallback: AppTheme.secondaryBlue,
    );

    return MaterialApp(
      title: settings.appName.isNotEmpty ? settings.appName : 'Zenvora',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(
        primary: primaryColor,
        secondary: secondaryColor,
      ),
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
