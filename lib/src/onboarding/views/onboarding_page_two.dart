import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../../viewmodels/app_settings_provider.dart';

class OnboardingPageTwo extends StatelessWidget {
  const OnboardingPageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsProvider>();
    final appName = settings.appName.isNotEmpty ? settings.appName : 'Zenvora';

    return Container(
      color: AppTheme.white,
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Top Header Section
          Column(
            children: [
              Text(
                'Build Your Career with $appName',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                  letterSpacing: -0.3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Enroll in certified training programs, access your classroom instantly and start your professional learning journey.',
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

          // Center Career Growth / Certificate Illustration
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
                        // Glow background
                        Container(
                          width: finalSize * 0.85,
                          height: finalSize * 0.85,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                AppTheme.goldenAccent.withOpacity(0.1),
                                AppTheme.primaryBlue.withOpacity(0.03),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),

                        // Custom Career Chart & Rays Painter
                        CustomPaint(
                          size: Size(finalSize, finalSize),
                          painter: _CareerIllustrationPainter(),
                        ),

                        // Main Certificate Card Overlay
                        Positioned(
                          child: Container(
                            width: finalSize * 0.76,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryBlue.withOpacity(0.14),
                                  blurRadius: 24,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                              border: Border.all(
                                color: AppTheme.goldenAccent.withOpacity(0.4),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.workspace_premium_rounded,
                                          color: AppTheme.goldenAccent,
                                          size: 26,
                                        ),
                                        const SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                              'ZENVORA CERTIFIED',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: AppTheme.primaryBlue,
                                                letterSpacing: 0.8,
                                              ),
                                            ),
                                            Text(
                                              'Oil & Gas Professional',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: AppTheme.textMedium,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: AppTheme.brandEmeraldGreen,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  height: 3,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: AppTheme.primaryGradient,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.verified_rounded,
                                          color: AppTheme.secondaryBlue,
                                          size: 16,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          'Industry Verified',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.textDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryBlue.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'Level 5',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.primaryBlue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Career Growth Trophy Badge Top Left
                        Positioned(
                          top: finalSize * 0.08,
                          left: finalSize * 0.05,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryBlue,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryBlue.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.trending_up_rounded,
                              color: AppTheme.goldenAccent,
                              size: 24,
                            ),
                          ),
                        ),

                        // Certified Badge Bottom Right
                        Positioned(
                          bottom: finalSize * 0.1,
                          right: finalSize * 0.06,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppTheme.goldenAccent,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.goldenAccent.withOpacity(0.35),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.card_membership_rounded,
                              color: Colors.white,
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

class _CareerIllustrationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    // Upward trend line graph in background
    final Paint linePaint = Paint()
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..color = AppTheme.primaryBlue.withOpacity(0.2);

    final Path path = Path();
    path.moveTo(width * 0.15, height * 0.75);
    path.quadraticBezierTo(
      width * 0.35,
      height * 0.65,
      width * 0.5,
      height * 0.45,
    );
    path.quadraticBezierTo(
      width * 0.7,
      height * 0.3,
      width * 0.85,
      height * 0.2,
    );

    canvas.drawPath(path, linePaint);

    // Glowing Star dot at the peak
    final Paint starPaint = Paint()
      ..color = AppTheme.goldenAccent
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(width * 0.85, height * 0.2), 5, starPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
