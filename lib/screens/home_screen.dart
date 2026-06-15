import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/reusable_course_card.dart';
import 'my_courses_screen.dart';
import 'community_screen.dart';
import 'profile_screen.dart';
import 'course_details_screen.dart';
import 'category_courses_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Page Controller for Banner Slider
  final PageController _bannerController = PageController();
  int _currentBannerIndex = 0;
  Timer? _bannerTimer;

  // Banner Data
  final List<Map<String, String>> _banners = [
    {
      'title': 'Oil & Gas Safety Fundamentals',
      'image': 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?auto=format&fit=crop&q=80&w=800',
    },
    {
      'title': 'Advanced Drilling Techniques',
      'image': 'https://images.unsplash.com/photo-1541888946425-d81bb19240f5?auto=format&fit=crop&q=80&w=800',
    },
    {
      'title': 'Offshore Platform Survival',
      'image': 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?auto=format&fit=crop&q=80&w=800',
    },
  ];

  // Course categories list
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Rig Operations', 'icon': Icons.precision_manufacturing_outlined},
    {'name': 'Safety', 'icon': Icons.health_and_safety_outlined},
    {'name': 'Technical', 'icon': Icons.engineering_outlined},
    {'name': 'HSE First Aid', 'icon': Icons.medical_services_outlined},
    {'name': 'Exploration', 'icon': Icons.travel_explore_outlined},
    {'name': 'Management', 'icon': Icons.manage_accounts_outlined},
  ];

  // Rig-associated courses data list
  final List<Map<String, dynamic>> _rigCourses = [
    {
      'title': 'Drilling Operations 101',
      'progress': 0.35,
      'image': 'https://images.unsplash.com/photo-1541888946425-d81bb19240f5?auto=format&fit=crop&q=80&w=400',
    },
    {
      'title': 'Offshore Platform Safety',
      'progress': 0.70,
      'image': 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?auto=format&fit=crop&q=80&w=400',
    },
    {
      'title': 'HSE Standards & Safety',
      'progress': 0.12,
      'image': 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?auto=format&fit=crop&q=80&w=400',
    },
  ];

  // Featured courses data list
  final List<Map<String, dynamic>> _featuredCourses = [
    {
      'title': 'Advanced Well Control',
      'price': '\$149',
      'image': 'https://images.unsplash.com/photo-1560250097-0b93528c311a?auto=format&fit=crop&q=80&w=400',
      'isFavorite': true,
    },
    {
      'title': 'Pipeline Inspection Masterclass',
      'price': '\$199',
      'image': 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?auto=format&fit=crop&q=80&w=400',
      'isFavorite': false,
    },
    {
      'title': 'Marine Logistics',
      'price': '\$89',
      'image': 'https://images.unsplash.com/photo-1541888946425-d81bb19240f5?auto=format&fit=crop&q=80&w=400',
      'isFavorite': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Auto slide timer
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_currentBannerIndex < _banners.length - 1) {
        _currentBannerIndex++;
      } else {
        _currentBannerIndex = 0;
      }
      if (_bannerController.hasClients) {
        _bannerController.animateToPage(
          _currentBannerIndex,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  void _navigateToCourse(BuildContext context, String title, String imageUrl) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => 
            CourseDetailsScreen(title: title, imageUrl: imageUrl),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  void _onTabTapped(BuildContext context, Widget screen) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: const CustomDrawer(activeItem: DrawerItem.home),
      
      // AppBar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: Builder(
          builder: (context) => GestureDetector(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=80&w=200',
                ),
              ),
            ),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.water_drop, color: Color(0xFF0F9F90)),
            const SizedBox(width: 8),
            const Text(
              'Zenvora',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
                fontSize: 20,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Color(0xFF0F172A)),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No new notifications.')),
                  );
                },
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner Slider
            SizedBox(
              height: 180,
              child: PageView.builder(
                controller: _bannerController,
                onPageChanged: (int index) {
                  setState(() {
                    _currentBannerIndex = index;
                  });
                },
                itemCount: _banners.length,
                itemBuilder: (context, index) {
                  final banner = _banners[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GestureDetector(
                      onTap: () => _navigateToCourse(context, banner['title']!, banner['image']!),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: NetworkImage(banner['image']!),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.5),
                              BlendMode.srcOver,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF05B29B),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'NEW COURSE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                banner['title']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            // Carousel Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _banners.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: _currentBannerIndex == index
                        ? const Color(0xFF0F9F90)
                        : const Color(0xFFE2E8F0),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Course Categories Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Course Categories',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.9,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => 
                                  CategoryCoursesScreen(categoryName: cat['name']),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                return FadeTransition(opacity: animation, child: child);
                              },
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0F9F90).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  cat['icon'] as IconData,
                                  color: const Color(0xFF0F9F90),
                                  size: 28,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  cat['name']!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Rig-Associated Courses
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Rig-Associated Courses',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward, color: Color(0xFF475569), size: 20),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 240,
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 16.0),
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                itemCount: _rigCourses.length,
                itemBuilder: (context, index) {
                  final course = _rigCourses[index];
                  return ReusableCourseCard(
                    title: course['title'],
                    imageUrl: course['image'],
                    progress: course['progress'],
                    onTap: () => _navigateToCourse(context, course['title'], course['image']),
                  );
                },
              ),
            ),
            const SizedBox(height: 28),

            // Featured Courses
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Featured Courses',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward, color: Color(0xFF475569), size: 20),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 240,
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 16.0),
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                itemCount: _featuredCourses.length,
                itemBuilder: (context, index) {
                  final course = _featuredCourses[index];
                  return ReusableCourseCard(
                    title: course['title'],
                    imageUrl: course['image'],
                    price: course['price'],
                    isFavorite: course['isFavorite'],
                    onFavoriteTap: () {
                      setState(() {
                        course['isFavorite'] = !course['isFavorite'];
                      });
                    },
                    onTap: () => _navigateToCourse(context, course['title'], course['image']),
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),

      // Floating Action Button
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Quick Action triggered! Add notes or access compliance resources.'),
              backgroundColor: Color(0xFF0F9F90),
            ),
          );
        },
        backgroundColor: const Color(0xFF0F9F90),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        elevation: 10.0,
        child: Container(
          height: 60.0,
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home,
                label: 'Home',
                isSelected: true,
                onTap: () {},
              ),
              _buildNavItem(
                icon: Icons.school_outlined,
                label: 'Courses',
                isSelected: false,
                onTap: () => _onTabTapped(context, const MyCoursesScreen()),
              ),
              const SizedBox(width: 48), // Space for FAB
              _buildNavItem(
                icon: Icons.chat_bubble_outline,
                label: 'Community',
                isSelected: false,
                onTap: () => _onTabTapped(context, const CommunityScreen()),
              ),
              _buildNavItem(
                icon: Icons.person_outline,
                label: 'Profile',
                isSelected: false,
                onTap: () => _onTabTapped(context, const ProfileScreen()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF0F9F90) : const Color(0xFF94A3B8),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? const Color(0xFF0F9F90) : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
