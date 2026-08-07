import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../models/course_model.dart';

class OverviewTabView extends StatefulWidget {
  final CourseModel course;

  const OverviewTabView({
    super.key,
    required this.course,
  });

  @override
  State<OverviewTabView> createState() => _OverviewTabViewState();
}

class _OverviewTabViewState extends State<OverviewTabView> {
  bool _isDescriptionExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxLines = _isDescriptionExpanded ? null : 3;
    final course = widget.course;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title: Overview
          Text(
            'Overview',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 8),

          // Course Description Text
          Text(
            course.shortDescription.isNotEmpty
                ? course.shortDescription
                : 'No course description available.',
            maxLines: maxLines,
            overflow:
                _isDescriptionExpanded ? TextOverflow.clip : TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textMedium,
              height: 1.5,
            ),
          ),

          // Read More/Less Button
          GestureDetector(
            onTap: () {
              setState(() {
                _isDescriptionExpanded = !_isDescriptionExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                _isDescriptionExpanded ? 'Read Less' : 'Read More',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),

          // Detailed Description (API long_description)
          if (course.longDescription != null &&
              course.longDescription!.trim().isNotEmpty) ...[
            const SizedBox(height: 20),
            const Divider(color: AppTheme.borderLight, height: 1),
            const SizedBox(height: 20),
            Text(
              'Detailed Description',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              course.longDescription!,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textMedium,
                height: 1.5,
              ),
            ),
          ],

          // About Course (API about_course)
          if (course.aboutCourse != null &&
              course.aboutCourse!.trim().isNotEmpty) ...[
            const SizedBox(height: 20),
            const Divider(color: AppTheme.borderLight, height: 1),
            const SizedBox(height: 20),
            Text(
              'About Course',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              course.aboutCourse!,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textMedium,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
