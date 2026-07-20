import 'package:flutter/material.dart';
import '../widgets/reusable_course_card.dart';
import 'course_details_screen.dart';

class CategoryCoursesScreen extends StatelessWidget {
  final String categoryName;

  const CategoryCoursesScreen({
    super.key,
    required this.categoryName,
  });

  // Dummy data for courses in category
  final List<Map<String, dynamic>> _categoryCourses = const [
    {
      'title': 'Advanced Well Control',
      'image': 'assets/images/carousel/logistics2.jpg',
      'price': '\$149',
    },
    {
      'title': 'Offshore Safety Regulations',
      'image': 'assets/images/carousel/logistics3.jpg',
      'price': '\$89',
    },
    {
      'title': 'Pipeline Inspection Basics',
      'image': 'assets/images/carousel/logistics1.jpg',
      'price': '\$199',
    },
    {
      'title': 'HSE Risk Assessment',
      'image': 'assets/images/carousel/NZu2b.jpg',
      'price': '\$129',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF0F172A)),
        title: Text(
          categoryName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_categoryCourses.length} Courses Found',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75, // Adjust for course card dimensions
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _categoryCourses.length,
                itemBuilder: (context, index) {
                  final course = _categoryCourses[index];
                  return ReusableCourseCard(
                    title: course['title'],
                    imageUrl: course['image'],
                    price: course['price'],
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => 
                              CourseDetailsScreen(
                                title: course['title'],
                                imageUrl: course['image'],
                              ),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.easeInOutCubic;
                            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);
                            return SlideTransition(position: offsetAnimation, child: child);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
