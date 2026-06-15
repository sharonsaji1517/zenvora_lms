import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../view_models/home_view_model.dart';
import 'widgets/left_navigation_drawer.dart';
import 'widgets/promo_banner_slider.dart';
import 'widgets/course_category_grid.dart';
import 'widgets/rig_courses_list.dart';
import 'widgets/featured_courses_list.dart';

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
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.backgroundLight,
      drawer: const LeftNavigationDrawer(activeRoute: AppRoutes.home),
      
      // Top Navigation Bar
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: GestureDetector(
            onTap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            child: const CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=150',
              ),
            ),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.primaryTeal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.water_drop, color: AppTheme.primaryTeal, size: 20),
            ),
            const SizedBox(width: 8),
            const Text(
              'Zenvora',
              style: TextStyle(
                color: AppTheme.textDark,
                fontWeight: FontWeight.w800,
                fontSize: 20,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Badge(
              backgroundColor: AppTheme.accentOrange,
              label: Text('3'),
              child: Icon(Icons.notifications_none_rounded, color: AppTheme.textDark),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications center coming soon')),
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
              child: CircularProgressIndicator(color: AppTheme.primaryTeal),
            );
          }

          if (_viewModel.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
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
                        'Good Morning, Sarah 👋',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Ready for your next shift?',
                        style: TextStyle(
                          fontSize: 24,
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

              // Course Categories Grid
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CourseCategoryGrid(
                    viewModel: _viewModel,
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),

              // Rig-Associated Courses (Horizontal Scroll)
              SliverToBoxAdapter(
                child: RigCoursesList(
                  courses: _viewModel.rigCourses,
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),

              // Featured Courses (Vertical List)
              SliverToBoxAdapter(
                child: FeaturedCoursesList(
                  viewModel: _viewModel,
                  courses: _viewModel.featuredCourses,
                ),
              ),

              // Bottom padding
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
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
            _buildNavItem(context, icon: Icons.home_rounded, label: 'Home', isSelected: true),
            _buildNavItem(context, icon: Icons.school_outlined, label: 'Courses', isSelected: false),
            
            // Middle Add button placement space
            const SizedBox(width: 48),

            _buildNavItem(context, icon: Icons.forum_outlined, label: 'Community', isSelected: false),
            _buildNavItem(context, icon: Icons.person_outline, label: 'Profile', isSelected: false),
          ],
        ),
      ),
      
      // Floating Action Action Button styled like the mockup (resting inside BottomAppBar notch)
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Quick Action triggered! Add notes, search, or access resources.'),
              backgroundColor: AppTheme.primaryTeal,
            ),
          );
        },
        backgroundColor: AppTheme.primaryTeal,
        shape: const CircleBorder(),
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Navigating to $label screen...')),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? AppTheme.primaryTeal : AppTheme.textLight,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? AppTheme.primaryTeal : AppTheme.textLight,
            ),
          ),
        ],
      ),
    );
  }
}
