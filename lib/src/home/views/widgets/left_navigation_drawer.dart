import 'package:flutter/material.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';

class LeftNavigationDrawer extends StatelessWidget {
  final String activeRoute;

  const LeftNavigationDrawer({
    super.key,
    required this.activeRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Drawer User Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
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
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Sarah J.',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
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
                      isActive: activeRoute == AppRoutes.home,
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.school_outlined,
                      label: 'My Courses',
                      route: '/my-courses',
                      isActive: false,
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.alt_route_outlined,
                      label: 'Learning Paths',
                      route: '/paths',
                      isActive: false,
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.chat_bubble_outline_outlined,
                      label: 'Community',
                      route: '/community',
                      isActive: false,
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.person_outline_outlined,
                      label: 'Profile',
                      route: '/profile',
                      isActive: false,
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.settings_outlined,
                      label: 'Settings',
                      route: '/settings',
                      isActive: false,
                    ),
                  ],
                ),
              ),

              const Divider(color: Colors.white24, height: 1),

              // Logout Button
              Padding(
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
            ],
          ),
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
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.white.withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? Colors.white : (isLogout ? Colors.white.withOpacity(0.8) : Colors.white),
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : (isLogout ? Colors.white.withOpacity(0.8) : Colors.white),
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            fontSize: 15,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: () {
          Navigator.pop(context); // Close Drawer
          if (isLogout) {
            Navigator.pushReplacementNamed(context, AppRoutes.login);
          } else if (route != activeRoute && route.startsWith('/')) {
            // Check if route exists, else we can simulate/toast
            if (route == AppRoutes.home) {
              Navigator.pushReplacementNamed(context, route);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('"$label" module is coming soon!'),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
