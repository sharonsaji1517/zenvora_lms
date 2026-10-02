import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/instructor_model.dart';
import '../viewmodels/instructors_view_model.dart';
import 'instructor_details_screen.dart';

class InstructorsScreen extends StatefulWidget {
  const InstructorsScreen({super.key});

  @override
  State<InstructorsScreen> createState() => _InstructorsScreenState();
}

class _InstructorsScreenState extends State<InstructorsScreen> {
  late final InstructorsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = InstructorsViewModel();
    _viewModel.fetchInstructors();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _openInstructorDetails(BuildContext context, InstructorModel instructor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InstructorDetailsScreen(instructor: instructor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Instructors'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: AnimatedBuilder(
        animation: _viewModel,
        builder: (context, _) {
          if (_viewModel.isLoading && _viewModel.instructors.isEmpty) {
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }

          if (_viewModel.hasError && _viewModel.instructors.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: Colors.redAccent,
                      size: 44,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      _viewModel.errorMessage ?? 'Failed to load instructors.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppTheme.textDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => _viewModel.fetchInstructors(),
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: const Text('Try Again'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (_viewModel.instructors.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => _viewModel.fetchInstructors(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: _buildEmptyState(context, primaryColor),
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => _viewModel.fetchInstructors(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Heading
                  const Text(
                    'Our Instructors',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Learn directly from experienced industry leaders and certified instructors.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textMedium,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 2-Column Instructor Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _viewModel.instructors.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.78,
                    ),
                    itemBuilder: (context, index) {
                      final instructor = _viewModel.instructors[index];
                      return _buildInstructorCard(context, instructor, primaryColor);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, Color primaryColor) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.groups_outlined,
                size: 48,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'No Instructors Available',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Instructor details will appear here once available.',
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

  Widget _buildInstructorCard(
    BuildContext context,
    InstructorModel instructor,
    Color primaryColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.borderLight,
          width: 0.9,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _openInstructorDetails(context, instructor),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Circular Profile Image
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: primaryColor.withValues(alpha: 0.2),
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: _buildAvatarImage(instructor.photo, primaryColor),
                  ),
                ),
                const SizedBox(height: 12),

                // Instructor Name
                Text(
                  instructor.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 4),

                // Instructor Role / Designation
                Text(
                  instructor.displayDesignation,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textMedium,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarImage(String? photo, Color primaryColor) {
    if (photo != null && photo.trim().isNotEmpty) {
      final trimmed = photo.trim();
      if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
        return Image.network(
          trimmed,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _buildPlaceholderAvatar(primaryColor),
        );
      } else {
        return Image.asset(
          trimmed,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _buildPlaceholderAvatar(primaryColor),
        );
      }
    }
    return _buildPlaceholderAvatar(primaryColor);
  }

  Widget _buildPlaceholderAvatar(Color primaryColor) {
    return Container(
      color: primaryColor.withValues(alpha: 0.1),
      alignment: Alignment.center,
      child: Icon(
        Icons.person_outline_rounded,
        size: 38,
        color: primaryColor,
      ),
    );
  }
}
