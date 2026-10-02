import 'package:flutter/material.dart';
import '../core/routes/app_routes.dart';
import '../core/services/api_service.dart';
import '../core/theme/app_theme.dart';
import '../models/course_model.dart';
import '../src/courses/views/course_detail_screen.dart';
import '../src/home/views/widgets/left_navigation_drawer.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final ApiService _apiService = ApiService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<CourseModel> _courses = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final courses = await _apiService.getCourses();
      if (mounted) {
        setState(() {
          _courses = courses;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load courses. Please try again.';
          _isLoading = false;
        });
      }
    }
  }

  void _openCourseDetail(CourseModel course) {
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
  }

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
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/images/carousel/NZu2b.jpg',
            fit: BoxFit.cover,
          );
        },
      );
    }
    return Image.asset(
      'assets/images/carousel/NZu2b.jpg',
      fit: BoxFit.cover,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.school_outlined,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'No Courses Available',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'There are no courses to display right now. Please check back later!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.textMedium,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard(CourseModel course) {
    final double currentPrice = double.tryParse(course.fee) ?? 0.0;
    final String? oldPriceStr = currentPrice > 0
        ? '₹${(currentPrice * 1.3).toStringAsFixed(0)}'
        : null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.borderLight,
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => _openCourseDetail(course),
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course Thumbnail & Badges Overlay
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: SizedBox(
                      height: 110,
                      width: double.infinity,
                      child: _buildCourseImage(course.image),
                    ),
                  ),

                  // Category Badge at Top-Left
                  if (course.category.trim().isNotEmpty)
                    Positioned(
                      top: 7,
                      left: 7,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3.5,
                        ),
                        constraints: const BoxConstraints(maxWidth: 100),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
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
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // Card Details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Course Title
                      Text(
                        course.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.brandDeepBlue,
                          height: 1.25,
                        ),
                      ),

                      // Duration
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            color: AppTheme.textLight,
                            size: 11,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${course.durationDays}d',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.textMedium,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Price & Old Price
                      Row(
                        children: [
                          Text(
                            '₹${course.fee}',
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.brandEmeraldGreen,
                            ),
                          ),
                          if (oldPriceStr != null) ...[
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                oldPriceStr,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.textLight,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.brandBackgroundGradientOf(context),
      ),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        drawer: const LeftNavigationDrawer(activeRoute: AppRoutes.courses),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          titleSpacing: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: AppTheme.brandThreeColorGradientOf(context),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Courses',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        body: Builder(
          builder: (context) {
            if (_isLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              );
            }

            if (_errorMessage != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: Colors.redAccent,
                        size: 40,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppTheme.textDark,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchCourses,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (_courses.isEmpty) {
              return RefreshIndicator(
                onRefresh: _fetchCourses,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: _buildEmptyState(),
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _fetchCourses,
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.73,
                ),
                itemCount: _courses.length,
                itemBuilder: (context, index) {
                  return _buildCourseCard(_courses[index]);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
