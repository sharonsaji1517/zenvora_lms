import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/user_preferences_service.dart';
import '../../../core/theme/app_theme.dart';

import 'package:provider/provider.dart';
import '../../../../viewmodels/app_settings_provider.dart';
import '../../../../widgets/dynamic_logo_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  final UserPreferencesService _preferencesService = UserPreferencesService();

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _startNavigationTimer();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _animationController.forward();
  }

  void _startNavigationTimer() {
    Timer(const Duration(milliseconds: 2500), _checkOnboardingAndNavigate);
  }

  Future<void> _checkOnboardingAndNavigate() async {
    if (!mounted) return;

    final hasSeenOnboarding = await _preferencesService.hasSeenOnboarding();
    final isLoggedIn = await _preferencesService.isLoggedIn();

    if (!mounted) return;

    if (!hasSeenOnboarding) {
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    } else if (!isLoggedIn) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsProvider>();
    final appName = settings.appName.isNotEmpty ? settings.appName : 'Zenvora';

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradientOf(context),
        ),
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Zenvora Logo Container
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const DynamicLogoWidget(
                        width: 72,
                        height: 72,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // App Title
                    Text(
                      appName,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Subtitle
                    Text(
                      'Empowering Oil & Gas Education',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppTheme.white.withOpacity(0.85),
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
