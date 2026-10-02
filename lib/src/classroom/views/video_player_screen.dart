import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';
import '../utils/resource_url_helper.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String title;
  final String? url;

  const VideoPlayerScreen({
    super.key,
    required this.title,
    this.url,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isLoading = true;
  String? _errorMessage;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    final fullUrl = ResourceUrlHelper.resolveUrl(widget.url);

    if (fullUrl.isEmpty) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Video URL is not available.';
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      _controller?.dispose();
      _controller = VideoPlayerController.networkUrl(Uri.parse(fullUrl));

      await _controller!.initialize();
      _controller!.addListener(_onControllerUpdate);

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _isLoading = false;
        });
        _controller!.play();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isInitialized = false;
          _errorMessage = 'Failed to load video stream. Please check network connection.';
        });
      }
    }
  }

  void _onControllerUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onControllerUpdate);
    _controller?.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0) {
      return '${twoDigits(duration.inHours)}:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  Future<void> _openInExternalBrowser() async {
    final fullUrl = ResourceUrlHelper.resolveUrl(widget.url);
    if (fullUrl.isEmpty) return;

    try {
      final uri = Uri.parse(fullUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error launching video: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            icon: const Icon(Icons.open_in_browser_rounded, color: AppTheme.primaryBlue),
            tooltip: 'Open in Browser',
            onPressed: _openInExternalBrowser,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Player Container
            Container(
              color: Colors.black,
              width: double.infinity,
              height: 230,
              child: _buildVideoPlayerArea(),
            ),

            // Video Details & Controls Info
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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

                  // Badge & Status Row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.lock_rounded,
                              size: 14,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Private Video Lesson',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      if (_controller != null && _isInitialized)
                        Text(
                          _formatDuration(_controller!.value.duration),
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textMedium,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: AppTheme.borderLight),
                  const SizedBox(height: 16),

                  // Info Notice
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.borderLight),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.security_rounded,
                          color: AppTheme.primaryBlue,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Secure Classroom Stream',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textDark,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'This private lesson is securely streamed from the Zenvora training platform for your enrolled coursework.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.textMedium,
                                  height: 1.4,
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
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayerArea() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 12),
            Text(
              'Loading video stream...',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null || !_isInitialized || _controller == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 40),
              const SizedBox(height: 10),
              Text(
                _errorMessage ?? 'Unable to play video.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _initializeVideo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: const Text('Retry', style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton(
                    onPressed: _openInExternalBrowser,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: const Text('Open External', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    final isBuffering = _controller!.value.isBuffering;
    final isPlaying = _controller!.value.isPlaying;
    final position = _controller!.value.position;
    final duration = _controller!.value.duration;

    return GestureDetector(
      onTap: () {
        setState(() {
          _showControls = !_showControls;
        });
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Center Video
          Center(
            child: AspectRatio(
              aspectRatio: _controller!.value.aspectRatio > 0
                  ? _controller!.value.aspectRatio
                  : 16 / 9,
              child: VideoPlayer(_controller!),
            ),
          ),

          // Buffering Indicator
          if (isBuffering)
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),

          // Overlay Play / Pause & Controls
          if (_showControls) ...[
            // Semi-transparent dimming overlay
            Container(color: Colors.black26),

            // Center Play / Pause button
            Center(
              child: IconButton(
                iconSize: 54,
                icon: Icon(
                  isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    if (isPlaying) {
                      _controller!.pause();
                    } else {
                      _controller!.play();
                    }
                  });
                },
              ),
            ),

            // Bottom Progress Bar & Duration
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black87, Colors.transparent],
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      _formatDuration(position),
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 3,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                          activeTrackColor: AppTheme.accentGreen,
                          inactiveTrackColor: Colors.white30,
                          thumbColor: Colors.white,
                        ),
                        child: Slider(
                          value: position.inMilliseconds
                              .clamp(0, duration.inMilliseconds)
                              .toDouble(),
                          min: 0.0,
                          max: duration.inMilliseconds.toDouble() > 0
                              ? duration.inMilliseconds.toDouble()
                              : 1.0,
                          onChanged: (value) {
                            _controller!.seekTo(Duration(milliseconds: value.toInt()));
                          },
                        ),
                      ),
                    ),
                    Text(
                      _formatDuration(duration),
                      style: const TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
