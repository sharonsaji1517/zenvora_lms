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
      case '1':
      case 'rig':
        return AppTheme.brandDeepBlue;
      case '2':
      case 'safety':
        return AppTheme.brandEmeraldGreen;
      case '3':
      case 'technical':
        return AppTheme.brandOceanBlue;
      case '4':
      case 'hse':
        return AppTheme.brandEmeraldGreen;
      case '5':
      case 'exploration':
        return AppTheme.brandGoldenYellow;
      case '6':
      case 'management':
        return AppTheme.brandOceanBlue;
      default:
        return AppTheme.brandDeepBlue;
    }
  }

  IconData _getIconData(String? iconStr, String categoryName) {
    final name = categoryName.toLowerCase();
    final icon = (iconStr ?? '').toLowerCase();
    if (icon.contains('factory') || name.contains('wsn') || name.contains('factory')) {
      return Icons.factory_outlined;
    }
    if (icon.contains('construction') || name.contains('safety')) {
      return Icons.construction_outlined;
    }
    if (icon.contains('settings') || icon.contains('gear') || name.contains('tech')) {
      return Icons.settings_suggest_outlined;
    }
    if (icon.contains('hospital') || name.contains('first aid') || name.contains('hse')) {
      return Icons.local_hospital_outlined;
    }
    if (icon.contains('map') || name.contains('exploration')) {
      return Icons.map_outlined;
    }
    if (icon.contains('people') || name.contains('management')) {
      return Icons.people_outline;
    }
    return Icons.category_outlined;
  }

  @override
  Widget build(BuildContext context) {
    if (viewModel.categories.isEmpty) {
      return const SizedBox.shrink();
    }

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
        final categoryIdStr = category.id.toString();
        final isSelected = viewModel.selectedCategoryId == categoryIdStr;
        final categoryColor = _getCategoryColor(categoryIdStr);
        final iconData = _getIconData(category.icon, category.name);

        return GestureDetector(
          onTap: () => viewModel.selectCategory(categoryIdStr),
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
                    iconData,
                    color: isSelected ? Colors.white : categoryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    category.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                      color: isSelected ? Colors.white : AppTheme.textDark,
                      height: 1.2,
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
