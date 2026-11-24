import 'package:flutter/material.dart';
import '../../../core/models/medication_model.dart';
import '../../../core/theme/app_theme.dart';

class NextMedicationCard extends StatelessWidget {
  final MedicationModel? medication;
  final VoidCallback onMarkAsTaken;

  const NextMedicationCard({
    super.key,
    required this.medication,
    required this.onMarkAsTaken,
  });

  @override
  Widget build(BuildContext context) {
    final proximoMed = medication;
    final primaryColor = Theme.of(context).primaryColor;

    // ESTADO 1: Não há próximos medicamentos (Tudo tomado)
    if (proximoMed == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: primaryColor, width: 2),
        ),
        child: Column(
          children: [
            Icon(Icons.sentiment_very_satisfied, size: 64, color: primaryColor),
            const SizedBox(height: 16),
            Text(
              'Tudo certo!\nVocê já tomou todos os remédios programados para agora.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ],
        ),
      );
    }

    // ESTADO 2: Exibir o Card do Próximo Medicamento com Gradiente
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.gradientStart,
            AppColors.gradientEnd,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Topo Esquerda: Ícone de Pílula no Círculo Translúcido
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2), // Fundo circular translúcido
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.medication,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(width: 20),

              // Topo Direita: Informações de Texto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PRÓXIMO MEDICAMENTO',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      proximoMed.tituloExibicao,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Hoje, às ${proximoMed.horario}\n${proximoMed.instrucoes}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Base: Botão Largo de Ação Primária
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: primaryColor,
              minimumSize: const Size(double.infinity, 72),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: const Icon(Icons.check_circle, size: 36),
            label: const Text(
              'Marcar como tomado',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: onMarkAsTaken, // Recebe a função do componente pai
          ),
        ],
      ),
    );
  }
}
