import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../utils/resource_url_helper.dart';

class YoutubePlayerScreen extends StatefulWidget {
  final String title;
  final String? url;

  const YoutubePlayerScreen({
    super.key,
    required this.title,
    this.url,
  });

  @override
  State<YoutubePlayerScreen> createState() => _YoutubePlayerScreenState();
}

class _YoutubePlayerScreenState extends State<YoutubePlayerScreen> {
  YoutubePlayerController? _controller;
  String? _errorMessage;
  String? _videoId;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  static String? _extractVideoId(String url) {
    if (url.isEmpty) return null;
    final regExp = RegExp(
      r'(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})',
      caseSensitive: false,
    );
    final match = regExp.firstMatch(url);
    if (match != null && match.groupCount >= 1) {
      return match.group(1);
    }
    return null;
  }

  void _initializePlayer() {
    final fullUrl = ResourceUrlHelper.resolveUrl(widget.url);

    if (fullUrl.isEmpty) {
      setState(() {
        _errorMessage = 'YouTube URL is not available.';
      });
      return;
    }

    final videoId = _extractVideoId(fullUrl);

    if (videoId == null || videoId.isEmpty) {
      setState(() {
        _videoId = null;
        _errorMessage = 'Could not parse YouTube video ID from URL. You can open it in the browser or YouTube app.';
      });
      return;
    }

    _videoId = videoId;
    _controller = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        mute: false,
        enableCaption: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller?.close();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  Future<void> _openExternal() async {
    final fullUrl = ResourceUrlHelper.resolveUrl(widget.url);
    if (fullUrl.isEmpty) return;

    try {
      final uri = Uri.parse(fullUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error launching YouTube: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || _videoId == null) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundLight,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.textDark, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            widget.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppTheme.textDark,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_circle_outline_rounded,
                    size: 54,
                    color: Colors.redAccent,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  _errorMessage ?? 'Video could not be played in-app.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppTheme.textDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _openExternal,
                  icon: const Icon(Icons.open_in_new_rounded, color: Colors.white),
                  label: const Text('Open in YouTube App / Browser'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.textDark, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppTheme.textDark,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_new_rounded, color: Colors.redAccent),
            tooltip: 'Open in YouTube',
            onPressed: _openExternal,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // In-App Video Player
            YoutubePlayer(
              controller: _controller!,
              aspectRatio: 16 / 9,
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Video Title
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Platform Badge
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.play_arrow_rounded, color: Colors.redAccent, size: 16),
                            SizedBox(width: 4),
                            Text(
                              'YouTube Video Reference',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: _openExternal,
                        icon: const Icon(Icons.launch_rounded, size: 16, color: AppTheme.primaryBlue),
                        label: const Text('Open Externally', style: TextStyle(fontSize: 12, color: AppTheme.primaryBlue)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Divider(color: AppTheme.borderLight),
                  const SizedBox(height: 16),

                  // Help card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.borderLight),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline_rounded, color: AppTheme.textMedium, size: 20),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'You can view this study video in fullscreen or tap the external link to view in the YouTube app.',
                            style: TextStyle(fontSize: 12.5, color: AppTheme.textMedium, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

