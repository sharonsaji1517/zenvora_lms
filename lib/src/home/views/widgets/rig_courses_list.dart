import 'package:flutter/material.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../models/course_model.dart';
import '../../../courses/views/course_detail_screen.dart';

class RigCoursesList extends StatelessWidget {
  final List<CourseModel> courses;

  const RigCoursesList({
    super.key,
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

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
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
              width: 170,
              margin: const EdgeInsets.only(right: 16),
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
                  // Image
                  Expanded(
                    flex: 11,
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
                        Positioned(
                          top: 6,
                          left: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.85),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              course.category,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Text and info
                  Expanded(
                    flex: 9,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            course.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                              height: 1.2,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${course.durationDays} Days',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppTheme.textLight,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '₹${course.fee}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.brandEmeraldGreen,
                                  fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
