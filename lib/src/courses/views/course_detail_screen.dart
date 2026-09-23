import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../models/course_model.dart';
import '../view_models/course_detail_view_model.dart';
import 'widgets/overview_tab_view.dart';
import 'widgets/course_enrollment_modal.dart';
import '../../../../core/services/user_preferences_service.dart';

class CourseDetailScreen extends StatefulWidget {
  final int? courseId;

  const CourseDetailScreen({
    super.key,
    this.courseId,
  });

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  CourseDetailViewModel? _viewModel;
  String _fullName = 'Guest User';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefsService = UserPreferencesService();
    final name = await prefsService.getFullName();
    if (mounted) {
      setState(() {
        _fullName = name;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewModel == null) {
      int? extractedId = widget.courseId;
      CourseModel? initialCourse;

      if (extractedId == null) {
        final args = ModalRoute.of(context)?.settings.arguments;
        if (args is int) {
          extractedId = args;
        } else if (args is CourseModel) {
          extractedId = args.id;
          initialCourse = args;
        } else if (args != null) {
          extractedId = int.tryParse(args.toString());
        }
      }

      final int targetCourseId = extractedId ?? 1;

      _viewModel = CourseDetailViewModel(
        courseId: targetCourseId,
        initialCourse: initialCourse,
      );
      _viewModel!.fetchCourseDetail();
    }
  }

  @override
  void dispose() {
    _viewModel?.dispose();
    super.dispose();
  }

  Widget _buildFlexibleHeaderImage(String? imagePath) {
    if (imagePath != null &&
        imagePath.trim().isNotEmpty &&
        (imagePath.startsWith('http://') || imagePath.startsWith('https://'))) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        color: Colors.black.withOpacity(0.4),
        colorBlendMode: BlendMode.srcOver,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/images/carousel/NZu2b.jpg',
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.4),
            colorBlendMode: BlendMode.srcOver,
          );
        },
      );
    }
    return Image.asset(
      'assets/images/carousel/NZu2b.jpg',
      fit: BoxFit.cover,
      color: Colors.black.withOpacity(0.4),
      colorBlendMode: BlendMode.srcOver,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_viewModel == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppTheme.primaryBlue),
        ),
      );
    }

    return ListenableBuilder(
      listenable: _viewModel!,
      builder: (context, child) {
        if (_viewModel!.isLoading && _viewModel!.course == null) {
          return Scaffold(
            backgroundColor: AppTheme.backgroundLight,
            appBar: AppBar(
              backgroundColor: AppTheme.primaryBlue,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryBlue),
            ),
          );
        }

        if (_viewModel!.errorMessage != null && _viewModel!.course == null) {
          return Scaffold(
            backgroundColor: AppTheme.backgroundLight,
            appBar: AppBar(
              backgroundColor: AppTheme.primaryBlue,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.redAccent,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _viewModel!.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _viewModel!.fetchCourseDetail(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final course = _viewModel!.course!;
        final size = MediaQuery.of(context).size;

        return Scaffold(
          backgroundColor: AppTheme.backgroundLight,
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                // Collapsing Image Header Banner
                SliverAppBar(
                  expandedHeight: size.height * 0.28,
                  pinned: true,
                  backgroundColor: AppTheme.primaryBlue,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        course.isFavorite ? Icons.star : Icons.star_border,
                        color: course.isFavorite ? Colors.amber : Colors.white,
                      ),
                      onPressed: _viewModel!.toggleFavorite,
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: _buildFlexibleHeaderImage(course.image),
                  ),
                ),

                // Info Section
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Category Badge & Course Type Badge
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.brandDeepBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                course.category,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.brandDeepBlue,
                                ),
                              ),
                            ),
                            if (course.courseType.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentGreen.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  course.courseType.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.accentGreen,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Title
                        Text(
                          course.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Stats (Duration, Price)
                        Row(
                          children: [
                            const Icon(Icons.access_time_rounded,
                                color: AppTheme.textLight, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              '${course.durationDays} Days',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                            const Spacer(),
                            Text(
                              '₹${course.fee}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.goldenAccent,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Enrollment trigger bar
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 18,
                              backgroundImage: AssetImage(
                                'assets/images/profile.jpg',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _fullName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textDark,
                                  fontSize: 14,
                                ),
                              ),
                            ),

                            // Enrollment Button
                            SizedBox(
                              height: 40,
                              child: ElevatedButton(
                                onPressed: course.isEnrolled
                                    ? null
                                    : () {
                                        showCourseEnrollmentModal(
                                          context,
                                          course,
                                        );
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.accentGreen,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  course.isEnrolled
                                      ? 'Enrolled'
                                      : 'Enroll Now',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: OverviewTabView(course: course),
          ),
        );
      },
    );
  }
}
