/// Modelo que representa um medicamento na rotina do idoso.
class MedicationModel {
  final String id;
  final String nome; // Mapeado de 'name'
  final String dosagem; // Mapeado de 'dosage'
  final String horario; // Mapeado de 'time'
  final String instrucoes; // Mapeado de 'instructions'
  bool isTaken; // Mapeado de 'is_taken'

  MedicationModel({
    required this.id,
    required this.nome,
    required this.dosagem,
    required this.horario,
    this.instrucoes = '',
    this.isTaken = false,
  });

  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    return MedicationModel(
      id: json['id'] ?? '',
      nome: json['name'] ?? '',
      dosagem: json['dosage'] ?? '',
      horario: json['time'] ?? '',
      instrucoes: json['instructions'] ?? '',
      isTaken: json['is_taken'] ?? false,
    );
  }

  /// Helper para exibir o nome e dosagem de forma unificada
  String get tituloExibicao => '$nome $dosagem';
}
