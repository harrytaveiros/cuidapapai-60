class CareTaskModel {
  final String id;
  final String category;
  final String title;
  final String subtitle;
  bool isCompleted;
  final String colorHex;

  CareTaskModel({
    required this.id,
    required this.category,
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    required this.colorHex,
  });

  factory CareTaskModel.fromJson(Map<String, dynamic> json) {
    return CareTaskModel(
      id: json['id'] ?? '',
      category: json['category'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      isCompleted: json['is_completed'] ?? false,
      colorHex: json['color_hex'] ?? '#000000',
    );
  }
}
