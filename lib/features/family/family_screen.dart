import 'package:flutter/material.dart';
import 'widgets/contact_card.dart';

class FamilyScreen extends StatelessWidget {
  const FamilyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Cores Principais
    const azulMarinho = Color(0xFF000080);
    final primaryColor = theme.primaryColor;
    final secondaryColor = theme.colorScheme.secondary;

    // Cores Adaptativas (Light/Dark Mode)
    final textColor = isDark ? Colors.white : azulMarinho;
    final bgIconColor = isDark ? Colors.grey[800] : secondaryColor.withValues(alpha: 0.2);
    final iconColor = isDark ? Colors.white : const Color(0xFFD48B00); // Laranja/Dourado

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. CABEÇALHO DA PÁGINA
            Row(
              children: [
                // Ícone quadrado de Grupos (Amarelo)
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: bgIconColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.groups,
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
                      'REDE DE APOIO',
                      style: TextStyle(
                        color: isDark ? secondaryColor : azulMarinho.withValues(alpha: 0.8),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      'Família e cuidadores',
                      style: theme.textTheme.displayMedium?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w900,
                        fontSize: 28, // Um pouco menor para caber numa linha só
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 32),

            // 2. BANNER DE ACOLHIMENTO
            Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[900] : const Color(0xFFFFF8E1), // Fundo Amarelo Muito Claro
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: azulMarinho, // Fita lateral
                        width: 6,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Ícone de Acolhimento
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.favorite_border,
                          color: isDark ? Colors.black : const Color(0xFFD48B00), // Dourado Escuro
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Texto de Acolhimento
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Você não está sozinho',
                              style: TextStyle(
                                color: isDark ? Colors.white : const Color(0xFF8D6E63), // Marrom/Dourado
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Sua rede recebe as atualizações importantes.',
                              style: TextStyle(
                                color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // 3. SEÇÃO: FAMILIARES
            Text(
              'Familiares',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 16),

            ContactCard(
              name: 'Mariana Costa',
              relation: 'Filha · Administradora',
              initials: 'MC',
              avatarColor: primaryColor, // Verde Escuro do Tema
              onCall: () {},
            ),
            ContactCard(
              name: 'João Pedro',
              relation: 'Neto · Acompanhante',
              initials: 'JP',
              avatarColor: const Color(0xFF0D47A1), // Azul Escuro
              onCall: () {},
            ),

            const SizedBox(height: 32),

            // 4. SEÇÃO: CUIDADORA RESPONSÁVEL
            Text(
              'Cuidadora responsável',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 16),

            ContactCard(
              name: 'Ana Paula',
              relation: 'Cuidadora profissional · 4,9',
              initials: '', // Initials ignoradas pelo isProfessional
              avatarColor: const Color(0xFF00BCD4), // Ciano
              isProfessional: true,
              onCall: () {},
            ),

            const SizedBox(height: 32),

            // 5. BOTÃO "ENCONTRAR OUTRO CUIDADOR"
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryColor, // Cor do texto e efeito
                side: BorderSide(color: primaryColor, width: 2), // Borda espessa
                minimumSize: const Size(double.infinity, 64), // Altura acessível
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_search, size: 28),
                  SizedBox(width: 8),
                  Text(
                    'Encontrar outro cuidador',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48), // Respiro para o bottom navigation
          ],
        ),
      ),
    );
  }
}
