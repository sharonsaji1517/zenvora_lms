import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../../../viewmodels/app_settings_provider.dart';
import '../../../../widgets/dynamic_logo_widget.dart';
import '../view_models/home_view_model.dart';
import 'widgets/left_navigation_drawer.dart';
import 'widgets/promo_banner_slider.dart';
import 'widgets/top_categories_section.dart';
import 'widgets/popular_courses_section.dart';
import 'package:zenvoraapp/screens/profile_screen.dart';
import 'package:zenvoraapp/screens/instructors_screen.dart';
import 'package:zenvoraapp/screens/courses_screen.dart';
import '../../courses/views/my_courses_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeViewModel _viewModel;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _viewModel = HomeViewModel();
    // Simulate initial data loading
    _viewModel.loadHomeData();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsProvider>();
    final appName = settings.appName.isNotEmpty ? settings.appName : 'Zenvora';

    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.brandBackgroundGradientOf(context),
      ),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        drawer: const LeftNavigationDrawer(activeRoute: AppRoutes.home),

        // Top Navigation Bar
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          titleSpacing: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: AppTheme.brandThreeColorGradientOf(context),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const ClipOval(
                  child: Padding(
                    padding: EdgeInsets.all(4),
                    child: DynamicLogoWidget(
                      width: 32,
                      height: 32,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                appName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Badge(
                backgroundColor: AppTheme.brandGoldenYellow,
                label: Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Notifications center coming soon'),
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
          ],
        ),

        // Main Scrollable Body using View Model state
        body: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, child) {
            if (_viewModel.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryBlue),
              );
            }

            if (_viewModel.errorMessage != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(_viewModel.errorMessage!),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _viewModel.loadHomeData(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return CustomScrollView(
              slivers: [
                // Welcome Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good Morning, ${_viewModel.firstName} 👋',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.textLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Ready for your next shift?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Horizontal Promo Banner Slider
                SliverToBoxAdapter(
                  child: PromoBannerSlider(viewModel: _viewModel),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),

                // Section 1: Top Categories (Horizontal Scroll)
                SliverToBoxAdapter(
                  child: TopCategoriesSection(viewModel: _viewModel),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 28)),

                // Section 2: Popular Courses (Horizontal Scroll)
                SliverToBoxAdapter(
                  child: PopularCoursesSection(viewModel: _viewModel),
                ),

                // Bottom padding
                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            );
          },
        ),

        // Custom Curved Bottom Navigation Bar
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          surfaceTintColor: Colors.white,
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          elevation: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                icon: Icons.home_rounded,
                label: 'Home',
                isSelected: true,
              ),
              _buildNavItem(
                context,
                icon: Icons.groups_outlined,
                label: 'Instructors',
                isSelected: false,
              ),

              // Middle Add button placement space
              const SizedBox(width: 48),

              _buildNavItem(
                context,
                icon: Icons.school_outlined,
                label: 'Courses',
                isSelected: false,
              ),
              _buildNavItem(
                context,
                icon: Icons.person_outline,
                label: 'Profile',
                isSelected: false,
              ),
            ],
          ),
        ),

        // Floating Action Button resting inside BottomAppBar notch opening Courses screen
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            gradient: AppTheme.brandBlueGreenGradientOf(context),
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyCoursesScreen(),
                ),
              );
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            highlightElevation: 0,
            shape: const CircleBorder(),
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    IconData? activeIcon,
    required String label,
    required bool isSelected,
  }) {
    final inactiveColor = Theme.of(context).colorScheme.secondary.withValues(alpha: 0.6);

    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          isSelected ? (activeIcon ?? icon) : icon,
          color: isSelected ? Colors.white : inactiveColor,
          size: 22,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : inactiveColor,
          ),
        ),
      ],
    );

    return GestureDetector(
      onTap: () {
        if (label == 'Profile') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        } else if (label == 'Instructors') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const InstructorsScreen()),
          );
        } else if (label == 'Courses') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CoursesScreen()),
          );
        }
      },
      child: isSelected
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                gradient: AppTheme.brandBlueGreenGradientOf(context),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: content,
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              color: Colors.transparent,
              child: content,
            ),
    );
  }
}
