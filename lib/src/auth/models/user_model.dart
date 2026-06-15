class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String? profileImageUrl;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.profileImageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'profileImageUrl': profileImageUrl,
    };
  }
}
