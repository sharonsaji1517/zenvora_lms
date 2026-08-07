import 'package:flutter/material.dart';
import '../src/home/views/widgets/left_navigation_drawer.dart';
import '../core/routes/app_routes.dart';
import '../widgets/menu_list_tile.dart';
import 'terms_and_conditions_screen.dart';
import 'help_center_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      drawer: const LeftNavigationDrawer(activeRoute: AppRoutes.settings),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              children: [
                // Preferences Header
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Text(
                    'Preferences',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                
                // Dark Mode Switch
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey[300]!, width: 0.8),
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        value: _darkModeEnabled,
                        onChanged: (bool value) {
                          setState(() {
                            _darkModeEnabled = value;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(value ? 'Dark Mode enabled.' : 'Dark Mode disabled.'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                        title: const Text(
                          'Dark Mode',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
                        ),
                        subtitle: const Text(
                          'Adjust interface theme colors',
                          style: TextStyle(fontSize: 11.5),
                        ),
                        secondary: Icon(
                          _darkModeEnabled ? Icons.dark_mode : Icons.light_mode,
                          color: _darkModeEnabled ? Colors.amber : Colors.grey,
                        ),
                        activeColor: colorScheme.primary,
                      ),
                    ],
                  ),
                ),

                // Legal Header
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  child: Text(
                    'Legal & Info',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                // Legal & Info Card
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey[300]!, width: 0.8),
                  ),
                  child: Column(
                    children: [
                      _buildSettingsTile(
                        icon: Icons.info_outline,
                        title: 'Privacy Policy',
                        subtitle: 'Read terms, user agreements and data privacy policies',
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Navigating to Privacy Policy portal...'),
                              backgroundColor: colorScheme.primary,
                            ),
                          );
                        },
                      ),
                      const Divider(height: 1, indent: 56),
                      _buildSettingsTile(
                        icon: Icons.description_outlined,
                        title: 'Terms & Conditions',
                        subtitle: 'Read our terms and conditions.',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TermsAndConditionsScreen()),
                          );
                        },
                      ),
                      const Divider(height: 1, indent: 56),
                      _buildSettingsTile(
                        icon: Icons.support_agent_outlined,
                        title: 'Help Center',
                        subtitle: 'Get support and contact us.',
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HelpCenterScreen()),
                          );
                        },
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // App Version details
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              children: [
                Text(
                  'App Version: 1.0.0',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '© 2026 Zenvora',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    String? badgeText,
    int? badgeCount,
    Widget? badgeWidget,
    Color? badgeColor,
    Color? badgeTextColor,
    ShapeBorder? shape,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 11.5),
      ),
      trailing: AppMenuListTile.buildTrailingWithBadge(
        trailing: const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
        badgeText: badgeText,
        badgeCount: badgeCount,
        badgeWidget: badgeWidget,
        badgeColor: badgeColor,
        badgeTextColor: badgeTextColor,
      ),
      shape: shape,
      onTap: onTap,
    );
  }
}

