import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../models/course_model.dart';
import '../view_models/course_detail_view_model.dart';
import 'widgets/overview_tab_view.dart';
import '../../../../core/services/user_preferences_service.dart';

class CourseDetailScreen extends StatefulWidget {
  const CourseDetailScreen({super.key});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen>
    with SingleTickerProviderStateMixin {
  CourseDetailViewModel? _viewModel;
  late TabController _tabController;
  String _fullName = 'Guest User';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_viewModel != null) {
        _viewModel!.setActiveTab(_tabController.index);
      }
    });
  }

  Future<void> _loadUserData() async {
    final prefsService = UserPreferencesService();
    final name = await prefsService.getFullName();
    setState(() {
      _fullName = name;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_viewModel == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      final CourseModel selectedCourse = (args is CourseModel)
          ? args
          : CourseModel(
              id: 1,
              name: 'Course Details',
              slug: 'course-details',
              category: 'General',
              categoryId: 1,
              fee: '0',
              durationDays: 0,
              courseType: 'free',
              shortDescription: 'Course details description',
            );

      _viewModel = CourseDetailViewModel(course: selectedCourse);
      _tabController.index = _viewModel!.activeTabIndex;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final size = MediaQuery.of(context).size;
    final course = _viewModel!.course;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: ListenableBuilder(
        listenable: _viewModel!,
        builder: (context, child) {
          return NestedScrollView(
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

                // Info Section & Tab Bar Area
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
                        // Category Badge
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
                                        _viewModel!.enrollInCourse(context);
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
                                child: _viewModel!.isEnrolling
                                    ? const SizedBox(
                                        height: 16,
                                        width: 16,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text(
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
                        const SizedBox(height: 24),

                        // Tab Bar
                        TabBar(
                          controller: _tabController,
                          indicatorColor: AppTheme.primaryBlue,
                          labelColor: AppTheme.primaryBlue,
                          unselectedLabelColor: AppTheme.textLight,
                          labelStyle: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14),
                          unselectedLabelStyle: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 14),
                          tabs: const [
                            Tab(text: 'Overview'),
                            Tab(text: 'Syllabus'),
                            Tab(text: 'Resources'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                OverviewTabView(course: course),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      'Syllabus for ${course.name} will be available soon.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppTheme.textMedium),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      'Resources for ${course.name} will be available soon.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppTheme.textMedium),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
