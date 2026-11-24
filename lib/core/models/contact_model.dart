class ContactModel {
  final String id;
  final String name;
  final String relation;
  final String initials;
  final bool isProfessional;
  final String phone;
  final String avatarColorHex;

  ContactModel({
    required this.id,
    required this.name,
    required this.relation,
    required this.initials,
    required this.isProfessional,
    required this.phone,
    required this.avatarColorHex,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      relation: json['relation'] ?? '',
      initials: json['initials'] ?? '',
      isProfessional: json['is_professional'] ?? false,
      phone: json['phone'] ?? '',
      avatarColorHex: json['avatar_color_hex'] ?? '#000000',
    );
  }
}
