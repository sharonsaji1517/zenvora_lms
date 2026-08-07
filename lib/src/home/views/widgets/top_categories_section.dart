import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../view_models/home_view_model.dart';
import '../../../../models/category_model.dart';
import '../../../../screens/category_courses_screen.dart';

class TopCategoriesSection extends StatelessWidget {
  final HomeViewModel viewModel;

  const TopCategoriesSection({super.key, required this.viewModel});

  Color _getCategoryColor(BuildContext context, String id) {
    switch (id) {
      case '1':
      case 'rig':
        return Theme.of(context).colorScheme.primary;
      case '2':
      case 'safety':
        return AppTheme.brandEmeraldGreen;
      case '3':
      case 'technical':
        return Theme.of(context).colorScheme.secondary;
      case '4':
      case 'hse':
        return AppTheme.brandEmeraldGreen;
      case '5':
      case 'exploration':
        return AppTheme.brandGoldenYellow;
      case '6':
      case 'management':
        return Theme.of(context).colorScheme.secondary;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  IconData _getIconData(String? iconStr, String categoryName) {
    final name = categoryName.toLowerCase();
    final icon = (iconStr ?? '').toLowerCase();
    if (icon.contains('factory') ||
        name.contains('wsn') ||
        name.contains('factory')) {
      return Icons.factory_outlined;
    }
    if (icon.contains('construction') || name.contains('safety')) {
      return Icons.construction_outlined;
    }
    if (icon.contains('settings') ||
        icon.contains('gear') ||
        name.contains('tech')) {
      return Icons.settings_suggest_outlined;
    }
    if (icon.contains('hospital') ||
        name.contains('first aid') ||
        name.contains('hse')) {
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
    final List<CategoryModel> categories = viewModel.categories;

    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600;
    final double cardWidth = isTablet ? 130.0 : 115.0;
    final double cardHeight = isTablet ? 130.0 : 120.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Top Categories',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                  letterSpacing: -0.3,
                ),
              ),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('All categories list coming soon'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: const Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.brandOceanBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Horizontal Category Cards ListView
        SizedBox(
          height: cardHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            physics: const BouncingScrollPhysics(),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final categoryIdStr = category.id.toString();
              final isSelected = viewModel.selectedCategoryId == categoryIdStr;
              final Color categoryColor = _getCategoryColor(context, categoryIdStr);
              final IconData iconData = _getIconData(
                category.icon,
                category.name,
              );

              return Container(
                width: cardWidth,
                margin: const EdgeInsets.only(right: 12.0),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryCoursesScreen(
                            categoryId: category.id,
                            categoryName: category.name,
                            categorySlug: category.slug,
                          ),
                        ),
                      ).then((_) {
                        if (viewModel.selectedCategoryId.isNotEmpty) {
                          viewModel.selectCategory('');
                        }
                      });
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : AppTheme.borderLight.withOpacity(0.8),
                          width: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary.withOpacity(0.25)
                                : Colors.black.withOpacity(0.04),
                            blurRadius: isSelected ? 10 : 8,
                            offset: isSelected
                                ? const Offset(0, 4)
                                : const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Circular Icon Container with Zenvora theme background
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white.withOpacity(0.2)
                                  : categoryColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              iconData,
                              color: isSelected ? Colors.white : categoryColor,
                              size: 22,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Category Name
                          Text(
                            category.name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : AppTheme.textDark,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
