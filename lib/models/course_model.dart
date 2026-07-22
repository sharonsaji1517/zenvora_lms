class CourseModel {
  final int id;
  final String name;
  final String slug;
  final String category;
  final int categoryId;
  final String fee;
  final int durationDays;
  final String courseType;
  final String shortDescription;
  final String? longDescription;
  final String? aboutCourse;
  final String? image;
  bool isFavorite;
  double progress;
  bool isEnrolled;

  CourseModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.category,
    required this.categoryId,
    required this.fee,
    required this.durationDays,
    required this.courseType,
    required this.shortDescription,
    this.longDescription,
    this.aboutCourse,
    this.image,
    this.isFavorite = false,
    this.progress = 0.0,
    this.isEnrolled = false,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] is int
          ? json['id']
          : (int.tryParse(json['id']?.toString() ?? '0') ?? 0),
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      categoryId: json['category_id'] is int
          ? json['category_id']
          : (int.tryParse(json['category_id']?.toString() ?? '0') ?? 0),
      fee: json['fee']?.toString() ?? '0',
      durationDays: json['duration_days'] is int
          ? json['duration_days']
          : (int.tryParse(json['duration_days']?.toString() ?? '0') ?? 0),
      courseType: json['course_type']?.toString() ?? '',
      shortDescription: json['short_description']?.toString() ?? '',
      longDescription: json['long_description']?.toString(),
      aboutCourse: json['about_course']?.toString(),
      image: json['image']?.toString(),
    );
  }

  // Getters for UI backward compatibility
  String get title => name;
  String get description => shortDescription;
  double get price => double.tryParse(fee) ?? 0.0;
  double get rating => 4.8;
  int get reviewCount => 120;
  String get imageUrl => image ?? '';
  bool get isRigAssociated => true;
  bool get isFeatured => true;
  List<String> get learnings => [
        'Master core concepts of $name',
        'Practical real-world safety & technical guidelines',
        'Compliance with industry standards and regulations',
      ];
  List get modules => [];
  List<String> get resources => [];
}
