import 'package:flutter/material.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const ZenvoraApp());
}

class ZenvoraApp extends StatelessWidget {
  const ZenvoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zenvora',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}
