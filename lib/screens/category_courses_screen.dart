import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/course_model.dart';
import '../core/services/api_service.dart';
import '../src/courses/views/course_detail_screen.dart';
import '../core/routes/app_routes.dart';

class CategoryCoursesScreen extends StatefulWidget {
  final dynamic categoryId;
  final String categoryName;
  final String? categorySlug;

  const CategoryCoursesScreen({
    super.key,
    this.categoryId,
    required this.categoryName,
    this.categorySlug,
  });

  @override
  State<CategoryCoursesScreen> createState() => _CategoryCoursesScreenState();
}

class _CategoryCoursesScreenState extends State<CategoryCoursesScreen> {
  bool isLoading = true;
  String? errorMessage;
  List<CourseModel> courses = [];

  @override
  void initState() {
    super.initState();
    loadCategoryCourses();
  }

  Future<void> loadCategoryCourses() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final slug = (widget.categorySlug != null && widget.categorySlug!.trim().isNotEmpty)
          ? widget.categorySlug!.trim()
          : widget.categoryId?.toString() ?? '';

      final result = await ApiService().fetchCategoryCourses(slug);

      if (mounted) {
        setState(() {
          courses = result;
          isLoading = false;
          errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          courses = [];
          isLoading = false;
          errorMessage = 'Unable to load courses. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.brandBackgroundGradientOf(context),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: AppTheme.brandThreeColorGradientOf(context),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            widget.categoryName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Search in category coming soon'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      Text(
                        widget.categoryName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${courses.length} Courses Available',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textLight,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Search Section
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppTheme.borderLight),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          readOnly: true,
                          onTap: () {},
                          decoration: const InputDecoration(
                            hintText: 'Search Courses',
                            hintStyle: TextStyle(color: AppTheme.textLight, fontSize: 14),
                            prefixIcon: Icon(Icons.search, color: AppTheme.textLight, size: 20),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Filter Row
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.filter_list_rounded, size: 18, color: AppTheme.primaryBlue),
                              label: const Text('Filter', style: TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.w600)),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppTheme.borderLight),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.swap_vert_rounded, size: 18, color: AppTheme.primaryBlue),
                              label: const Text('Sort By', style: TextStyle(color: AppTheme.primaryBlue, fontWeight: FontWeight.w600)),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppTheme.borderLight),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Main Content Area (Loading / Error / Empty / Course List)
                      if (isLoading)
                        _buildLoadingState()
                      else if (errorMessage != null)
                        _buildErrorState()
                      else if (courses.isEmpty)
                        _buildEmptyState()
                      else
                        _buildCourseList(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Vertically scrolling list of courses
  Widget _buildCourseList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        final imageUrl = course.imageUrl;
        final isNetworkImage = imageUrl.startsWith('http://') || imageUrl.startsWith('https://') || imageUrl.startsWith('/');
        final fullImageUrl = imageUrl.startsWith('/') ? '${ApiService.baseUrl.replaceAll('/api', '')}$imageUrl' : imageUrl;

        return Container(
          margin: const EdgeInsets.only(bottom: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppTheme.borderLight, width: 0.8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course Image Header
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                child: SizedBox(
                  height: 130,
                  width: double.infinity,
                  child: isNetworkImage
                      ? Image.network(
                          fullImageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(Icons.school_outlined, size: 40, color: Colors.grey),
                              ),
                            );
                          },
                        )
                      : Image.asset(
                          imageUrl.isNotEmpty ? imageUrl : 'assets/images/carousel/NZu2b.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(Icons.school_outlined, size: 40, color: Colors.grey),
                              ),
                            );
                          },
                        ),
                ),
              ),

              // Course Details
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Course Title
                    Text(
                      course.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.brandDeepBlue,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Duration & Badge Row
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded, size: 14, color: AppTheme.textLight),
                        const SizedBox(width: 4),
                        Text(
                          course.durationDays > 0 ? '${course.durationDays} Days' : 'Self-Paced',
                          style: const TextStyle(fontSize: 12, color: AppTheme.textMedium, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            course.courseType.isNotEmpty ? course.courseType : 'Course',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Description (2 lines max)
                    Text(
                      course.shortDescription.isNotEmpty ? course.shortDescription : course.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textLight,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Price & View Details Button Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              '₹${course.fee}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.brandEmeraldGreen,
                              ),
                            ),
                          ],
                        ),

                        // View Details Button
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CourseDetailScreen(courseId: course.id),
                                settings: RouteSettings(
                                  name: AppRoutes.courseDetail,
                                  arguments: course.id,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: AppTheme.brandBlueGreenGradientOf(context),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              child: const Text(
                                'View Details',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Empty state widget UI ready
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.school_outlined, size: 54, color: AppTheme.primaryBlue),
            ),
            const SizedBox(height: 16),
            const Text(
              'No Courses Available',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textDark),
            ),
            const SizedBox(height: 6),
            const Text(
              'Courses for this category will appear here.',
              style: TextStyle(fontSize: 13, color: AppTheme.textLight),
            ),
          ],
        ),
      ),
    );
  }

  /// Skeleton / shimmer loading widget UI ready
  Widget _buildLoadingState() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          height: 220,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
        );
      },
    );
  }

  /// Reusable error widget UI ready
  Widget _buildErrorState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.error_outline_rounded, size: 54, color: Colors.redAccent),
            const SizedBox(height: 16),
            const Text(
              'Unable to load courses.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textDark),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => loadCategoryCourses(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
