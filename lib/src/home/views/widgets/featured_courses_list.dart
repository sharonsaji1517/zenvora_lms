import 'package:flutter/material.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../models/course_model.dart';
import '../../view_models/home_view_model.dart';
import '../../../courses/views/course_detail_screen.dart';

class FeaturedCoursesList extends StatelessWidget {
  final HomeViewModel viewModel;
  final List<CourseModel> courses;

  const FeaturedCoursesList({
    super.key,
    required this.viewModel,
    required this.courses,
  });

  Widget _buildCourseImage(String? imagePath, int index) {
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
    return Image.asset(
      'assets/images/carousel/NZu2b.jpg',
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            'No courses available.',
            style: TextStyle(color: AppTheme.textLight),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CourseDetailScreen(courseId: course.id),
                settings: RouteSettings(
                  name: AppRoutes.courseDetail,
                  arguments: course.id,
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.borderLight, width: 0.8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Course image and favorite button overlay
                Expanded(
                  flex: 4,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        child: _buildCourseImage(course.image, index),
                      ),

                      // Category Tag Badge
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.brandDeepBlue.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            course.category,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // Favorite button
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => viewModel.toggleFavorite(course.id),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 1),
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
                ),

                // Content section
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Title
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

                        // Duration days
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time_rounded,
                              color: AppTheme.textLight,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${course.durationDays} Days',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.textDark,
                              ),
                            ),
                          ],
                        ),

                        // Fee tag & Action Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '₹${course.fee}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.brandGoldenYellow,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                gradient: AppTheme.brandBlueGreenGradient,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Enroll',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
