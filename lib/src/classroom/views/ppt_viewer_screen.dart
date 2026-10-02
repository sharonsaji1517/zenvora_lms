import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';
import '../utils/resource_url_helper.dart';

class PptViewerScreen extends StatefulWidget {
  final String title;
  final String? url;

  const PptViewerScreen({
    super.key,
    required this.title,
    this.url,
  });

  @override
  State<PptViewerScreen> createState() => _PptViewerScreenState();
}

class _PptViewerScreenState extends State<PptViewerScreen> {
  bool _isOpening = false;
  String? _errorMessage;

  Future<void> _openPpt({bool useOnlineViewer = false}) async {
    final rawUrl = ResourceUrlHelper.resolveUrl(widget.url);

    if (rawUrl.isEmpty) {
      setState(() {
        _errorMessage = 'Presentation URL is not available.';
      });
      return;
    }

    setState(() {
      _isOpening = true;
      _errorMessage = null;
    });

    try {
      final targetUrl = useOnlineViewer
          ? 'https://docs.google.com/viewer?url=${Uri.encodeComponent(rawUrl)}'
          : rawUrl;

      final uri = Uri.parse(targetUrl);
      final canLaunch = await canLaunchUrl(uri);

      if (canLaunch) {
        final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (!launched) {
          // Fallback to in-app or platform default
          await launchUrl(uri, mode: LaunchMode.platformDefault);
        }
      } else {
        // Try fallback to Google Docs viewer if direct launch fails
        if (!useOnlineViewer) {
          final docsViewerUri = Uri.parse('https://docs.google.com/viewer?url=${Uri.encodeComponent(rawUrl)}');
          await launchUrl(docsViewerUri, mode: LaunchMode.externalApplication);
        } else {
          if (mounted) {
            setState(() {
              _errorMessage = 'Could not open the presentation URL on this device.';
            });
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error opening presentation: ${e.toString()}';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isOpening = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final fullUrl = ResourceUrlHelper.resolveUrl(widget.url);

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),

            // Presentation Icon Card
            Center(
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.amber.shade200, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.shade100.withValues(alpha: 0.5),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.slideshow_rounded,
                  size: 58,
                  color: Colors.amber.shade800,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Presentation Title
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),

            // Tag badge
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'PowerPoint Presentation',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade900,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Metadata Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppTheme.borderLight),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildMetaRow(Icons.description_outlined, 'Format', 'PPT / Slides'),
                  const Divider(color: AppTheme.borderLight, height: 20),
                  _buildMetaRow(Icons.cloud_done_outlined, 'Availability', 'Ready to View'),
                  const Divider(color: AppTheme.borderLight, height: 20),
                  _buildMetaRow(
                    Icons.link_rounded,
                    'Resource Link',
                    fullUrl.isNotEmpty ? 'Server URL Linked' : 'Unavailable',
                    valueColor: fullUrl.isNotEmpty ? AppTheme.accentGreen : Colors.redAccent,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Error Message display
            if (_errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Action Buttons
            SizedBox(
              height: 52,
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppTheme.brandBlueGreenGradientOf(context),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: _isOpening ? null : () => _openPpt(useOnlineViewer: false),
                  icon: _isOpening
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.open_in_new_rounded, color: Colors.white, size: 20),
                  label: Text(
                    _isOpening ? 'Opening...' : 'Open Presentation',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Alternative viewer button
            SizedBox(
              height: 48,
              child: OutlinedButton.icon(
                onPressed: _isOpening ? null : () => _openPpt(useOnlineViewer: true),
                icon: const Icon(Icons.preview_rounded, color: AppTheme.primaryBlue, size: 18),
                label: const Text(
                  'View Online via Google Docs',
                  style: TextStyle(
                    color: AppTheme.primaryBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.primaryBlue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaRow(IconData icon, String label, String value, {Color? valueColor}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.textMedium),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13.5,
            color: AppTheme.textMedium,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.bold,
            color: valueColor ?? AppTheme.textDark,
          ),
        ),
      ],
    );
  }
}
