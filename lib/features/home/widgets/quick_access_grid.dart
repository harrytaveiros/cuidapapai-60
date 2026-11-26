import 'package:flutter/material.dart';

import '../../forms/add_appointment_screen.dart';
import '../../forms/add_medication_screen.dart';
import '../../forms/add_caregiver_screen.dart';

class QuickAccessGrid extends StatelessWidget {
  const QuickAccessGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - 16) / 2;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            QuickAccessItem(
              icon: Icons.calendar_month,
              title: 'Nova consulta',
              width: itemWidth,
              accentColor: const Color(0xFF0D47A1), // Azul Escuro
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddAppointmentScreen()),
                );
              },
            ),
            QuickAccessItem(
              icon: Icons.alarm_add,
              title: 'Lembrete de\nremédio',
              width: itemWidth,
              accentColor: const Color(0xFFF39C12), // Amarelo
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddMedicationScreen()),
                );
              },
            ),
            QuickAccessItem(
              icon: Icons.monitor_heart,
              title: 'Registrar\ncuidado',
              width: itemWidth,
              accentColor: const Color(0xFF126E51), // Verde Escuro
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Redirecionando para a aba de Cuidados...',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            QuickAccessItem(
              icon: Icons.person_search,
              title: 'Buscar\ncuidador',
              width: itemWidth,
              accentColor: const Color(0xFF00BCD4), // Ciano
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddCaregiverScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class QuickAccessItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final double width;
  final Color accentColor;
  final VoidCallback onTap;

  const QuickAccessItem({
    super.key,
    required this.icon,
    required this.title,
    required this.width,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? Colors.grey[900] : Colors.white;
    // O texto será Azul Marinho Escuro no modo claro, ou Branco no modo escuro
    final textColor = isDark ? Colors.white : const Color(0xFF000080);

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      // O ClipRRect garante que os cantos arredondados sejam mantidos,
      // mesmo desenhando uma borda apenas no lado esquerdo dentro dele.
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: accentColor,
                    width: 4,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start, // Alinha os itens à esquerda (Figma)
                children: [
                  // Ícone no Quadrado Arredondado
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon,
                      color: accentColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Texto do Card
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
