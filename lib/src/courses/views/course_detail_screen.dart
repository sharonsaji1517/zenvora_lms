import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/routes/app_routes.dart';
import '../models/course_model.dart';
import '../view_models/course_detail_view_model.dart';
import 'widgets/overview_tab_view.dart';
import 'widgets/syllabus_tab_view.dart';
import 'widgets/resources_tab_view.dart';
import '../../../../core/services/user_preferences_service.dart';

class CourseDetailScreen extends StatefulWidget {
  const CourseDetailScreen({super.key});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> with SingleTickerProviderStateMixin {
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
      // Safely extract the course from routes argument, or use a default mock course fallback
      final args = ModalRoute.of(context)?.settings.arguments;
      final Course selectedCourse = (args is Course) ? args : getMockCourses().first;
      
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
                    background: Image.asset(
                      course.imageUrl,
                      fit: BoxFit.cover,
                      color: Colors.black.withOpacity(0.4),
                      colorBlendMode: BlendMode.srcOver,
                    ),
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
                        // Title
                        Text(
                          course.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Stats (Rating, Reviews, Price, Instructor Avatar)
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: AppTheme.goldenAccent, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              course.rating.toString(),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(${course.reviewCount} Reviews)',
                              style: const TextStyle(color: AppTheme.textLight, fontSize: 12),
                            ),
                            const Spacer(),
                            Text(
                              '\$${course.price.toStringAsFixed(2)}',
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
                            // User mini avatar
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
                                        Navigator.pushNamed(
                                          context,
                                          AppRoutes.courseEnrollment,
                                          arguments: course,
                                        ).then((_) {
                                          // Refresh view state in case user returns (e.g. if they completed flow)
                                          setState(() {});
                                        });
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.accentGreen,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                        course.isEnrolled ? 'Enrolled' : 'Enroll Now',
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
                          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
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
                SyllabusTabView(viewModel: _viewModel!),
                ResourcesTabView(course: course),
              ],
            ),
          );
        },
      ),
    );
  }
}
