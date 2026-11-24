class AppointmentModel {
  final String id;
  final String date;
  final String dayOfWeekShort;
  final String dayNumber;
  final String time;
  final String title;
  final String subtitle;
  final String colorHex;

  AppointmentModel({
    required this.id,
    required this.date,
    required this.dayOfWeekShort,
    required this.dayNumber,
    required this.time,
    required this.title,
    required this.subtitle,
    required this.colorHex,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] ?? '',
      date: json['date'] ?? '',
      dayOfWeekShort: json['day_of_week_short'] ?? '',
      dayNumber: json['day_number'] ?? '',
      time: json['time'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      colorHex: json['color_hex'] ?? '#000000',
    );
  }
}
