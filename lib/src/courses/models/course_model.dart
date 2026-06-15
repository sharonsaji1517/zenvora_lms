import 'package:flutter/material.dart';

class CourseCategory {
  final String id;
  final String name;
  final IconData icon;

  const CourseCategory({
    required this.id,
    required this.name,
    required this.icon,
  });
}

class SyllabusItem {
  final String title;
  final String type; // 'video', 'pdf', 'quiz'
  final String durationOrSize;

  const SyllabusItem({
    required this.title,
    required this.type,
    required this.durationOrSize,
  });
}

class SyllabusModule {
  final String id;
  final String title;
  final List<SyllabusItem> items;

  const SyllabusModule({
    required this.id,
    required this.title,
    required this.items,
  });
}

class Course {
  final String id;
  final String title;
  final double rating;
  final int reviewCount;
  final double price;
  final String imageUrl;
  final bool isRigAssociated;
  final bool isFeatured;
  final String categoryId;
  final String description;
  final List<String> learnings;
  final List<SyllabusModule> modules;
  final List<String> resources;
  bool isEnrolled;
  double progress; // 0.0 to 1.0
  bool isFavorite;

  Course({
    required this.id,
    required this.title,
    required this.rating,
    required this.reviewCount,
    required this.price,
    required this.imageUrl,
    required this.isRigAssociated,
    required this.isFeatured,
    required this.categoryId,
    required this.description,
    required this.learnings,
    required this.modules,
    required this.resources,
    this.isEnrolled = false,
    this.progress = 0.0,
    this.isFavorite = false,
  });
}

// Global helper to get mock course categories matching zenvoradesign.jpg
List<CourseCategory> getMockCategories() {
  return const [
    CourseCategory(id: 'rig', name: 'Rig\nOperations', icon: Icons.filter_hdr_outlined),
    CourseCategory(id: 'safety', name: 'Safety', icon: Icons.construction_outlined),
    CourseCategory(id: 'technical', name: 'Technical', icon: Icons.settings_suggest_outlined),
    CourseCategory(id: 'hse', name: 'HSE\nFirst Aid', icon: Icons.local_hospital_outlined),
    CourseCategory(id: 'exploration', name: 'Exploration', icon: Icons.map_outlined),
    CourseCategory(id: 'management', name: 'Management', icon: Icons.people_outline),
  ];
}

// Global helper to get mock courses matching zenvoradesign.jpg
List<Course> getMockCourses() {
  final sampleSyllabus = [
    const SyllabusModule(
      id: 'm1',
      title: 'Module 1: Introduction to Drilling Safety',
      items: [
        SyllabusItem(title: 'Overview Video & Safety Protocol', type: 'video', durationOrSize: '12 mins'),
        SyllabusItem(title: 'HSE Drilling Standards Manual', type: 'pdf', durationOrSize: '4.2 MB'),
        SyllabusItem(title: 'Module 1 Safety Assessment Quiz', type: 'quiz', durationOrSize: '10 Questions'),
      ],
    ),
    const SyllabusModule(
      id: 'm2',
      title: 'Module 2: Equipment & Hazard Identification',
      items: [
        SyllabusItem(title: 'Drill String & Blowout Preventers (BOP)', type: 'video', durationOrSize: '18 mins'),
        SyllabusItem(title: 'BOP Inspection Checklist', type: 'pdf', durationOrSize: '1.8 MB'),
        SyllabusItem(title: 'BOP Emergency Drill Guidelines', type: 'video', durationOrSize: '15 mins'),
        SyllabusItem(title: 'Module 2 Assessment Quiz', type: 'quiz', durationOrSize: '15 Questions'),
      ],
    ),
    const SyllabusModule(
      id: 'm3',
      title: 'Module 3: Emergency Response Procedures',
      items: [
        SyllabusItem(title: 'Evacuation & Fire Safety Video', type: 'video', durationOrSize: '22 mins'),
        SyllabusItem(title: 'Offshore Disaster Management PDF', type: 'pdf', durationOrSize: '8.5 MB'),
        SyllabusItem(title: 'Final Emergency Protocol Quiz', type: 'quiz', durationOrSize: '20 Questions'),
      ],
    ),
  ];

  return [
    Course(
      id: 'c1',
      title: 'Oil & Gas Safety Fundamentals',
      rating: 4.8,
      reviewCount: 156,
      price: 89.99,
      imageUrl: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?auto=format&fit=crop&q=80&w=600',
      isRigAssociated: true,
      isFeatured: true,
      categoryId: 'safety',
      description: 'Master the fundamental safety practices required for successful oil and gas rig operations. This course covers personal protective equipment (PPE), hazard communication, fire safety, and emergency response procedures under offshore regulations. Essential training for all crew members heading to sea or field locations.',
      learnings: [
        'Understand fundamental offshore and onshore safety requirements',
        'Identify hazard zones, rig safety barriers, and gas environments',
        'Execute blowout prevention (BOP) and emergency protocols',
        'Follow OSHA & HSE standards for oilfield installations'
      ],
      modules: sampleSyllabus,
      resources: [
        'OSHA Standard PDF Guidelines.pdf',
        'Offshore Safety Cheat Sheet.pdf',
        'API RP 75 Recommended Practice.pdf'
      ],
      isFavorite: true,
      progress: 0.35,
    ),
    Course(
      id: 'c2',
      title: 'Drilling Operations 101',
      rating: 4.7,
      reviewCount: 92,
      price: 129.99,
      imageUrl: 'https://images.unsplash.com/photo-1541888946425-d81bb19240f5?auto=format&fit=crop&q=80&w=600',
      isRigAssociated: true,
      isFeatured: false,
      categoryId: 'rig',
      description: 'An introductory course covering the core aspects of drilling operations. Learn about drill bits, drilling muds, well control, casing design, and basic geological constraints encountered during exploration drilling.',
      learnings: [
        'Comprehend drill string components and mechanics',
        'Analyze drilling fluid roles and density checks',
        'Understand casing operations and cementation',
        'Perform wellbore trajectory control tasks'
      ],
      modules: sampleSyllabus.take(2).toList(),
      resources: [
        'Drilling String Reference Chart.pdf',
        'Mud Weight Calculation Sheets.pdf'
      ],
      progress: 0.70,
    ),
    Course(
      id: 'c3',
      title: 'Offshore Platform Safety',
      rating: 4.9,
      reviewCount: 210,
      price: 149.99,
      imageUrl: 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?auto=format&fit=crop&q=80&w=600',
      isRigAssociated: true,
      isFeatured: true,
      categoryId: 'safety',
      description: 'Comprehensive guidelines for operating and living safely on deepwater production platforms. Focuses on helicopter safety (HUET), lifeboats, marine communications, crane operations, and process safety barriers.',
      learnings: [
        'Conduct offshore permit-to-work procedures',
        'Respond to platform emergency shutdown signals',
        'Understand helicopter safety protocols',
        'Safely oversee heavy crane rigging lifts'
      ],
      modules: sampleSyllabus,
      resources: [
        'HUET Training Checklist.pdf',
        'Platform Layout & Fire Plan.pdf'
      ],
      isFavorite: false,
      progress: 0.12,
    ),
    Course(
      id: 'c4',
      title: 'HSE Standards & Compliance',
      rating: 4.6,
      reviewCount: 78,
      price: 79.99,
      imageUrl: 'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?auto=format&fit=crop&q=80&w=600',
      isRigAssociated: false,
      isFeatured: true,
      categoryId: 'hse',
      description: 'Focuses on global compliance standards including ISO 14001 and ISO 45001. Learn how to perform risk audits, register environmental impacts, and draft safety logs for legal compliance in oil and gas production.',
      learnings: [
        'Conduct a comprehensive HSE workplace risk audit',
        'Draft compliance reports for environmental protection agencies',
        'Utilize root cause analysis for incident investigation',
        'Track and log occupational health metrics'
      ],
      modules: sampleSyllabus.take(1).toList(),
      resources: [
        'ISO 45001 Compliance Template.xlsx',
        'Auditing Checklist PDF.pdf'
      ],
      isFavorite: false,
      progress: 0.0,
    ),
  ];
}
