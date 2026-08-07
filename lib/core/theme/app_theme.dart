import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors (Zenvora Group Branding)
  static const Color primaryBlue = Color(0xFF163A5F);
  static const Color secondaryBlue = Color(0xFF1976D2);
  static const Color accentGreen = Color(0xFF43A047);
  static const Color lightGreen = Color(0xFF66BB6A);
  static const Color goldenAccent = Color(0xFFF9A825);
  static const Color white = Colors.white;
  
  // Brand Colors (Zenvora Group Branding - Extracted from Logo)
  static const Color brandDeepBlue = Color(0xFF163A5F);
  static const Color brandOceanBlue = Color(0xFF1E88E5);
  static const Color brandEmeraldGreen = Color(0xFF2EAF4A);
  static const Color brandGoldenYellow = Color(0xFFF9B000);
  
  // Legacy color constants mapped to the new branding to avoid compile issues
  static const Color primaryTeal = primaryBlue;
  static const Color secondaryTeal = secondaryBlue;
  static const Color accentCyan = lightGreen;
  static const Color accentOrange = goldenAccent;

  // Backgrounds & Neutrals
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color cardLight = Colors.white;
  static const Color textDark = Color(0xFF0F172A);
  static const Color textMedium = Color(0xFF475569);
  static const Color textLight = Color(0xFF94A3B8);
  static const Color borderLight = Color(0xFFE2E8F0);
  
  // Static Gradients (Fallback)
  static const LinearGradient brandThreeColorGradient = LinearGradient(
    colors: [
      brandDeepBlue,
      brandOceanBlue,
      brandEmeraldGreen,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient brandBlueGreenGradient = LinearGradient(
    colors: [
      brandOceanBlue,
      brandEmeraldGreen,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient brandBackgroundGradient = LinearGradient(
    colors: [
      Color(0xFFEDF4FE),
      Color(0xFFF6F9FF),
      Color(0xFFEEF9F0),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      primaryBlue,
      accentGreen,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient greenGradient = LinearGradient(
    colors: [
      accentGreen,
      lightGreen,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [
      primaryBlue,
      secondaryBlue,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Dynamic Gradients
  static LinearGradient getBrandThreeColorGradient({Color? primary, Color? secondary}) {
    return LinearGradient(
      colors: [
        primary ?? brandDeepBlue,
        secondary ?? brandOceanBlue,
        brandEmeraldGreen,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static LinearGradient getBrandBlueGreenGradient({Color? secondary}) {
    return LinearGradient(
      colors: [
        secondary ?? brandOceanBlue,
        brandEmeraldGreen,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static LinearGradient getPrimaryGradient({Color? primary}) {
    return LinearGradient(
      colors: [
        primary ?? primaryBlue,
        accentGreen,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static LinearGradient getBackgroundGradient({Color? primary, Color? secondary}) {
    return LinearGradient(
      colors: [
        primary ?? primaryBlue,
        secondary ?? secondaryBlue,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  /// Builds a [ThemeData] instance dynamically based on [primary] and [secondary] brand colors.
  /// Automatically falls back to default Zenvora branding if null.
  static ThemeData getTheme({Color? primary, Color? secondary}) {
    final Color effectivePrimary = primary ?? primaryBlue;
    final Color effectiveSecondary = secondary ?? secondaryBlue;

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: effectivePrimary,
        primary: effectivePrimary,
        secondary: effectiveSecondary,
        tertiary: accentGreen,
        surface: backgroundLight,
      ),
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textDark,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: textDark,
          letterSpacing: -0.2,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textDark,
        ),
        bodyLarge: TextStyle(
          fontSize: 15,
          color: textDark,
          height: 1.4,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: textMedium,
          height: 1.4,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: textLight,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: effectivePrimary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
        hintStyle: const TextStyle(color: textLight, fontSize: 14),
        labelStyle: const TextStyle(color: textMedium, fontSize: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: cardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderLight, width: 0.8),
        ),
      ),
    );
  }

  static ThemeData get lightTheme => getTheme();
}
