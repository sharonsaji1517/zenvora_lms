class SliderModel {
  final int id;
  final String title;
  final String image;
  final int order;

  SliderModel({
    required this.id,
    required this.title,
    required this.image,
    required this.order,
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      id: json['id'] is int
          ? json['id']
          : (int.tryParse(json['id']?.toString() ?? '0') ?? 0),
      title: json['title']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      order: json['order'] is int
          ? json['order']
          : (int.tryParse(json['order']?.toString() ?? '0') ?? 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'order': order,
    };
  }
}
