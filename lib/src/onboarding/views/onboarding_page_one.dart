import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class OnboardingPageOne extends StatelessWidget {
  const OnboardingPageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.white,
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Top Header Section
          Column(
            children: [
              const Text(
                'Learn from Industry Experts',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                  letterSpacing: -0.3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Access professional Oil & Gas courses through videos, PDFs, classroom resources and practical learning.',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.45,
                  color: AppTheme.textMedium,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Center Oil & Gas Learning Illustration
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double size = constraints.maxHeight < constraints.maxWidth
                    ? constraints.maxHeight
                    : constraints.maxWidth;
                final double finalSize = size.clamp(200.0, 320.0);

                return Center(
                  child: SizedBox(
                    width: finalSize,
                    height: finalSize,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Soft Background Circle
                        Container(
                          width: finalSize * 0.85,
                          height: finalSize * 0.85,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Theme.of(context).colorScheme.primary.withOpacity(0.08),
                                Theme.of(context).colorScheme.secondary.withOpacity(0.02),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),

                        // Custom Oil & Gas Learning Painter Canvas
                        CustomPaint(
                          size: Size(finalSize, finalSize),
                          painter: _OilAndGasIllustrationPainter(primaryColor: Theme.of(context).colorScheme.primary),
                        ),

                        // Interactive Laptop Screen Card Overlay
                        Positioned(
                          bottom: finalSize * 0.18,
                          child: Container(
                            width: finalSize * 0.72,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                              border: Border.all(
                                color: AppTheme.borderLight,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.play_circle_fill_rounded,
                                        color: Theme.of(context).colorScheme.primary,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Petroleum Engineering 101',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.textDark,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            'Video Lesson • Live Simulator',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: AppTheme.textMedium,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppTheme.goldenAccent.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        'HD',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.goldenAccent,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: 0.65,
                                    backgroundColor: AppTheme.borderLight,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).colorScheme.primary,
                                    ),
                                    minHeight: 4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Safety Helmet Badge Top Right
                        Positioned(
                          top: finalSize * 0.1,
                          right: finalSize * 0.05,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppTheme.goldenAccent,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.goldenAccent.withOpacity(0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.engineering_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        ),

                        // Industrial Derrick / Training Badge Top Left
                        Positioned(
                          top: finalSize * 0.12,
                          left: finalSize * 0.06,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.local_gas_station_rounded,
                              color: AppTheme.goldenAccent,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _OilAndGasIllustrationPainter extends CustomPainter {
  final Color primaryColor;

  _OilAndGasIllustrationPainter({required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    // Derrick Industrial Rig Lines Background
    final Paint linePaint = Paint()
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..color = primaryColor.withOpacity(0.15);

    final Path rigPath = Path();
    final double cx = width * 0.5;
    rigPath.moveTo(cx - 30, height * 0.45);
    rigPath.lineTo(cx, height * 0.15);
    rigPath.lineTo(cx + 30, height * 0.45);

    // Cross beams
    rigPath.moveTo(cx - 18, height * 0.33);
    rigPath.lineTo(cx + 18, height * 0.33);
    rigPath.moveTo(cx - 18, height * 0.33);
    rigPath.lineTo(cx + 12, height * 0.25);
    rigPath.moveTo(cx + 18, height * 0.33);
    rigPath.lineTo(cx - 12, height * 0.25);

    canvas.drawPath(rigPath, linePaint);

    // Energy / Flame Badge at top of Rig
    final Paint nodePaint = Paint()
      ..color = AppTheme.goldenAccent
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, height * 0.15), 6, nodePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
