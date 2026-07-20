import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../screens/my_courses_screen.dart';
import '../models/course_model.dart';

class CourseSuccessScreen extends StatelessWidget {
  const CourseSuccessScreen({super.key});

  String _getFormattedDate() {
    final now = DateTime.now();
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${now.day} ${months[now.month - 1]} ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    // Extract arguments passed from CourseEnrollmentScreen
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final Course course = args?['course'] ?? getMockCourses().first;
    final String paymentMethod = args?['paymentMethod'] ?? 'UPI';
    final double paidAmount = args?['paidAmount'] ?? course.price;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
        titleSpacing: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.brandThreeColorGradient,
          ),
        ),
        title: const Text(
          'Enrollment Successful',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              // Success Checkmark Animation/Icon Container
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer dotted or clean decorative circle
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: AppTheme.accentGreen.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: AppTheme.accentGreen.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: AppTheme.accentGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 44,
                      ),
                    ),
                    // Small decorative colored dots (mocking confetti)
                    Positioned(
                      top: 10,
                      left: 20,
                      child: _buildConfettiDot(Colors.amber, 8),
                    ),
                    Positioned(
                      top: 25,
                      right: 15,
                      child: _buildConfettiDot(AppTheme.primaryBlue, 10),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 15,
                      child: _buildConfettiDot(Colors.purpleAccent, 6),
                    ),
                    Positioned(
                      bottom: 12,
                      right: 25,
                      child: _buildConfettiDot(Colors.orangeAccent, 8),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Congratulations text
              const Center(
                child: Text(
                  'Congratulations!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.accentGreen,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'You have successfully enrolled in\n${course.title}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryBlue,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Detail Info Card
              Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: AppTheme.borderLight, width: 0.8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      _buildDetailRow(
                        Icons.calendar_today_rounded,
                        'Enrollment Date',
                        _getFormattedDate(),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Divider(color: AppTheme.borderLight, height: 1),
                      ),
                      _buildDetailRow(
                        Icons.import_contacts_rounded,
                        'Access Type',
                        'Lifetime Access',
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Divider(color: AppTheme.borderLight, height: 1),
                      ),
                      _buildDetailRow(
                        Icons.access_time_filled_rounded,
                        'Start Learning',
                        'Start anytime',
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Divider(color: AppTheme.borderLight, height: 1),
                      ),
                      _buildDetailRow(
                        Icons.payment_rounded,
                        'Payment Details',
                        '$paymentMethod - \$${paidAmount.toStringAsFixed(2)}',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Buttons
              SizedBox(
                height: 52,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppTheme.brandBlueGreenGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate back to home or the course dashboard
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.home,
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Start Learning Now',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // Navigate directly to My Courses Screen, clearing stack back to Home
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MyCoursesScreen()),
                    (route) => route.isFirst,
                  );
                },
                child: const Text(
                  'Go to My Courses',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfettiDot(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.accentGreen.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: AppTheme.accentGreen,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w500,
            color: AppTheme.textMedium,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.bold,
            color: AppTheme.textDark,
          ),
        ),
      ],
    );
  }
}
