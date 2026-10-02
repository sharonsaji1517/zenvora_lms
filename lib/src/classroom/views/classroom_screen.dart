import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/api_service.dart';
import '../../../../models/course_model.dart';
import '../models/classroom_model.dart';
import '../view_models/classroom_view_model.dart';
import 'pdf_viewer_screen.dart';
import 'ppt_viewer_screen.dart';
import 'youtube_player_screen.dart';
import 'video_player_screen.dart';

class ClassroomScreen extends StatefulWidget {
  const ClassroomScreen({super.key});

  @override
  State<ClassroomScreen> createState() => _ClassroomScreenState();
}

class _ClassroomScreenState extends State<ClassroomScreen> {
  late final ClassroomViewModel _viewModel;
  bool _isInit = false;
  int _currentCourseId = 0;
  int _selectedTabIndex = 0; // 0: PDF, 1: PPT, 2: YouTube Links, 3: Private Videos

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
                  // 1. Dynamic Course Header Card (Image & Name/Details)
                  if (course != null) ...[
                    _buildCourseHeaderCard(course),
                    const SizedBox(height: 20),
                  ],

                  // 2. Content Tabs (PDF | PPT | YouTube Links | Private Videos)
                  _buildContentTabs(classroom),
                  const SizedBox(height: 20),

                  // 3. Selected Category Content Only
                  _buildSelectedContent(classroom),
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
                            'Your classroom materials and study sessions for this enrolled course are updated automatically.',
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
    final imagePath = course.thumbnail;
    final bool hasValidUrl = imagePath != null &&
        imagePath.trim().isNotEmpty &&
        (imagePath.startsWith('http://') || imagePath.startsWith('https://') || imagePath.startsWith('/'));
    final fullUrl = hasValidUrl
        ? (imagePath.startsWith('/')
            ? 'https://zen.trynet.work$imagePath'
            : imagePath)
        : null;

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
              child: fullUrl != null
                  ? Image.network(
                      fullUrl,
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
          if (course.courseFee != null || course.duration != null || course.courseType != null) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (course.courseFee != null && course.courseFee!.trim().isNotEmpty)
                  _buildBadge(Icons.monetization_on_outlined, course.courseFee!, AppTheme.accentGreen),
                if (course.duration != null && course.duration!.trim().isNotEmpty)
                  _buildBadge(Icons.schedule_rounded, course.duration!, AppTheme.brandOceanBlue),
                if (course.courseType != null && course.courseType!.trim().isNotEmpty)
                  _buildBadge(Icons.school_outlined, course.courseType!, AppTheme.primaryBlue),
              ],
            ),
          ],
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

  void _openPdf(ClassroomPdfModel pdf) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfViewerScreen(
          title: pdf.title,
          url: pdf.url,
        ),
      ),
    );
  }

  void _openPpt(ClassroomPptModel ppt) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PptViewerScreen(
          title: ppt.title,
          url: ppt.url,
        ),
      ),
    );
  }

  void _openYoutubeLink(ClassroomYoutubeLinkModel yt) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => YoutubePlayerScreen(
          title: yt.title,
          url: yt.url,
        ),
      ),
    );
  }

  void _openPrivateVideo(ClassroomPrivateVideoModel pv) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(
          title: pv.title,
          url: pv.url,
        ),
      ),
    );
  }

  Widget _buildContentTabs(ClassroomModel? classroom) {
    final privateCount = (classroom?.privateVideos.length ?? 0) > 0
        ? classroom!.privateVideos.length
        : (classroom?.videos.length ?? 0);

    final tabs = [
      {'label': 'PDF', 'icon': Icons.picture_as_pdf_rounded, 'count': classroom?.pdfs.length ?? 0},
      {'label': 'PPT', 'icon': Icons.slideshow_rounded, 'count': classroom?.ppts.length ?? 0},
      {'label': 'YouTube Links', 'icon': Icons.play_circle_fill_rounded, 'count': classroom?.youtubeLinks.length ?? 0},
      {'label': 'Private Videos', 'icon': Icons.lock_rounded, 'count': privateCount},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final tab = tabs[index];
          final isSelected = _selectedTabIndex == index;
          final count = tab['count'] as int;

          return Padding(
            padding: EdgeInsets.only(
              right: index < tabs.length - 1 ? 10.0 : 0.0,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedTabIndex = index;
                  });
                },
                borderRadius: BorderRadius.circular(14),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? AppTheme.brandBlueGreenGradientOf(context)
                        : null,
                    color: isSelected ? null : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : AppTheme.borderLight,
                      width: 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        tab['icon'] as IconData,
                        size: 16,
                        color: isSelected
                            ? Colors.white
                            : AppTheme.textMedium,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        tab['label'] as String,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : AppTheme.textDark,
                        ),
                      ),
                      if (count > 0) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white.withValues(alpha: 0.25)
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$count',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white
                                  : AppTheme.textMedium,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSelectedContent(ClassroomModel? classroom) {
    if (classroom == null) {
      return _buildEmptyResourceCard('No classroom content available', Icons.folder_open_rounded);
    }

    switch (_selectedTabIndex) {
      case 0: // PDF
        final pdfs = classroom.pdfs;
        if (pdfs.isEmpty) {
          return _buildEmptyResourceCard('No PDF resources available', Icons.picture_as_pdf_outlined);
        }
        return Column(
          children: pdfs
              .map((pdf) => _buildResourceTile(
                    title: pdf.title,
                    icon: Icons.picture_as_pdf_rounded,
                    iconColor: Colors.deepOrangeAccent,
                    subtitle: 'PDF Document',
                    onTap: () => _openPdf(pdf),
                  ))
              .toList(),
        );

      case 1: // PPT
        final ppts = classroom.ppts;
        if (ppts.isEmpty) {
          return _buildEmptyResourceCard('No PPT resources available', Icons.slideshow_outlined);
        }
        return Column(
          children: ppts
              .map((ppt) => _buildResourceTile(
                    title: ppt.title,
                    icon: Icons.slideshow_rounded,
                    iconColor: Colors.amber.shade800,
                    subtitle: 'PPT Presentation',
                    onTap: () => _openPpt(ppt),
                  ))
              .toList(),
        );

      case 2: // YouTube Links
        final youtubeLinks = classroom.youtubeLinks;
        if (youtubeLinks.isEmpty) {
          return _buildEmptyResourceCard('No YouTube links available', Icons.video_library_outlined);
        }
        return Column(
          children: youtubeLinks
              .map((yt) => _buildResourceTile(
                    title: yt.title,
                    icon: Icons.play_circle_outline_rounded,
                    iconColor: Colors.redAccent,
                    subtitle: 'YouTube Reference',
                    onTap: () => _openYoutubeLink(yt),
                  ))
              .toList(),
        );

      case 3: // Private Videos
        final privateVideos = classroom.privateVideos.isNotEmpty
            ? classroom.privateVideos
            : classroom.videos
                .map((v) => ClassroomPrivateVideoModel(
                      id: v.id,
                      title: v.title,
                      url: v.url,
                    ))
                .toList();

        if (privateVideos.isEmpty) {
          return _buildEmptyResourceCard('No private videos available', Icons.lock_outline_rounded);
        }
        return Column(
          children: privateVideos
              .map((pv) => _buildResourceTile(
                    title: pv.title,
                    icon: Icons.lock_clock_rounded,
                    iconColor: Theme.of(context).colorScheme.secondary,
                    subtitle: 'Private Video',
                    onTap: () => _openPrivateVideo(pv),
                  ))
              .toList(),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildResourceTile({
    required String title,
    required IconData icon,
    required Color iconColor,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: AppTheme.borderLight.withValues(alpha: 0.8)),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppTheme.textDark,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textMedium,
            ),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: AppTheme.textLight.withValues(alpha: 0.8),
        ),
      ),
    );
  }

  Widget _buildEmptyResourceCard(String message, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderLight.withValues(alpha: 0.8)),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppTheme.textLight, size: 40),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textMedium,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
