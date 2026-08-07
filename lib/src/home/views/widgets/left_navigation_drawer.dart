import 'package:flutter/material.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/user_preferences_service.dart';
import '../../../../widgets/menu_list_tile.dart';

class LeftNavigationDrawer extends StatefulWidget {
  final String activeRoute;

  const LeftNavigationDrawer({
    super.key,
    required this.activeRoute,
  });

  @override
  State<LeftNavigationDrawer> createState() => _LeftNavigationDrawerState();
}

class _LeftNavigationDrawerState extends State<LeftNavigationDrawer> {
  String _fullName = 'Guest User';
  bool _isLoggingOut = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefsService = UserPreferencesService();
    final name = await prefsService.getFullName();
    setState(() {
      _fullName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.brandThreeColorGradient,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Drawer User Header with Blue -> Green Gradient Background
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.15),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(24),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/profile.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey.shade200,
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.person,
                                  size: 28,
                                  color: Colors.grey.shade600,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _fullName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 2),
                            const Text(
                              'Rig Operator Trainee',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const Divider(color: Colors.white24, height: 1),
            
            // Drawer Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                children: [
                  _buildDrawerItem(
                    context,
                    icon: Icons.home_outlined,
                    label: 'Home',
                    route: AppRoutes.home,
                    isActive: widget.activeRoute == AppRoutes.home,
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.school_outlined,
                    label: 'My Courses',
                    route: AppRoutes.myCourses,
                    isActive: widget.activeRoute == AppRoutes.myCourses,
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.person_outline_outlined,
                    label: 'Profile',
                    route: AppRoutes.profile,
                    isActive: widget.activeRoute == AppRoutes.profile,
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    route: AppRoutes.settings,
                    isActive: widget.activeRoute == AppRoutes.settings,
                  ),
                ],
              ),
            ),

            const Divider(color: Colors.white24, height: 1),

            // Logout Button at the bottom
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildDrawerItem(
                  context,
                  icon: Icons.logout_outlined,
                  label: 'Logout',
                  route: AppRoutes.login,
                  isActive: false,
                  isLogout: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
    required bool isActive,
    bool isLogout = false,
    String? badgeText,
    int? badgeCount,
    Widget? badgeWidget,
    Color? badgeColor,
    Color? badgeTextColor,
  }) {
    final effectiveTrailing = AppMenuListTile.buildTrailingWithBadge(
      badgeText: badgeText,
      badgeCount: badgeCount,
      badgeWidget: badgeWidget,
      badgeColor: badgeColor,
      badgeTextColor: badgeTextColor,
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? AppTheme.brandGoldenYellow.withOpacity(0.18) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? AppTheme.brandGoldenYellow : (isLogout ? Colors.white.withOpacity(0.8) : Colors.white),
        ),
        title: _isLoggingOut && isLogout
            ? const Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                ),
              )
            : Text(
                label,
                style: TextStyle(
                  color: isActive ? AppTheme.brandGoldenYellow : (isLogout ? Colors.white.withOpacity(0.8) : Colors.white),
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  fontSize: 15,
                ),
              ),
        trailing: effectiveTrailing,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: _isLoggingOut
            ? null
            : () async {
                if (isLogout) {
                  setState(() {
                    _isLoggingOut = true;
                  });
                  final success = await UserPreferencesService().logoutUser(context);
                  if (success) {
                    debugPrint("Whether navigation to Login Screen is executed: true");
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.login,
                        (Route<dynamic> route) => false,
                      );
                    }
                  } else {
                    debugPrint("Whether navigation to Login Screen is executed: false");
                    if (mounted) {
                      setState(() {
                        _isLoggingOut = false;
                      });
                    }
                  }
                } else if (route != widget.activeRoute) {
                  Navigator.pop(context); // Close Drawer
                  Navigator.pushReplacementNamed(context, route);
                }
              },
      ),
    );
  }
}
