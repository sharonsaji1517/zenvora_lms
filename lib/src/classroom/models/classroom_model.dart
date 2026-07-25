class ClassroomCourseModel {
  final int? id;
  final String courseName;
  final String? courseFee;
  final String? duration;
  final String? courseType;
  final String? thumbnail;

  ClassroomCourseModel({
    this.id,
    required this.courseName,
    this.courseFee,
    this.duration,
    this.courseType,
    this.thumbnail,
  });

  factory ClassroomCourseModel.fromJson(Map<String, dynamic> json) {
    return ClassroomCourseModel(
      id: json['id'] is int
          ? json['id'] as int
          : (json['id'] != null ? int.tryParse(json['id'].toString()) : null),
      courseName:
          json['course_name']?.toString() ??
          json['name']?.toString() ??
          json['title']?.toString() ??
          'Enrolled Course',
      courseFee:
          json['course_fee']?.toString() ??
          json['fee']?.toString() ??
          json['price']?.toString(),
      duration: json['duration']?.toString(),
      courseType: json['course_type']?.toString() ?? json['type']?.toString(),
      thumbnail:
          json['thumbnail']?.toString() ??
          json['image']?.toString() ??
          json['course_image']?.toString(),
    );
  }
}

class ClassroomVideoModel {
  final int? id;
  final String title;
  final String? url;

  ClassroomVideoModel({this.id, required this.title, this.url});

  factory ClassroomVideoModel.fromJson(Map<String, dynamic> json) {
    return ClassroomVideoModel(
      id: json['id'] is int
          ? json['id'] as int
          : (json['id'] != null ? int.tryParse(json['id'].toString()) : null),
      title:
          json['title']?.toString() ??
          json['name']?.toString() ??
          'Video Lesson',
      url:
          json['url']?.toString() ??
          json['video_url']?.toString() ??
          json['file']?.toString(),
    );
  }
}

class ClassroomPdfModel {
  final int? id;
  final String title;
  final String? url;

  ClassroomPdfModel({this.id, required this.title, this.url});

  factory ClassroomPdfModel.fromJson(Map<String, dynamic> json) {
    return ClassroomPdfModel(
      id: json['id'] is int
          ? json['id'] as int
          : (json['id'] != null ? int.tryParse(json['id'].toString()) : null),
      title:
          json['title']?.toString() ??
          json['name']?.toString() ??
          'PDF Document',
      url:
          json['url']?.toString() ??
          json['pdf_url']?.toString() ??
          json['file']?.toString(),
    );
  }
}

class ClassroomPptModel {
  final int? id;
  final String title;
  final String? url;

  ClassroomPptModel({this.id, required this.title, this.url});

  factory ClassroomPptModel.fromJson(Map<String, dynamic> json) {
    return ClassroomPptModel(
      id: json['id'] is int
          ? json['id'] as int
          : (json['id'] != null ? int.tryParse(json['id'].toString()) : null),
      title:
          json['title']?.toString() ??
          json['name']?.toString() ??
          'PPT Presentation',
      url:
          json['url']?.toString() ??
          json['ppt_url']?.toString() ??
          json['file']?.toString(),
    );
  }
}

class ClassroomYoutubeLinkModel {
  final int? id;
  final String title;
  final String? url;

  ClassroomYoutubeLinkModel({this.id, required this.title, this.url});

  factory ClassroomYoutubeLinkModel.fromJson(Map<String, dynamic> json) {
    return ClassroomYoutubeLinkModel(
      id: json['id'] is int
          ? json['id'] as int
          : (json['id'] != null ? int.tryParse(json['id'].toString()) : null),
      title:
          json['title']?.toString() ??
          json['name']?.toString() ??
          'YouTube Video',
      url:
          json['url']?.toString() ??
          json['youtube_url']?.toString() ??
          json['link']?.toString(),
    );
  }
}

class ClassroomPrivateVideoModel {
  final int? id;
  final String title;
  final String? url;

  ClassroomPrivateVideoModel({this.id, required this.title, this.url});

  factory ClassroomPrivateVideoModel.fromJson(Map<String, dynamic> json) {
    return ClassroomPrivateVideoModel(
      id: json['id'] is int
          ? json['id'] as int
          : (json['id'] != null ? int.tryParse(json['id'].toString()) : null),
      title:
          json['title']?.toString() ??
          json['name']?.toString() ??
          'Private Video',
      url:
          json['url']?.toString() ??
          json['video_url']?.toString() ??
          json['file']?.toString(),
    );
  }
}

class ClassroomModel {
  final bool success;
  final ClassroomCourseModel? course;
  final List<ClassroomVideoModel> videos;
  final List<ClassroomPdfModel> pdfs;
  final List<ClassroomPptModel> ppts;
  final List<ClassroomYoutubeLinkModel> youtubeLinks;
  final List<ClassroomPrivateVideoModel> privateVideos;

  ClassroomModel({
    required this.success,
    this.course,
    this.videos = const [],
    this.pdfs = const [],
    this.ppts = const [],
    this.youtubeLinks = const [],
    this.privateVideos = const [],
  });

  factory ClassroomModel.fromJson(Map<String, dynamic> json) {
    final courseData = json['course'] as Map<String, dynamic>?;

    final videosList = courseData?['videos'] as List<dynamic>? ?? [];
    final pdfsList = courseData?['pdfs'] as List<dynamic>? ?? [];
    final pptsList = courseData?['ppts'] as List<dynamic>? ?? [];
    final youtubeList = courseData?['youtube_links'] as List<dynamic>? ?? [];
    final privateVideosList =
        courseData?['private_videos'] as List<dynamic>? ?? [];

    return ClassroomModel(
      success: json['success'] == true,
      course: courseData != null
          ? ClassroomCourseModel.fromJson(courseData)
          : null,
      videos: videosList.map((e) => ClassroomVideoModel.fromJson(e)).toList(),
      pdfs: pdfsList.map((e) => ClassroomPdfModel.fromJson(e)).toList(),
      ppts: pptsList.map((e) => ClassroomPptModel.fromJson(e)).toList(),
      youtubeLinks: youtubeList
          .map((e) => ClassroomYoutubeLinkModel.fromJson(e))
          .toList(),
      privateVideos: privateVideosList
          .map((e) => ClassroomPrivateVideoModel.fromJson(e))
          .toList(),
    );
  }
}
