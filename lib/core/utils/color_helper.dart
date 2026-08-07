import 'package:flutter/material.dart';

class ColorHelper {
  /// Safely converts a HEX color string (e.g. "#5485C4", "5485C4", "0x5485C4") into a Flutter [Color].
  /// Returns [fallback] if parsing fails, string is empty/null, or format is invalid.
  static Color parseHexColor(String? hexString, {required Color fallback}) {
    if (hexString == null) return fallback;

    final trimmed = hexString.trim();
    if (trimmed.isEmpty) return fallback;

    try {
      String cleanHex = trimmed.replaceAll('#', '');
      if (cleanHex.startsWith('0x') || cleanHex.startsWith('0X')) {
        cleanHex = cleanHex.substring(2);
      }

      if (cleanHex.length == 6) {
        cleanHex = 'FF$cleanHex';
      }

      if (cleanHex.length == 8) {
        final int colorVal = int.parse(cleanHex, radix: 16);
        return Color(colorVal);
      }
    } catch (_) {
      return fallback;
    }

    return fallback;
  }
}
