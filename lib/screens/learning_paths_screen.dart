import 'package:flutter/material.dart';
import '../widgets/custom_drawer.dart';

class LearningPathsScreen extends StatelessWidget {
  const LearningPathsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Learning Paths mock data
    final List<Map<String, dynamic>> paths = [
      {
        'title': 'HSE Specialist Certification',
        'duration': '40 hours',
        'coursesCount': 6,
        'description': 'Master safety regulations, environment audits, hazard mitigation and emergency drills.',
        'icon': Icons.security,
      },
      {
        'title': 'Offshore Drilling Engineer',
        'duration': '75 hours',
        'coursesCount': 12,
        'description': 'Advanced well control techniques, hydraulics, marine operations, and blowout prevention.',
        'icon': Icons.engineering,
      },
      {
        'title': 'Refinery Operator Trainee',
        'duration': '35 hours',
        'coursesCount': 5,
        'description': 'Essential process chemistry, mechanical systems, safety audits, and operational parameters.',
        'icon': Icons.opacity,
      },
      {
        'title': 'Rig Management Professional',
        'duration': '50 hours',
        'coursesCount': 8,
        'description': 'Leadership, resource management, global logistics compliance, and legal audit guidelines.',
        'icon': Icons.assignment,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning Paths'),
      ),
      drawer: const CustomDrawer(activeItem: DrawerItem.learningPaths),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: paths.length,
        itemBuilder: (context, index) {
          final path = paths[index];

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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon Badge
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          path['icon'] as IconData,
                          color: colorScheme.primary,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      // Title & details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              path['title']!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              path['description']!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Metadata and button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Info stats
                      Row(
                        children: [
                          Icon(Icons.schedule_outlined, color: Colors.grey[600], size: 16),
                          const SizedBox(width: 4),
                          Text(
                            path['duration']!,
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.layers_outlined, color: Colors.grey[600], size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${path['coursesCount']} courses',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      
                      // Explore Button
                      OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Exploring "${path['title']}" path details...'),
                              backgroundColor: colorScheme.primary,
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: colorScheme.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          minimumSize: const Size(80, 32),
                        ),
                        child: Text(
                          'Explore',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
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
