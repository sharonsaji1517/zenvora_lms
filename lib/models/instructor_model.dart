import 'dart:convert';

class CareerMilestoneItem {
  final String? period;
  final String description;

  const CareerMilestoneItem({
    this.period,
    required this.description,
  });

  factory CareerMilestoneItem.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      final period = json['period']?.toString() ??
          json['year']?.toString() ??
          json['time']?.toString() ??
          json['title']?.toString();
      final desc = json['desc']?.toString() ??
          json['description']?.toString() ??
          json['text']?.toString() ??
          '';
      return CareerMilestoneItem(
        period: (period != null && period.trim().isNotEmpty) ? period.trim() : null,
        description: desc.trim(),
      );
    } else if (json is String) {
      return CareerMilestoneItem(description: json.trim());
    }
    return CareerMilestoneItem(description: json.toString());
  }
}

class QualificationModelItem {
  final String title;
  final String? subtitle;
  final String? color;

  const QualificationModelItem({
    required this.title,
    this.subtitle,
    this.color,
  });

  factory QualificationModelItem.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      final title = json['title']?.toString() ?? json['name']?.toString() ?? '';
      final desc = json['desc']?.toString() ??
          json['description']?.toString() ??
          json['subtitle']?.toString();
      final color = json['color']?.toString();
      return QualificationModelItem(
        title: title.trim(),
        subtitle: (desc != null && desc.trim().isNotEmpty) ? desc.trim() : null,
        color: color?.trim(),
      );
    } else if (json is String) {
      return QualificationModelItem(title: json.trim());
    }
    return QualificationModelItem(title: json.toString());
  }
}

class InstructorModel {
  final int id;
  final String name;
  final String? role;
  final String? designation;
  final String? photo;
  final String? bio;
  final String? experience;
  final String? specialization;
  final String? linkedin;
  final String? email;
  final int? order;
  final String? professionalProfile;
  final List<CareerMilestoneItem> careerJourney;
  final List<QualificationModelItem> qualifications;

  InstructorModel({
    required this.id,
    required this.name,
    this.role,
    this.designation,
    this.photo,
    this.bio,
    this.experience,
    this.specialization,
    this.linkedin,
    this.email,
    this.order,
    this.professionalProfile,
    this.careerJourney = const [],
    this.qualifications = const [],
  });

  factory InstructorModel.fromJson(Map<String, dynamic> json) {
    return InstructorModel(
      id: json['id'] is int
          ? json['id']
          : (int.tryParse(json['id']?.toString() ?? '0') ?? 0),
      name: json['name']?.toString() ?? '',
      role: _parseNullableString(json['role']),
      designation: _parseNullableString(json['designation']),
      photo: _parseNullableString(json['photo']),
      bio: _parseNullableString(json['bio']),
      experience: _parseNullableString(json['experience']),
      specialization: _parseNullableString(json['specialization']),
      linkedin: _parseNullableString(json['linkedin']),
      email: _parseNullableString(json['email']),
      order: json['order'] is int
          ? json['order']
          : int.tryParse(json['order']?.toString() ?? ''),
      professionalProfile: _parseNullableString(json['professional_profile']),
      careerJourney: _parseCareerJourney(json['career_journey']),
      qualifications: _parseQualifications(json['qualifications']),
    );
  }

  static String? _parseNullableString(dynamic val) {
    if (val == null) return null;
    final str = val.toString().trim();
    if (str.isEmpty || str.toLowerCase() == 'null') return null;
    return str;
  }

  static List<CareerMilestoneItem> _parseCareerJourney(dynamic raw) {
    if (raw == null) return [];
    try {
      dynamic parsed = raw;
      if (raw is String) {
        final trimmed = raw.trim();
        if (trimmed.isEmpty || trimmed == '[]' || trimmed == 'null') return [];
        parsed = jsonDecode(trimmed);
      }
      if (parsed is List) {
        return parsed
            .map((item) => CareerMilestoneItem.fromJson(item))
            .where((item) => item.description.isNotEmpty || (item.period != null && item.period!.isNotEmpty))
            .toList();
      }
    } catch (_) {
      if (raw is String && raw.trim().isNotEmpty && raw.trim() != '[]') {
        return [CareerMilestoneItem(description: raw.trim())];
      }
    }
    return [];
  }

  static List<QualificationModelItem> _parseQualifications(dynamic raw) {
    if (raw == null) return [];
    try {
      dynamic parsed = raw;
      if (raw is String) {
        final trimmed = raw.trim();
        if (trimmed.isEmpty || trimmed == '[]' || trimmed == 'null') return [];
        parsed = jsonDecode(trimmed);
      }
      if (parsed is List) {
        return parsed
            .map((item) => QualificationModelItem.fromJson(item))
            .where((item) => item.title.isNotEmpty || (item.subtitle != null && item.subtitle!.isNotEmpty))
            .toList();
      }
    } catch (_) {
      if (raw is String && raw.trim().isNotEmpty && raw.trim() != '[]') {
        return [QualificationModelItem(title: raw.trim())];
      }
    }
    return [];
  }

  String get displayDesignation {
    if (designation != null && designation!.isNotEmpty) {
      return designation!;
    }
    if (role != null && role!.isNotEmpty) {
      return role!;
    }
    return 'Instructor';
  }
}
