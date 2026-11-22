/// Modelo de dados representando um Medicamento.
/// Fica isolado da lógica de negócios, focado apenas em estruturar a informação.
class MedicationModel {
  final String id;
  final String nome;
  final String dosagem;
  final String horario;
  final String instrucoes;
  bool statusTomado;

  MedicationModel({
    required this.id,
    required this.nome,
    required this.dosagem,
    required this.horario,
    this.instrucoes = '',
    this.statusTomado = false,
  });

  /// Retorna uma representação amigável do medicamento para leitura por idosos.
  String get descricaoCompleta => '$nome $dosagem';
}
