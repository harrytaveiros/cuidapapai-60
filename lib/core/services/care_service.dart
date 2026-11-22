import '../models/medication_model.dart';

/// Serviço responsável por gerenciar a rotina de cuidados do idoso.
class CareService {
  // Lista Mockada de medicamentos para o dia
  final List<MedicationModel> _medicamentos = [
    MedicationModel(
      id: '1',
      nome: 'Losartana',
      dosagem: '50mg',
      horario: '09:00',
      instrucoes: 'Após o café da manhã',
      isTaken: false,
    ),
    MedicationModel(
      id: '2',
      nome: 'Vitamina D',
      dosagem: '2000 UI',
      horario: '12:00',
      instrucoes: 'Junto com o almoço',
      isTaken: false,
    ),
  ];

  /// Retorna a lista completa
  List<MedicationModel> get medicamentos => _medicamentos;

  /// Retorna o próximo medicamento que ainda não foi tomado (isTaken == false).
  /// Se todos já foram tomados, retorna null.
  MedicationModel? get proximoMedicamento {
    try {
      return _medicamentos.firstWhere((med) => !med.isTaken);
    } catch (e) {
      return null;
    }
  }

  /// Marca um medicamento específico como tomado
  void marcarComoTomado(String id) {
    final index = _medicamentos.indexWhere((med) => med.id == id);
    if (index != -1) {
      _medicamentos[index].isTaken = true;
    }
  }
}
