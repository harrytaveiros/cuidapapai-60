import 'package:flutter/material.dart';

class CareTaskCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool isCompleted;
  final VoidCallback onTap; // Parâmetro obrigatório para interatividade

  const CareTaskCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark ? Colors.grey[900] : Colors.white;
    const azulMarinho = Color(0xFF000080);
    final titleColor = isDark ? Colors.white : azulMarinho;
    final subtitleColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    // Envolvendo o componente em um Container com Sombra, e um Material+Inkwell
    // na raiz clicável para garantir o efeito visual de toque nativo (Ripple) no formato correto.
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // 1. ÍCONE ESQUERDA
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),

                // 2. TEXTOS CENTRAIS
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: titleColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: subtitleColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // 3. INDICADOR DE CONCLUSÃO DIREITA
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isCompleted ? theme.primaryColor : Colors.transparent,
                    shape: BoxShape.circle,
                    border: isCompleted
                        ? null
                        : Border.all(color: Colors.grey.shade300, width: 2),
                  ),
                  child: isCompleted
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 20,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
