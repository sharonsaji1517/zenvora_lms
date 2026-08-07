import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../models/course_model.dart';
import '../../models/course_model.dart' as legacy_model;
import '../../view_models/course_detail_view_model.dart';

class SyllabusTabView extends StatelessWidget {
  final CourseDetailViewModel viewModel;

  const SyllabusTabView({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final CourseModel? course = viewModel.course;
    if (course == null || course.modules.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'Syllabus for this course will be available soon.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textMedium),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: course.modules.length,
      itemBuilder: (context, index) {
        final dynamic module = course.modules[index];
        final String moduleId = module is legacy_model.SyllabusModule
            ? module.id
            : (module['id']?.toString() ?? index.toString());
        final String moduleTitle = module is legacy_model.SyllabusModule
            ? module.title
            : (module['title']?.toString() ?? 'Module ${index + 1}');
        final List moduleItems = module is legacy_model.SyllabusModule
            ? module.items
            : (module['items'] is List ? module['items'] : []);
        final isExpanded = viewModel.isModuleExpanded(moduleId);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppTheme.borderLight, width: 0.8),
          ),
          child: Column(
            children: [
              // Accordion Header
              ListTile(
                title: Text(
                  moduleTitle,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                trailing: Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppTheme.textMedium,
                ),
                onTap: () => viewModel.toggleModuleExpanded(moduleId),
              ),

              // Accordion Body
              if (isExpanded) ...[
                const Divider(color: AppTheme.borderLight, height: 1),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: moduleItems.length,
                  itemBuilder: (context, itemIdx) {
                    final dynamic item = moduleItems[itemIdx];
                    final String type = item is legacy_model.SyllabusItem
                        ? item.type
                        : (item['type']?.toString() ?? 'video');
                    final String title = item is legacy_model.SyllabusItem
                        ? item.title
                        : (item['title']?.toString() ?? '');
                    final String durationOrSize =
                        item is legacy_model.SyllabusItem
                            ? item.durationOrSize
                            : (item['durationOrSize']?.toString() ?? '');

                    final itemIcon = _getItemIcon(type);

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 2),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          itemIcon,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textDark,
                        ),
                      ),
                      subtitle: Text(
                        durationOrSize,
                        style: const TextStyle(
                            fontSize: 12, color: AppTheme.textLight),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: AppTheme.textLight,
                        size: 20,
                      ),
                      onTap: () {
                        _handleItemTap(context, title, type);
                      },
                    );
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  IconData _getItemIcon(String type) {
    switch (type) {
      case 'video':
        return Icons.play_circle_outline;
      case 'pdf':
        return Icons.insert_drive_file_outlined;
      case 'quiz':
        return Icons.quiz_outlined;
      default:
        return Icons.circle_outlined;
    }
  }

  void _handleItemTap(BuildContext context, String title, String type) {
    String action = 'Opening';
    if (type == 'pdf') action = 'Downloading';
    if (type == 'quiz') action = 'Starting';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action "$title"...'),
        backgroundColor: AppTheme.accentGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
