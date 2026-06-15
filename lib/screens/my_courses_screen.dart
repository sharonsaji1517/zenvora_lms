import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';

class MyCoursesScreen extends StatelessWidget {
  const MyCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Enrolled courses mock data list
    final List<Map<String, dynamic>> courses = [
      {
        'title': 'Oil & Gas Safety Fundamentals',
        'progress': 0.75,
        'category': 'Safety Operations',
        'instructor': 'Dr. Robert Carter',
      },
      {
        'title': 'Drilling Operations & Hydraulics 101',
        'progress': 0.40,
        'category': 'Drilling Operations',
        'instructor': 'Prof. Angela Miller',
      },
      {
        'title': 'Offshore Hazard Identification (HAZID)',
        'progress': 0.90,
        'category': 'Risk Auditing',
        'instructor': 'HSE Specialist Kim',
      },
      {
        'title': 'Petrochemical Refining and Processes',
        'progress': 0.15,
        'category': 'Technical Science',
        'instructor': 'Dr. Robert Carter',
      },
      {
        'title': 'Well Control Emergency Procedures',
        'progress': 0.60,
        'category': 'Drilling Operations',
        'instructor': 'Instructor Davis',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Enrolled Courses'),
      ),
      drawer: const CustomDrawer(activeItem: DrawerItem.myCourses),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          final progressVal = course['progress'] as double;
          final percentageText = '${(progressVal * 100).toInt()}% Completed';

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey[300]!, width: 0.8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Course tags
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          course['category']!,
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        course['instructor']!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Title
                  Text(
                    course['title']!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Progress bar and percentage
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Progress',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        percentageText,
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Linear progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progressVal,
                      minHeight: 8,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
