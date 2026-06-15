import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/my_courses_screen.dart';
import '../screens/learning_paths_screen.dart';
import '../screens/community_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings_screen.dart';

enum DrawerItem {
  home,
  myCourses,
  learningPaths,
  community,
  profile,
  settings,
}

class CustomDrawer extends StatelessWidget {
  final DrawerItem activeItem;

  const CustomDrawer({
    super.key,
    required this.activeItem,
  });

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out of Zenvora LMS?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss Dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss Dialog
                // Clear stack and navigate back to Login Screen
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drawer Profile Header
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary,
                  colorScheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            currentAccountPicture: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=200',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            accountName: const Text(
              'Sarah J.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            accountEmail: const Text(
              'sarah.j@zenvora.com',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
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
                  isSelected: activeItem == DrawerItem.home,
                  onTap: () => _navigateTo(context, const HomeScreen()),
                ),
                _buildTile(
                  context,
                  icon: Icons.school_outlined,
                  activeIcon: Icons.school,
                  label: 'My Enrolled Courses',
                  isSelected: activeItem == DrawerItem.myCourses,
                  onTap: () => _navigateTo(context, const MyCoursesScreen()),
                ),
                _buildTile(
                  context,
                  icon: Icons.alt_route_outlined,
                  activeIcon: Icons.alt_route,
                  label: 'Learning Paths',
                  isSelected: activeItem == DrawerItem.learningPaths,
                  onTap: () => _navigateTo(context, const LearningPathsScreen()),
                ),
                _buildTile(
                  context,
                  icon: Icons.forum_outlined,
                  activeIcon: Icons.forum,
                  label: 'Community Feed',
                  isSelected: activeItem == DrawerItem.community,
                  onTap: () => _navigateTo(context, const CommunityScreen()),
                ),
                _buildTile(
                  context,
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'My Profile',
                  isSelected: activeItem == DrawerItem.profile,
                  onTap: () => _navigateTo(context, const ProfileScreen()),
                ),
                _buildTile(
                  context,
                  icon: Icons.settings_outlined,
                  activeIcon: Icons.settings,
                  label: 'Settings',
                  isSelected: activeItem == DrawerItem.settings,
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
          color: isSelected ? colorScheme.primary : Colors.grey[700] ?? Colors.black54,
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
        selectedTileColor: colorScheme.primary.withOpacity(0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: isSelected ? () => Navigator.of(context).pop() : onTap,
      ),
    );
  }
}
