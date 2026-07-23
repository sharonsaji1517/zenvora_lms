import 'package:flutter/material.dart';
import '../core/routes/app_routes.dart';
import '../screens/home_screen.dart';
import '../src/courses/views/my_courses_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';
import '../core/theme/app_theme.dart';
import '../core/services/user_preferences_service.dart';

enum DrawerItem { home, myCourses, learningPaths, community, profile, settings }

class CustomDrawer extends StatefulWidget {
  final DrawerItem activeItem;

  const CustomDrawer({super.key, required this.activeItem});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String _fullName = 'Guest User';
  String _email = 'guest@example.com';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefsService = UserPreferencesService();
    final name = await prefsService.getFullName();
    final email = await prefsService.getEmail();
    setState(() {
      _fullName = name;
      _email = email;
    });
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (context) => screen));
  }

  void _showLogoutDialog(BuildContext context) {
    bool isLoggingOut = false;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Logout'),
              content: const Text('Are you sure you want to logout from Zenvora?'),
              actions: [
                TextButton(
                  onPressed: isLoggingOut
                      ? null
                      : () {
                          Navigator.of(dialogContext).pop(); // Dismiss Dialog
                        },
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
                TextButton(
                  onPressed: isLoggingOut
                      ? null
                      : () async {
                          setState(() {
                            isLoggingOut = true;
                          });
                          final success = await UserPreferencesService().logoutUser(context);
                          if (success) {
                            debugPrint("Whether navigation to Login Screen is executed: true");
                            if (dialogContext.mounted) {
                              Navigator.of(dialogContext).pop(); // Close confirm dialog
                            }
                            if (context.mounted) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                AppRoutes.login,
                                (Route<dynamic> route) => false,
                              );
                            }
                          } else {
                            debugPrint("Whether navigation to Login Screen is executed: false");
                            if (dialogContext.mounted) {
                              setState(() {
                                isLoggingOut = false;
                              });
                            }
                          }
                        },
                  child: isLoggingOut
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.redAccent,
                          ),
                        )
                      : const Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drawer Profile Header
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
            currentAccountPicture: Container(
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
                        size: 36,
                        color: Colors.grey.shade600,
                      ),
                    );
                  },
                ),
              ),
            ),
            accountName: Text(
              _fullName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            accountEmail: Text(
              _email,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),

          // Navigation Items List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                _buildTile(
                  context,
                  icon: Icons.dashboard_outlined,
                  activeIcon: Icons.dashboard,
                  label: 'Home Dashboard',
                  isSelected: widget.activeItem == DrawerItem.home,
                  onTap: () => _navigateTo(context, const HomeScreen()),
                ),
                _buildTile(
                  context,
                  icon: Icons.school_outlined,
                  activeIcon: Icons.school,
                  label: 'My Enrolled Courses',
                  isSelected: widget.activeItem == DrawerItem.myCourses,
                  onTap: () => _navigateTo(context, const MyCoursesScreen()),
                ),
                _buildTile(
                  context,
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'My Profile',
                  isSelected: widget.activeItem == DrawerItem.profile,
                  onTap: () => _navigateTo(context, const ProfileScreen()),
                ),
                _buildTile(
                  context,
                  icon: Icons.settings_outlined,
                  activeIcon: Icons.settings,
                  label: 'Settings',
                  isSelected: widget.activeItem == DrawerItem.settings,
                  onTap: () => _navigateTo(context, const SettingsScreen()),
                ),
              ],
            ),
          ),

          const Divider(),

          // Logout item
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onTap: () {
                Navigator.of(context).pop(); // Close Drawer
                _showLogoutDialog(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(
          isSelected ? activeIcon : icon,
          color: isSelected
              ? colorScheme.primary
              : Colors.grey[700] ?? Colors.black54,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected ? colorScheme.primary : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 14.5,
          ),
        ),
        selected: isSelected,
        selectedTileColor: AppTheme.primaryBlue.withOpacity(0.12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: isSelected ? () => Navigator.of(context).pop() : onTap,
      ),
    );
  }
}
