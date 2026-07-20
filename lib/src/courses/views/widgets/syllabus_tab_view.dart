import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/course_model.dart';
import '../../view_models/course_detail_view_model.dart';

class SyllabusTabView extends StatelessWidget {
  final CourseDetailViewModel viewModel;

  const SyllabusTabView({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final course = viewModel.course;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: course.modules.length,
      itemBuilder: (context, index) {
        final module = course.modules[index];
        final isExpanded = viewModel.isModuleExpanded(module.id);

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
                  module.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                trailing: Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: AppTheme.textMedium,
                ),
                onTap: () => viewModel.toggleModuleExpanded(module.id),
              ),

              // Accordion Body
              if (isExpanded) ...[
                const Divider(color: AppTheme.borderLight, height: 1),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: module.items.length,
                  itemBuilder: (context, itemIdx) {
                    final item = module.items[itemIdx];
                    final itemIcon = _getItemIcon(item.type);
                    
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          itemIcon,
                          color: AppTheme.primaryBlue,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textDark,
                        ),
                      ),
                      subtitle: Text(
                        item.durationOrSize,
                        style: const TextStyle(fontSize: 12, color: AppTheme.textLight),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: AppTheme.textLight,
                        size: 20,
                      ),
                      onTap: () {
                        _handleItemTap(context, item);
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

  void _handleItemTap(BuildContext context, SyllabusItem item) {
    String action = 'Opening';
    if (item.type == 'pdf') action = 'Downloading';
    if (item.type == 'quiz') action = 'Starting';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action "${item.title}"...'),
        backgroundColor: AppTheme.accentGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
