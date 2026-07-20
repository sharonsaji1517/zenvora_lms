import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../view_models/home_view_model.dart';

class PromoBannerSlider extends StatefulWidget {
  final HomeViewModel viewModel;

  const PromoBannerSlider({super.key, required this.viewModel});

  @override
  State<PromoBannerSlider> createState() => _PromoBannerSliderState();
}

class _PromoBannerSliderState extends State<PromoBannerSlider> {
  late final PageController _pageController;

  final List<Map<String, String>> _banners = [
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
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 190,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: widget.viewModel.setBannerIndex,
            itemCount: _banners.length,
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          banner['image']!,
                          fit: BoxFit.cover,
                          color: Colors.black.withOpacity(0.55),
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
                        ),
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
        const SizedBox(height: 12),
        // Dot Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (index) => Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.viewModel.currentBannerIndex == index
                    ? AppTheme.primaryBlue
                    : AppTheme.borderLight,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
