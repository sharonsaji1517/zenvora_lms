import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class InstructorsScreen extends StatelessWidget {
  const InstructorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instructors'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.groups_outlined,
                  size: 64,
                  color: AppTheme.primaryBlue,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Coming Soon',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Instructor module will be available in a future update.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
