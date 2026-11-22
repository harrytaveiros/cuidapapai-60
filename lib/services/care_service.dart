import '../features/rotina/model/medication_model.dart';

/// Serviço responsável por gerenciar a rotina de cuidados e medicamentos.
class CareService {
  // Base de dados Mock em memória
  final List<MedicationModel> _medicamentos = [
    MedicationModel(
      id: '1',
      nome: 'Losartana',
      dosagem: '50mg',
      horario: '09:00',
      instrucoes: 'Após o café da manhã',
      statusTomado: false,
    ),
    MedicationModel(
      id: '2',
      nome: 'Vitamina D',
      dosagem: '2000 UI',
      horario: '12:30',
      instrucoes: 'Junto com o almoço',
      statusTomado: false,
    ),
  ];

  /// Retorna todos os medicamentos do dia
  List<MedicationModel> get medicamentos => _medicamentos;

  /// Retorna o próximo medicamento que ainda não foi tomado
  MedicationModel? get proximoMedicamento {
    try {
      // Retorna o primeiro medicamento cujo statusTomado seja false
      return _medicamentos.firstWhere((med) => !med.statusTomado);
    } catch (e) {
      // Se não encontrar nenhum (todos tomados), retorna null
      return null;
    }
  }

  /// Marca um medicamento como tomado
  void registrarMedicamentoTomado(String id) {
    final index = _medicamentos.indexWhere((med) => med.id == id);
    if (index != -1) {
      _medicamentos[index].statusTomado = true;
    }
  }
}
