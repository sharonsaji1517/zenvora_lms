import 'package:flutter/material.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../courses/models/course_model.dart';
import '../../view_models/home_view_model.dart';

class FeaturedCoursesList extends StatelessWidget {
  final HomeViewModel viewModel;
  final List<Course> courses;

  const FeaturedCoursesList({
    super.key,
    required this.viewModel,
    required this.courses,
  });

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            'No featured courses available for selected category.',
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
            Navigator.pushNamed(
              context,
              AppRoutes.courseDetail,
              arguments: course,
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
                        child: Image.asset(
                          const [
                            'assets/images/carousel/NZu2b.jpg',
                            'assets/images/carousel/T2kGe.jpg',
                            'assets/images/carousel/FlvdF.jpg',
                          ][index % 3],
                          fit: BoxFit.cover,
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
                              course.isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: course.isFavorite ? Colors.redAccent : AppTheme.textLight,
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
                          course.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.brandDeepBlue,
                            height: 1.25,
                          ),
                        ),
                        
                        // Rating & Reviews
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: AppTheme.brandGoldenYellow,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              course.rating.toString(),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textDark,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(${course.reviewCount})',
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppTheme.textLight,
                              ),
                            ),
                          ],
                        ),
                        
                        // Progress bar (if enrolled/has progress)
                        if (course.progress > 0)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Progress',
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: AppTheme.textLight.withOpacity(0.9),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '${(course.progress * 100).toInt()}%',
                                    style: const TextStyle(
                                      fontSize: 9,
                                      color: AppTheme.brandEmeraldGreen,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: LinearProgressIndicator(
                                  value: course.progress,
                                  minHeight: 3,
                                  backgroundColor: AppTheme.borderLight,
                                  valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.brandEmeraldGreen),
                                ),
                              ),
                            ],
                          ),
                        
                        // Price tag & Action Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${course.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.brandGoldenYellow,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                gradient: AppTheme.brandBlueGreenGradient,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                course.progress > 0 ? 'Resume' : 'Enroll',
                                style: const TextStyle(
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
