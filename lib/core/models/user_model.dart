class UserModel {
  final String id;
  final String name;
  final String shortName;
  final String role;
  final UserPreferences preferences;

  UserModel({
    required this.id,
    required this.name,
    required this.shortName,
    required this.role,
    required this.preferences,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      shortName: json['short_name'] ?? '',
      role: json['role'] ?? '',
      preferences: UserPreferences.fromJson(json['preferences'] ?? {}),
    );
  }
}

class UserPreferences {
  final String theme;
  final String fontSize;

  UserPreferences({
    required this.theme,
    required this.fontSize,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      theme: json['theme'] ?? 'light',
      fontSize: json['font_size'] ?? 'large',
    );
  }
}
