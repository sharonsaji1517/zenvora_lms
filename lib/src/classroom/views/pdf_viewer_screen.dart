import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';
import '../utils/resource_url_helper.dart';

class PdfViewerScreen extends StatefulWidget {
  final String title;
  final String? url;

  const PdfViewerScreen({
    super.key,
    required this.title,
    this.url,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  String? _localFilePath;
  bool _isLoading = true;
  String? _errorMessage;
  int _totalPages = 0;
  int _currentPage = 0;
  PDFViewController? _pdfViewController;

  @override
  void initState() {
    super.initState();
    _downloadAndPreparePdf();
  }

  Future<void> _downloadAndPreparePdf() async {
    final fullUrl = ResourceUrlHelper.resolveUrl(widget.url);

    if (fullUrl.isEmpty) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'PDF URL is not available.';
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
      final uri = Uri.parse(fullUrl);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final tempDir = await getTemporaryDirectory();
        final fileName = 'doc_${DateTime.now().millisecondsSinceEpoch}.pdf';
        final file = File('${tempDir.path}/$fileName');
        await file.writeAsBytes(bytes, flush: true);

        if (mounted) {
          setState(() {
            _localFilePath = file.path;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Failed to load document (Status: ${response.statusCode}).';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Unable to download PDF. Please check your internet connection.';
        });
      }
    }
  }

  Future<void> _openInExternalBrowser() async {
    final fullUrl = ResourceUrlHelper.resolveUrl(widget.url);
    if (fullUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No URL available to open.')),
      );
      return;
    }

    try {
      final uri = Uri.parse(fullUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open external browser.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error launching URL: $e')),
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
      body: Builder(
        builder: (context) {
          if (_isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: AppTheme.primaryBlue),
                  const SizedBox(height: 16),
                  Text(
                    'Loading document...',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textMedium,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          if (_errorMessage != null || _localFilePath == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.picture_as_pdf_outlined,
                        size: 48,
                        color: Colors.redAccent,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      _errorMessage ?? 'Failed to load PDF document.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppTheme.textDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _downloadAndPreparePdf,
                          icon: const Icon(Icons.refresh_rounded, size: 18),
                          label: const Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryBlue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: _openInExternalBrowser,
                          icon: const Icon(Icons.open_in_browser_rounded, size: 18),
                          label: const Text('Open External'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.primaryBlue,
                            side: const BorderSide(color: AppTheme.primaryBlue),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }

          return Stack(
            children: [
              PDFView(
                filePath: _localFilePath,
                enableSwipe: true,
                swipeHorizontal: false,
                autoSpacing: true,
                pageFling: true,
                pageSnap: true,
                fitPolicy: FitPolicy.BOTH,
                preventLinkNavigation: false,
                onRender: (pages) {
                  setState(() {
                    _totalPages = pages ?? 0;
                  });
                },
                onError: (error) {
                  setState(() {
                    _errorMessage = error.toString();
                  });
                },
                onPageError: (page, error) {
                  setState(() {
                    _errorMessage = '$page: ${error.toString()}';
                  });
                },
                onViewCreated: (PDFViewController controller) {
                  _pdfViewController = controller;
                },
                onPageChanged: (int? page, int? total) {
                  setState(() {
                    _currentPage = page ?? 0;
                    _totalPages = total ?? 0;
                  });
                },
              ),
              if (_totalPages > 0)
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Page indicator pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          'Page ${_currentPage + 1} of $_totalPages',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Previous / Next quick jump buttons
                      Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.black87,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.chevron_left_rounded, color: Colors.white, size: 22),
                              onPressed: _currentPage > 0 && _pdfViewController != null
                                  ? () => _pdfViewController!.setPage(_currentPage - 1)
                                  : null,
                              tooltip: 'Previous page',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.black87,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.chevron_right_rounded, color: Colors.white, size: 22),
                              onPressed: _currentPage < _totalPages - 1 && _pdfViewController != null
                                  ? () => _pdfViewController!.setPage(_currentPage + 1)
                                  : null,
                              tooltip: 'Next page',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

