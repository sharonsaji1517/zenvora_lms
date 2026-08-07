import 'package:flutter/material.dart';

/// A reusable badge widget for menu list tiles.
/// Supports text badges (e.g. "NEW"), numeric count badges (e.g. "2", "4"),
/// or custom child widgets.
class MenuTileBadge extends StatelessWidget {
  /// The text content of the badge (e.g., "NEW", "2", "4").
  final String? text;

  /// Optional custom child widget if text is not used.
  final Widget? child;

  /// Optional background color override.
  final Color? backgroundColor;

  /// Optional text color override.
  final Color? textColor;

  /// Optional padding around the badge content.
  final EdgeInsetsGeometry? padding;

  /// Optional border radius.
  final BorderRadius? borderRadius;

  const MenuTileBadge({
    super.key,
    this.text,
    this.child,
    this.backgroundColor,
    this.textColor,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    if (child != null) return child!;
    if (text == null || text!.isEmpty) return const SizedBox.shrink();

    final isNumeric = int.tryParse(text!) != null;
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    final defaultBgColor = isNumeric
        ? primaryColor.withOpacity(0.12)
        : (theme.colorScheme.secondary.computeLuminance() > 0.01
            ? theme.colorScheme.secondary
            : Colors.amber.shade700);

    final defaultTextColor = isNumeric ? primaryColor : Colors.white;

    final effectivePadding = padding ??
        EdgeInsets.symmetric(
          horizontal: isNumeric ? 8.0 : 10.0,
          vertical: isNumeric ? 3.0 : 4.0,
        );

    final effectiveRadius = borderRadius ??
        BorderRadius.circular(isNumeric ? 12.0 : 6.0);

    return Container(
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: backgroundColor ?? defaultBgColor,
        borderRadius: effectiveRadius,
      ),
      child: Text(
        text!,
        style: TextStyle(
          color: textColor ?? defaultTextColor,
          fontSize: 11.0,
          fontWeight: FontWeight.bold,
          letterSpacing: isNumeric ? 0.0 : 0.5,
        ),
      ),
    );
  }
}
