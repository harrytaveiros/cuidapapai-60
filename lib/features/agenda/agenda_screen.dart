import 'package:flutter/material.dart';
import 'widgets/timeline_event_card.dart';

class AgendaScreen extends StatelessWidget {
  const AgendaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    const azulMarinho = Color(0xFF000080);
    const cianoColor = Color(0xFF00BCD4);

    // Suporte ao tema escuro
    final isDark = themeData.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : azulMarinho;
    final bgIconColor = isDark ? Colors.grey[800] : const Color(0xFFE0E7FF);
    final iconColor = isDark ? Colors.white : azulMarinho;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. CABEÇALHO DA PÁGINA
            Row(
              children: [
                // Ícone quadrado de Calendário
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: bgIconColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.calendar_month,
                    color: iconColor,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),

                // Textos do Cabeçalho
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ORGANIZAÇÃO',
                      style: TextStyle(
                        color: isDark ? cianoColor : azulMarinho.withValues(alpha: 0.8),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      'Minha agenda',
                      style: themeData.textTheme.displayMedium?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 32,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),

            // 2. BOTÃO NOVO COMPROMISSO
            ElevatedButton(
              onPressed: () {
                // Ação para criar compromisso
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: themeData.primaryColor, // Verde do tema
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 64), // Altura acessível
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: 28),
                  SizedBox(width: 8),
                  Text(
                    'Novo compromisso',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // 3. TÍTULO DE SEÇÃO "ESTA SEMANA"
            Text(
              'Esta semana',
              style: themeData.textTheme.bodyLarge?.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 16),

            // 4. LISTA DE COMPROMISSOS (Timeline)
            // 4.1 Cardiologista
            const TimelineEventCard(
              bulletColor: azulMarinho, // Azul Marinho Escuro
              dayOfWeek: 'QUA',
              dayNumber: '14',
              time: '10:30',
              title: 'Consulta com cardiologista',
              subtitle: 'Clínica São Lucas - Dr. Roberto',
            ),

            // 4.2 Fisioterapia
            const TimelineEventCard(
              bulletColor: Color(0xFFF39C12), // Amarelo Escuro/Mostarda
              dayOfWeek: 'SEX',
              dayNumber: '16',
              time: '15:00',
              title: 'Sessão de fisioterapia',
              subtitle: 'Atendimento em casa (Sala)',
            ),

            // 4.3 Almoço em família
            const TimelineEventCard(
              bulletColor: Color(0xFF126E51), // Verde Escuro (Primário)
              dayOfWeek: 'SÁB',
              dayNumber: '17',
              time: '12:00',
              title: 'Almoço em família',
              subtitle: 'Casa da Juliana - Av. Brasil, 400',
            ),

            // Espaçamento final
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
