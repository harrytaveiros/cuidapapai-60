/// Modelo que representa um medicamento na rotina do idoso.
class MedicationModel {
  final String id;
  final String nome;
  final String dosagem;
  final String horario;
  final String instrucoes; // Ex: "Após o café"
  bool isTaken; // Controla se o idoso já tomou o remédio

  MedicationModel({
    required this.id,
    required this.nome,
    required this.dosagem,
    required this.horario,
    this.instrucoes = '',
    this.isTaken = false,
  });

  /// Helper para exibir o nome e dosagem de forma unificada
  String get tituloExibicao => '$nome $dosagem';
}
