import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../view_models/home_view_model.dart';

class CourseCategoryGrid extends StatelessWidget {
  final HomeViewModel viewModel;

  const CourseCategoryGrid({
    super.key,
    required this.viewModel,
  });

  Color _getCategoryColor(String id) {
    switch (id) {
      case 'rig':
        return AppTheme.brandDeepBlue;
      case 'safety':
        return AppTheme.brandEmeraldGreen;
      case 'technical':
        return AppTheme.brandOceanBlue;
      case 'hse':
        return AppTheme.brandEmeraldGreen;
      case 'exploration':
        return AppTheme.brandGoldenYellow;
      case 'management':
        return AppTheme.brandOceanBlue;
      default:
        return AppTheme.brandDeepBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.05,
      ),
      itemCount: viewModel.categories.length,
      itemBuilder: (context, index) {
        final category = viewModel.categories[index];
        final isSelected = viewModel.selectedCategoryId == category.id;
        final categoryColor = _getCategoryColor(category.id);

        return GestureDetector(
          onTap: () => viewModel.selectCategory(category.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.brandDeepBlue : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? Colors.transparent : categoryColor.withOpacity(0.25),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? AppTheme.brandDeepBlue.withOpacity(0.25)
                      : Colors.black.withOpacity(0.04),
                  blurRadius: isSelected ? 8 : 6,
                  offset: isSelected ? const Offset(0, 3) : const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Circular icon frame
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? Colors.white.withOpacity(0.2) 
                        : categoryColor.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    category.icon,
                    color: isSelected ? Colors.white : categoryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  category.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    color: isSelected ? Colors.white : AppTheme.textDark,
                    height: 1.2,
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
