import 'package:flutter/material.dart';

class TimelineEventCard extends StatelessWidget {
  final Color bulletColor;
  final String dayOfWeek;
  final String dayNumber;
  final String time;
  final String title;
  final String subtitle;

  const TimelineEventCard({
    super.key,
    required this.bulletColor,
    required this.dayOfWeek,
    required this.dayNumber,
    required this.time,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBgColor = isDark ? Colors.grey[900] : Colors.white;
    const azulMarinho = Color(0xFF000080);
    final titleColor = isDark ? Colors.white : azulMarinho;
    final timeColor = Theme.of(context).primaryColor; // Adapta ao tema (Verde ou Vermelho)

    // IntrinsicHeight faz com que a linha do tempo estique exatamente
    // até a altura que o Card ao lado decidir ter, mantendo tudo alinhado.
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. COLUNA DA LINHA DO TEMPO
          SizedBox(
            width: 40,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Linha Vertical Cinza Contínua
                Container(
                  width: 2,
                  color: isDark ? Colors.grey[800] : Colors.grey.shade300,
                ),
                // Círculo (Bullet) Duplo
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black : Colors.white, // Miolo
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: bulletColor, // Cor dinâmica passada via parâmetro
                      width: 4, // Espessura da borda cria o efeito de "anel"
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // 2. COLUNA DO CARD DO EVENTO
          Expanded(
            child: Padding(
              // Um padding vertical para dar respiro entre os cards de uma lista
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        // Bloco da Data (Esquerda)
                        SizedBox(
                          width: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                dayOfWeek.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              Text(
                                dayNumber,
                                style: TextStyle(
                                  color: titleColor,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  height: 1.1,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Divisória Vertical Fina
                        VerticalDivider(
                          width: 32,
                          thickness: 1,
                          color: isDark ? Colors.grey[800] : Colors.grey.shade200,
                        ),

                        // Detalhes do Evento (Direita)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Horário
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 14,
                                    color: timeColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    time,
                                    style: TextStyle(
                                      color: timeColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),

                              // Título
                              Text(
                                title,
                                style: TextStyle(
                                  color: titleColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  height: 1.2,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),

                              // Subtítulo
                              Text(
                                subtitle,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
