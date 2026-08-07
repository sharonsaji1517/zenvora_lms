import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../src/courses/views/course_detail_screen.dart';
import '../core/routes/app_routes.dart';

class CategoryCoursesScreen extends StatefulWidget {
  final dynamic categoryId;
  final String categoryName;

  const CategoryCoursesScreen({
    super.key,
    this.categoryId,
    required this.categoryName,
  });

  @override
  State<CategoryCoursesScreen> createState() => _CategoryCoursesScreenState();
}

class _CategoryCoursesScreenState extends State<CategoryCoursesScreen> {
  bool isLoading = false;
  String? errorMessage;

  // Placeholder dummy course list prepared for future API binding
  final List<Map<String, dynamic>> _dummyCourses = const [
    {
      'id': 1,
      'name': 'Advanced Safety & Risk Assessment',
      'duration': '4 Weeks',
      'courseType': 'Certification',
      'rating': 4.8,
      'price': '₹999',
      'oldPrice': '₹1,499',
      'image': 'assets/images/carousel/logistics3.jpg',
      'description': 'Master essential offshore and onshore safety protocols, hazard identification, and risk management.',
    },
    {
      'id': 2,
      'name': 'Offshore Well Operations & Drills',
      'duration': '6 Weeks',
      'courseType': 'Professional',
      'rating': 4.9,
      'price': '₹1,299',
      'oldPrice': '₹1,899',
      'image': 'assets/images/carousel/logistics1.jpg',
      'description': 'Comprehensive hands-on simulation covering well control, emergency shutdown, and rig safety routines.',
    },
    {
      'id': 3,
      'name': 'Blowout Preventer Systems & Hydraulics',
      'duration': '3 Weeks',
      'courseType': 'Technical',
      'rating': 4.7,
      'price': '₹1,199',
      'oldPrice': '₹1,599',
      'image': 'assets/images/carousel/logistics2.jpg',
      'description': 'In-depth analysis of hydraulic control systems, BOP stack operations, and maintenance procedures.',
    },
    {
      'id': 4,
      'name': 'Environmental Compliance & HSE Guidelines',
      'duration': '5 Weeks',
      'courseType': 'Compliance',
      'rating': 4.8,
      'price': '₹899',
      'oldPrice': '₹1,299',
      'image': 'assets/images/carousel/NZu2b.jpg',
      'description': 'Understand global environmental safety standards, zero-spill policies, and audit readiness.',
    },
    {
      'id': 5,
      'name': 'Rig Structural Dynamics & Maintenance',
      'duration': '8 Weeks',
      'courseType': 'Advanced',
      'rating': 4.9,
      'price': '₹1,499',
      'oldPrice': '₹2,099',
      'image': 'assets/images/carousel/logistics1.jpg',
      'description': 'Learn load distribution, structural integrity testing, and predictive maintenance for drilling rigs.',
    },
    {
      'id': 6,
      'name': 'Emergency Response & Crisis Management',
      'duration': '2 Weeks',
      'courseType': 'Essential',
      'rating': 4.8,
      'price': '₹799',
      'oldPrice': '₹1,099',
      'image': 'assets/images/carousel/logistics3.jpg',
      'description': 'Fast-paced module covering evacuation strategies, command hierarchy, and crisis communication.',
    },
  ];

  @override
  void initState() {
    super.initState();
    fetchCategoryCourses(widget.categoryId);
  }

  /// Prepared method for future API integration.
  /// Update this method when backend endpoint is ready to populate category courses dynamically.
  Future<void> fetchCategoryCourses(dynamic categoryId) async {
    // Currently using dummy data for UI display
    setState(() {
      isLoading = false;
      errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.brandBackgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: AppTheme.brandThreeColorGradient,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            widget.categoryName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Search in category coming soon'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      Text(
                        widget.categoryName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_dummyCourses.length} Courses Available',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textLight,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Search Section
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppTheme.borderLight),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          readOnly: true,
                          onTap: () {},
                          decoration: const InputDecoration(
                            hintText: 'Search Courses',
                            hintStyle: TextStyle(color: AppTheme.textLight, fontSize: 14),
                            prefixIcon: Icon(Icons.search, color: AppTheme.textLight, size: 20),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Filter Row
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.filter_list_rounded, size: 18, color: AppTheme.primaryBlue),
                              label: const Text('Filter', style: TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.w600)),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppTheme.borderLight),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.swap_vert_rounded, size: 18, color: AppTheme.primaryBlue),
                              label: const Text('Sort By', style: TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.w600)),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppTheme.borderLight),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Main Content Area (Loading / Error / Empty / Course List)
                      if (isLoading)
                        _buildLoadingState()
                      else if (errorMessage != null)
                        _buildErrorState()
                      else if (_dummyCourses.isEmpty)
                        _buildEmptyState()
                      else
                        _buildCourseList(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Vertically scrolling list of courses
  Widget _buildCourseList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _dummyCourses.length,
      itemBuilder: (context, index) {
        final course = _dummyCourses[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppTheme.borderLight, width: 0.8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course Image Header
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                child: SizedBox(
                  height: 130,
                  width: double.infinity,
                  child: Image.asset(
                    course['image'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.school_outlined, size: 40, color: Colors.grey),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Course Details
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Course Title & Rating Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            course['name'],
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.brandDeepBlue,
                              height: 1.25,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.brandGoldenYellow.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star_rounded, color: AppTheme.brandGoldenYellow, size: 14),
                              const SizedBox(width: 2),
                              Text(
                                '${course['rating']}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Duration & Badge Row
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded, size: 14, color: AppTheme.textLight),
                        const SizedBox(width: 4),
                        Text(
                          course['duration'],
                          style: const TextStyle(fontSize: 12, color: AppTheme.textMedium, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.brandOceanBlue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            course['courseType'],
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.brandOceanBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Description (2 lines max)
                    Text(
                      course['description'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textLight,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Price & View Details Button Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              course['price'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.brandEmeraldGreen,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              course['oldPrice'],
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.textLight,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),

                        // View Details Button
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CourseDetailScreen(courseId: course['id']),
                                settings: RouteSettings(
                                  name: AppRoutes.courseDetail,
                                  arguments: course['id'],
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: AppTheme.brandBlueGreenGradient,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              child: const Text(
                                'View Details',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Empty state widget UI ready
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.school_outlined, size: 54, color: AppTheme.primaryBlue),
            ),
            const SizedBox(height: 16),
            const Text(
              'No Courses Available',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textDark),
            ),
            const SizedBox(height: 6),
            const Text(
              'Courses for this category will appear here.',
              style: TextStyle(fontSize: 13, color: AppTheme.textLight),
            ),
          ],
        ),
      ),
    );
  }

  /// Skeleton / shimmer loading widget UI ready
  Widget _buildLoadingState() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          height: 220,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
        );
      },
    );
  }

  /// Reusable error widget UI ready
  Widget _buildErrorState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.error_outline_rounded, size: 54, color: Colors.redAccent),
            const SizedBox(height: 16),
            const Text(
              'Unable to load courses.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textDark),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => fetchCategoryCourses(widget.categoryId),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
