import 'package:flutter/material.dart';
import 'menu_tile_badge.dart';

/// A standard, flexible menu list tile widget supporting optional trailing badges.
///
/// Badges can be passed via [badgeText] (e.g. "NEW", "2", "4"), [badgeCount] (int),
/// or a custom [badgeWidget]. When no badge is provided, the tile renders cleanly
/// without displaying a badge.
class AppMenuListTile extends StatelessWidget {
  final Widget? leading;
  final IconData? icon;
  final IconData? activeIcon;
  final String title;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback? onTap;
  final Widget? trailing;

  /// Optional badge text (e.g. "NEW", "2", "4"). Defaults to null (no badge shown).
  final String? badgeText;

  /// Optional integer badge count. Converted to string if provided.
  final int? badgeCount;

  /// Optional custom badge widget override.
  final Widget? badgeWidget;

  /// Optional badge background color.
  final Color? badgeColor;

  /// Optional badge text color.
  final Color? badgeTextColor;

  final ShapeBorder? shape;
  final Color? selectedTileColor;
  final Color? iconColor;
  final Color? textColor;

  const AppMenuListTile({
    super.key,
    this.leading,
    this.icon,
    this.activeIcon,
    required this.title,
    this.subtitle,
    this.isSelected = false,
    this.onTap,
    this.trailing,
    this.badgeText,
    this.badgeCount,
    this.badgeWidget,
    this.badgeColor,
    this.badgeTextColor,
    this.shape,
    this.selectedTileColor,
    this.iconColor,
    this.textColor,
  });

  /// Helper to compose trailing widget with optional badge
  static Widget? buildTrailingWithBadge({
    Widget? trailing,
    String? badgeText,
    int? badgeCount,
    Widget? badgeWidget,
    Color? badgeColor,
    Color? badgeTextColor,
  }) {
    final effectiveBadgeText = badgeText ?? (badgeCount != null ? '$badgeCount' : null);

    Widget? badge;
    if (badgeWidget != null) {
      badge = badgeWidget;
    } else if (effectiveBadgeText != null && effectiveBadgeText.isNotEmpty) {
      badge = MenuTileBadge(
        text: effectiveBadgeText,
        backgroundColor: badgeColor,
        textColor: badgeTextColor,
      );
    }

    if (badge == null) {
      return trailing;
    }

    if (trailing != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          badge,
          const SizedBox(width: 8),
          trailing,
        ],
      );
    }

    return badge;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget? leadingWidget = leading;
    if (leadingWidget == null && icon != null) {
      final effectiveIcon = isSelected ? (activeIcon ?? icon!) : icon!;
      final effectiveIconColor = iconColor ??
          (isSelected ? colorScheme.primary : Colors.grey[700] ?? Colors.black54);
      leadingWidget = Icon(effectiveIcon, color: effectiveIconColor);
    }

    final effectiveTrailing = buildTrailingWithBadge(
      trailing: trailing,
      badgeText: badgeText,
      badgeCount: badgeCount,
      badgeWidget: badgeWidget,
      badgeColor: badgeColor,
      badgeTextColor: badgeTextColor,
    );

    return ListTile(
      leading: leadingWidget,
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? (isSelected ? colorScheme.primary : Colors.black87),
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          fontSize: 14.5,
        ),
      ),
      subtitle: subtitle != null ? Text(subtitle!, style: const TextStyle(fontSize: 11.5)) : null,
      trailing: effectiveTrailing,
      selected: isSelected,
      selectedTileColor: selectedTileColor ?? colorScheme.primary.withOpacity(0.12),
      shape: shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: onTap,
    );
  }
}
