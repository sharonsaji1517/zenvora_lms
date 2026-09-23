import 'package:flutter/material.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../models/course_model.dart';

class HorizontalCourseCard extends StatelessWidget {
  final CourseModel course;
  final VoidCallback onFavoriteTap;
  final VoidCallback? onTap;
  final String? actionButtonText;

  const HorizontalCourseCard({
    super.key,
    required this.course,
    required this.onFavoriteTap,
    this.onTap,
    this.actionButtonText = 'Go to Classroom',
  });

  Widget _buildCourseImage(String? imagePath) {
    if (imagePath != null && imagePath.trim().isNotEmpty) {
      final trimmed = imagePath.trim();
      final fullUrl = (trimmed.startsWith('http://') || trimmed.startsWith('https://'))
          ? trimmed
          : (trimmed.startsWith('/')
              ? 'https://zen.trynet.work$trimmed'
              : 'https://zen.trynet.work/$trimmed');
      return Image.network(
        fullUrl,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/images/carousel/NZu2b.jpg',
            width: double.infinity,
            fit: BoxFit.cover,
          );
        },
      );
    }
    return Image.asset(
      'assets/images/carousel/NZu2b.jpg',
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  void _handleTap(BuildContext context) {
    if (onTap != null) {
      onTap!();
      return;
    }
    Navigator.pushNamed(
      context,
      AppRoutes.classroom,
      arguments: course.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => _handleTap(context),
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Large Course Image (Top of Card)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildCourseImage(course.image),
                      // Top gradient for badge / heart readability
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.25),
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.15),
                              ],
                              stops: const [0.0, 0.4, 1.0],
                            ),
                          ),
                        ),
                      ),
                      // Category Badge on Top-Left
                      if (course.category.trim().isNotEmpty)
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            constraints: const BoxConstraints(maxWidth: 220),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(alpha: 0.92),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.12),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              course.category,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ),
                      // Wishlist / Favorite Button on Top-Right
                      Positioned(
                        top: 12,
                        right: 12,
                        child: GestureDetector(
                          onTap: onFavoriteTap,
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.92),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
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
                                  : AppTheme.textDark,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Course Details (Below Image)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Course Title
                    Text(
                      course.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                        height: 1.3,
                      ),
                    ),

                    // Short Description (if available)
                    if (course.shortDescription.trim().isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        course.shortDescription.trim(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: AppTheme.textMedium,
                          height: 1.35,
                        ),
                      ),
                    ],

                    const SizedBox(height: 12),

                    // Course Meta Info Row (Duration, Course Type, Fee)
                    Row(
                      children: [
                        // Duration Tag
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4.5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.access_time_rounded,
                                color: AppTheme.textMedium,
                                size: 13,
                              ),
                              const SizedBox(width: 4.5),
                              Text(
                                '${course.durationDays} Days',
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textDark,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Course Type Tag (if available)
                        if (course.courseType.trim().isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 4.5,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Text(
                              course.courseType.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],

                        const Spacer(),

                        // Fee
                        if (course.fee.trim().isNotEmpty && course.fee.trim() != '0')
                          Text(
                            '₹${course.fee}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.brandGoldenYellow,
                            ),
                          ),
                      ],
                    ),

                    // Progress Bar (if course has progress)
                    if (course.progress > 0) ...[
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Progress',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppTheme.textMedium,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${(course.progress * 100).toInt()}%',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.brandEmeraldGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: course.progress.clamp(0.0, 1.0),
                          minHeight: 5,
                          backgroundColor: const Color(0xFFF1F5F9),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppTheme.brandEmeraldGreen,
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 16),

                    // 3. "Go to Classroom" Button (Below Details)
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppTheme.brandBlueGreenGradientOf(context),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withValues(alpha: 0.22),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            onTap: () => _handleTap(context),
                            borderRadius: BorderRadius.circular(12),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.school_rounded,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    actionButtonText ?? 'Go to Classroom',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
