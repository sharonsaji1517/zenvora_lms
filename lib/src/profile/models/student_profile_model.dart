class StudentProfileModel {
  final int? id;
  final String name;
  final String email;
  final String? phone;
  final String? place;
  final String? status;

  StudentProfileModel({
    this.id,
    required this.name,
    required this.email,
    this.phone,
    this.place,
    this.status,
  });

  factory StudentProfileModel.fromJson(Map<String, dynamic> json) {
    return StudentProfileModel(
      id: json['id'] is int
          ? json['id'] as int
          : (json['id'] != null ? int.tryParse(json['id'].toString()) : null),
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      place: json['place']?.toString(),
      status: json['status']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'place': place,
      'status': status,
    };
  }
}
