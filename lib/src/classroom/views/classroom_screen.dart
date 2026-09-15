import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/api_service.dart';
import '../../../../models/course_model.dart';
import '../models/classroom_model.dart';
import '../view_models/classroom_view_model.dart';

class ClassroomScreen extends StatefulWidget {
  const ClassroomScreen({super.key});

  @override
  State<ClassroomScreen> createState() => _ClassroomScreenState();
}

class _ClassroomScreenState extends State<ClassroomScreen> {
  late final ClassroomViewModel _viewModel;
  bool _isInit = false;
  int _currentCourseId = 0;

  @override
  void initState() {
    super.initState();
    _viewModel = ClassroomViewModel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is int) {
        _currentCourseId = args;
        _viewModel.fetchClassroom(_currentCourseId);
      } else if (args is String && int.tryParse(args) != null) {
        _currentCourseId = int.parse(args);
        _viewModel.fetchClassroom(_currentCourseId);
      } else if (args is CourseModel) {
        _currentCourseId = args.id;
        _viewModel.fetchClassroom(_currentCourseId);
      } else {
        _fetchDefaultClassroom();
      }
      _isInit = true;
    }
  }

  Future<void> _fetchDefaultClassroom() async {
    try {
      final courses = await ApiService().getStudentDashboard();
      if (courses.isNotEmpty) {
        _currentCourseId = courses.first.id;
        _viewModel.fetchClassroom(_currentCourseId);
      } else {
        _viewModel.fetchClassroom(_currentCourseId);
      }
    } catch (e) {
      _viewModel.fetchClassroom(_currentCourseId);
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'My Classroom',
          style: TextStyle(
            color: AppTheme.textDark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, child) {
          if (_viewModel.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          }

          if (_viewModel.errorMessage != null && _viewModel.classroom == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _viewModel.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppTheme.textMedium,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => _viewModel.fetchClassroom(_currentCourseId),
                      icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                      label: const Text(
                        'Retry',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final classroom = _viewModel.classroom;
          final course = classroom?.course;

          return RefreshIndicator(
            onRefresh: () => _viewModel.fetchClassroom(_currentCourseId),
            color: Theme.of(context).colorScheme.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Banner with Brand Gradient
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 400),
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    builder: (context, opacity, child) {
                      return Opacity(
                        opacity: opacity,
                        child: child,
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        gradient: AppTheme.brandThreeColorGradientOf(context),
                        borderRadius: BorderRadius.circular(24.0),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.brandOceanBlue.withValues(alpha: 0.25),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '👋 Welcome Back',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Access your enrolled classes and continue learning.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.9),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Statistics Row
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 500),
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    builder: (context, opacity, child) {
                      return Opacity(
                        opacity: opacity,
                        child: child,
                      );
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            title: 'Courses',
                            value: '${_viewModel.coursesCount}',
                            icon: Icons.menu_book_rounded,
                            iconColor: Theme.of(context).colorScheme.primary,
                            bgColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            title: 'Lessons',
                            value: '${_viewModel.lessonsCount}',
                            icon: Icons.play_circle_outline_rounded,
                            iconColor: Theme.of(context).colorScheme.secondary,
                            bgColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            title: 'Completed',
                            value: _viewModel.completionRate,
                            icon: Icons.workspace_premium_rounded,
                            iconColor: AppTheme.accentGreen,
                            bgColor: AppTheme.accentGreen.withValues(alpha: 0.1),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Course Header Card
                  if (course != null) ...[
                    _buildCourseHeaderCard(course),
                    const SizedBox(height: 24),
                  ],

                  // Videos Section
                  if (classroom != null && classroom.videos.isNotEmpty) ...[
                    _buildSectionHeader('Videos', Icons.play_circle_fill_rounded, Theme.of(context).colorScheme.primary),
                    const SizedBox(height: 12),
                    ...classroom.videos.map((video) => _buildResourceTile(
                          title: video.title,
                          icon: Icons.play_arrow_rounded,
                          iconColor: Theme.of(context).colorScheme.primary,
                          subtitle: 'Video Lesson',
                        )),
                    const SizedBox(height: 24),
                  ],

                  // YouTube Links Section
                  if (classroom != null && classroom.youtubeLinks.isNotEmpty) ...[
                    _buildSectionHeader('YouTube Links', Icons.video_library_rounded, Colors.redAccent),
                    const SizedBox(height: 12),
                    ...classroom.youtubeLinks.map((yt) => _buildResourceTile(
                          title: yt.title,
                          icon: Icons.play_circle_outline_rounded,
                          iconColor: Colors.redAccent,
                          subtitle: 'YouTube Reference',
                        )),
                    const SizedBox(height: 24),
                  ],

                  // PDF Section
                  _buildSectionHeader('PDF Resources', Icons.picture_as_pdf_rounded, Colors.deepOrangeAccent),
                  const SizedBox(height: 12),
                  if (classroom == null || classroom.pdfs.isEmpty)
                    _buildEmptyResourceCard('No PDF resources available', Icons.picture_as_pdf_outlined)
                  else
                    ...classroom.pdfs.map((pdf) => _buildResourceTile(
                          title: pdf.title,
                          icon: Icons.picture_as_pdf_rounded,
                          iconColor: Colors.deepOrangeAccent,
                          subtitle: 'PDF Document',
                        )),
                  const SizedBox(height: 24),

                  // PPT Section
                  _buildSectionHeader('PPT Presentations', Icons.slideshow_rounded, Colors.amber.shade800),
                  const SizedBox(height: 12),
                  if (classroom == null || classroom.ppts.isEmpty)
                    _buildEmptyResourceCard('No PPT resources available', Icons.slideshow_outlined)
                  else
                    ...classroom.ppts.map((ppt) => _buildResourceTile(
                          title: ppt.title,
                          icon: Icons.slideshow_rounded,
                          iconColor: Colors.amber.shade800,
                          subtitle: 'PPT Presentation',
                        )),
                  const SizedBox(height: 24),

                  // Private Videos Section
                  _buildSectionHeader('Private Videos', Icons.lock_clock_rounded, Theme.of(context).colorScheme.secondary),
                  const SizedBox(height: 12),
                  if (classroom == null || classroom.privateVideos.isEmpty)
                    _buildEmptyResourceCard('No private videos available', Icons.lock_outline_rounded)
                  else
                    ...classroom.privateVideos.map((pv) => _buildResourceTile(
                          title: pv.title,
                          icon: Icons.lock_clock_rounded,
                          iconColor: Theme.of(context).colorScheme.secondary,
                          subtitle: 'Private Video',
                        )),
                  const SizedBox(height: 24),

                  // Quick Actions Buttons
                  Row(
                    children: [
                      // Primary Button
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: AppTheme.brandBlueGreenGradientOf(context),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.25),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Join Classroom',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Secondary Outlined Button
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: OutlinedButton(
                            onPressed: null,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: AppTheme.primaryBlue.withValues(alpha: 0.4),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Coming Soon',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textMedium,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Bottom Information Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.15),
                      ),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: AppTheme.primaryBlue,
                          size: 22,
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            'Once you enroll in a course, your classroom sessions, live classes and study materials will appear here.',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.textMedium,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCourseHeaderCard(ClassroomCourseModel course) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: AppTheme.borderLight.withValues(alpha: 0.6)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: (course.thumbnail != null && course.thumbnail!.startsWith('http'))
                  ? Image.network(
                      course.thumbnail!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildImageFallback(),
                    )
                  : _buildImageFallback(),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            course.courseName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (course.courseFee != null) ...[
                _buildBadge(Icons.monetization_on_outlined, course.courseFee!, AppTheme.accentGreen),
                const SizedBox(width: 8),
              ],
              if (course.duration != null) ...[
                _buildBadge(Icons.schedule_rounded, course.duration!, AppTheme.brandOceanBlue),
                const SizedBox(width: 8),
              ],
              if (course.courseType != null) ...[
                _buildBadge(Icons.school_outlined, course.courseType!, AppTheme.primaryBlue),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageFallback() {
    return Container(
      color: AppTheme.primaryBlue.withValues(alpha: 0.1),
      child: const Center(
        child: Icon(
          Icons.school_rounded,
          size: 64,
          color: AppTheme.primaryBlue,
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color iconColor) {
    return Row(
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildResourceTile({
    required String title,
    required IconData icon,
    required Color iconColor,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: AppTheme.borderLight.withValues(alpha: 0.6)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppTheme.textDark,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textMedium,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyResourceCard(String message, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.textLight, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textMedium,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppTheme.borderLight.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.textMedium,
            ),
          ),
        ],
      ),
    );
  }
}
