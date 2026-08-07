import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/course_model.dart';

class ResourcesTabView extends StatelessWidget {
  final Course course;

  const ResourcesTabView({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    if (course.resources.isEmpty) {
      return const Center(
        child: Text(
          'No additional resources available for this course.',
          style: TextStyle(color: AppTheme.textLight),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: course.resources.length,
      itemBuilder: (context, index) {
        final resourceName = course.resources[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppTheme.borderLight, width: 0.8),
          ),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.picture_as_pdf_outlined,
                color: Colors.redAccent,
                size: 24,
              ),
            ),
            title: Text(
              resourceName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textDark,
              ),
            ),
            subtitle: const Text(
              'PDF Document',
              style: TextStyle(fontSize: 11, color: AppTheme.textLight),
            ),
            trailing: IconButton(
              icon: Icon(Icons.download_for_offline_outlined, color: Theme.of(context).colorScheme.primary),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Downloading "$resourceName"...'),
                    backgroundColor: AppTheme.accentGreen,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
