import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  final String name;
  final String relation;
  final String initials;
  final Color avatarColor;
  final bool isProfessional;
  final VoidCallback? onCall;

  const ContactCard({
    super.key,
    required this.name,
    required this.relation,
    required this.initials,
    required this.avatarColor,
    this.isProfessional = false,
    this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Cores Adaptativas (Figma)
    final bgColor = isDark ? Colors.grey[900] : Colors.white;
    const azulMarinho = Color(0xFF000080);
    final titleColor = isDark ? Colors.white : azulMarinho;
    final subtitleColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    // Cor fixa para tag do profissional (Azul Ciano)
    const cianoColor = Color(0xFF00BCD4);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          // Ao tocar no card inteiro, também pode acionar a ligação (Facilita p/ idosos)
          onTap: onCall,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // 1. AVATAR (Esquerda)
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: avatarColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isProfessional
                        ? Icon(
                            Icons.person,
                            color: isDark ? Colors.white : azulMarinho,
                            size: 28,
                          )
                        : Text(
                            initials.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 16),

                // 2. TEXTOS CENTRAIS
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Tag Opcional (Disponível Hoje)
                      if (isProfessional) ...[
                        Text(
                          'DISPONÍVEL HOJE',
                          style: TextStyle(
                            color: cianoColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 2),
                      ],
                      // Nome
                      Text(
                        name,
                        style: TextStyle(
                          color: titleColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Relação / Cargo
                      Text(
                        relation,
                        style: TextStyle(
                          color: subtitleColor,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // 3. BOTÃO DE LIGAÇÃO (Direita)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.phone,
                    color: theme.primaryColor,
                    size: 26,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
