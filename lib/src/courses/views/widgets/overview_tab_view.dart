import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/course_model.dart';

class OverviewTabView extends StatefulWidget {
  final Course course;

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
            widget.course.description,
            maxLines: maxLines,
            overflow: _isDescriptionExpanded ? TextOverflow.clip : TextOverflow.ellipsis,
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
                style: const TextStyle(
                  color: AppTheme.primaryBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          const Divider(color: AppTheme.borderLight, height: 1),
          const SizedBox(height: 20),

          // Key Learnings Title
          Text(
            'What you will learn',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 12),

          // Learnings List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.course.learnings.length,
            itemBuilder: (context, index) {
              final learning = widget.course.learnings[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Icon(
                        Icons.check_circle_outline,
                        color: AppTheme.accentGreen,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        learning,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textDark,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
