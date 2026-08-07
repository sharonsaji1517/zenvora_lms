import 'package:flutter/material.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../models/course_model.dart';
import '../../view_models/home_view_model.dart';
import '../../../courses/views/course_detail_screen.dart';

class PopularCoursesSection extends StatelessWidget {
  final HomeViewModel viewModel;

  const PopularCoursesSection({super.key, required this.viewModel});

  Widget _buildCourseImage(String? imagePath) {
    if (imagePath != null &&
        imagePath.trim().isNotEmpty &&
        (imagePath.startsWith('http://') || imagePath.startsWith('https://'))) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/images/carousel/NZu2b.jpg',
            fit: BoxFit.cover,
          );
        },
      );
    }
    return Image.asset('assets/images/carousel/NZu2b.jpg', fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    final List<CourseModel> courses = viewModel.courses;

    if (courses.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Center(
          child: Text(
            'No courses available for selected category.',
            style: TextStyle(color: AppTheme.textLight, fontSize: 13),
          ),
        ),
      );
    }

    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;
    final double cardWidth = isTablet ? 260.0 : 230.0;
    final double cardHeight = isTablet ? 295.0 : 280.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Popular Courses',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                  letterSpacing: -0.3,
                ),
              ),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('All courses list coming soon'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: const Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.brandOceanBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Horizontal Course Cards ListView
        SizedBox(
          height: cardHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            physics: const BouncingScrollPhysics(),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];

              // Calculate old price for visual strike-through presentation if numeric fee exists
              final double currentPrice = double.tryParse(course.fee) ?? 0.0;
              final String? oldPriceStr = currentPrice > 0
                  ? '₹${(currentPrice * 1.3).toStringAsFixed(0)}'
                  : null;

              return Container(
                width: cardWidth,
                margin: const EdgeInsets.only(right: 14.0),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CourseDetailScreen(courseId: course.id),
                          settings: RouteSettings(
                            name: AppRoutes.courseDetail,
                            arguments: course.id,
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.borderLight,
                          width: 0.8,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Course Thumbnail & Badges Overlay
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                                child: SizedBox(
                                  height: 125,
                                  width: double.infinity,
                                  child: _buildCourseImage(course.image),
                                ),
                              ),

                              // Small "Popular" Badge at Top-Left
                              Positioned(
                                top: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: AppTheme.brandBlueGreenGradient,
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.local_fire_department_rounded,
                                        color: Colors.white,
                                        size: 11,
                                      ),
                                      SizedBox(width: 3),
                                      Text(
                                        'Popular',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Wishlist Heart Icon Button at Top-Right
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: () =>
                                      viewModel.toggleFavorite(course.id),
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.15),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      course.isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: course.isFavorite
                                          ? Colors.redAccent
                                          : AppTheme.textLight,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Card Details Section
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Course Title
                                  Text(
                                    course.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.brandDeepBlue,
                                      height: 1.25,
                                    ),
                                  ),

                                  // Rating & Lesson Count Row
                                  Row(
                                    children: [
                                      // Rating
                                      const Icon(
                                        Icons.star_rounded,
                                        color: AppTheme.brandGoldenYellow,
                                        size: 15,
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        course.rating.toStringAsFixed(1),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.textDark,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      // Divider dot
                                      Container(
                                        width: 3,
                                        height: 3,
                                        decoration: const BoxDecoration(
                                          color: AppTheme.textLight,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      // Lesson Count / Duration
                                      const Icon(
                                        Icons.menu_book_outlined,
                                        color: AppTheme.textLight,
                                        size: 13,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${course.durationDays} Lessons',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: AppTheme.textMedium,
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Price & Old Price Row
                                  Row(
                                    children: [
                                      Text(
                                        '₹${course.fee}',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                          color: AppTheme.brandEmeraldGreen,
                                        ),
                                      ),
                                      if (oldPriceStr != null) ...[
                                        const SizedBox(width: 8),
                                        Text(
                                          oldPriceStr,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: AppTheme.textLight,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
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
      ],
    );
  }
}
