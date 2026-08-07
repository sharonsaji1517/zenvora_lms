import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/app_settings_provider.dart';

class DynamicLogoWidget extends StatelessWidget {
  final double width;
  final double height;
  final BoxFit fit;
  final String fallbackAssetPath;

  const DynamicLogoWidget({
    super.key,
    this.width = 64,
    this.height = 64,
    this.fit = BoxFit.contain,
    this.fallbackAssetPath = 'assets/icon/app_icon.png',
  });

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsProvider>();
    final logoUrl = settings.appLogo;

    if (logoUrl != null && logoUrl.trim().isNotEmpty) {
      return Image.network(
        logoUrl.trim(),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildFallbackAsset(context),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildFallbackAsset(context);
        },
      );
    }

    return _buildFallbackAsset(context);
  }

  Widget _buildFallbackAsset(BuildContext context) {
    return Image.asset(
      fallbackAssetPath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => Icon(
        Icons.school_rounded,
        size: width,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
