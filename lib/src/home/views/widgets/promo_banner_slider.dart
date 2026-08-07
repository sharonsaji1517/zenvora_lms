import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../viewmodels/app_settings_provider.dart';
import '../../view_models/home_view_model.dart';

class PromoBannerSlider extends StatefulWidget {
  final HomeViewModel viewModel;

  const PromoBannerSlider({super.key, required this.viewModel});

  @override
  State<PromoBannerSlider> createState() => _PromoBannerSliderState();
}

class _PromoBannerSliderState extends State<PromoBannerSlider> {
  late final PageController _pageController;
  Timer? _timer;

  final List<Map<String, String>> _defaultBanners = const [
    {
      'title': ' Safety\nFundamentals\n(Start Now!)',
      'image': 'assets/images/carousel/logistics3.jpg',
      'tag': 'RECOMMENDED',
    },
    {
      'title': 'Offshore Safety\nDrills & Simulation\nManuals Available',
      'image': 'assets/images/carousel/logistics1.jpg',
      'tag': 'NEW EDITION',
    },
    {
      'title': 'Blowout Preventers\nAdvanced Certification\nClass Open',
      'image': 'assets/images/carousel/logistics2.jpg',
      'tag': 'CERTIFICATE',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: widget.viewModel.currentBannerIndex,
    );
    _startAutoSlide(3);
  }

  void _startAutoSlide(int bannerCount) {
    _timer?.cancel();
    if (bannerCount <= 1) return;

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_pageController.hasClients) {
        final nextIndex =
            (widget.viewModel.currentBannerIndex + 1) % bannerCount;
        _pageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _resetAutoSlide(int bannerCount) {
    _startAutoSlide(bannerCount);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  String _resolveImageUrl(String rawUrl) {
    final trimmed = rawUrl.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    final String hostBase = ApiService.baseUrl.replaceAll('/api', '');
    if (trimmed.startsWith('/')) {
      return '$hostBase$trimmed';
    }
    return '$hostBase/$trimmed';
  }

  List<Map<String, String>> _getActiveBanners(AppSettingsProvider settings) {
    final sliders = settings.sliders;
    if (sliders.isEmpty) {
      return _defaultBanners;
    }

    return sliders.map((slider) {
      final String image = slider.image.trim().isNotEmpty
          ? _resolveImageUrl(slider.image)
          : 'assets/images/carousel/logistics3.jpg';
      final String title = slider.title.trim().isNotEmpty
          ? slider.title
          : 'Safety Fundamentals';
      return {
        'title': title,
        'image': image,
        'tag': 'RECOMMENDED',
      };
    }).toList();
  }

  Widget _buildBannerImage(String imagePath) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        color: Colors.black.withOpacity(0.10),
        colorBlendMode: BlendMode.srcOver,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey[300],
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/images/carousel/logistics3.jpg',
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.10),
            colorBlendMode: BlendMode.srcOver,
          );
        },
      );
    }

    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
      color: Colors.black.withOpacity(0.10),
      colorBlendMode: BlendMode.srcOver,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[800],
          child: const Center(
            child: Icon(
              Icons.broken_image,
              color: Colors.white,
              size: 48,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsProvider>();
    final activeBanners = _getActiveBanners(settings);
    final int bannerCount = activeBanners.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          SizedBox(
            height: 190,
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification notification) {
                if (notification is ScrollStartNotification &&
                    notification.dragDetails != null) {
                  _timer?.cancel();
                } else if (notification is ScrollEndNotification) {
                  _resetAutoSlide(bannerCount);
                }
                return false;
              },
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  widget.viewModel.setBannerIndex(index);
                  _resetAutoSlide(bannerCount);
                },
                itemCount: bannerCount,
                itemBuilder: (context, index) {
                  final banner = activeBanners[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: _buildBannerImage(banner['image']!),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.accentGreen,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    banner['tag']!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  banner['title']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    height: 1.25,
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
            ),
          ),
          const SizedBox(height: 12),
          // Dot Indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              bannerCount,
              (index) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.viewModel.currentBannerIndex == index
                      ? Theme.of(context).colorScheme.primary
                      : AppTheme.borderLight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
