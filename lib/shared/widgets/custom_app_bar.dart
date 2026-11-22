import 'package:flutter/material.dart';
import '../../core/theme/theme_manager.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title; // Mantido para compatibilidade, mas substituído pelo logo visual

  const CustomAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final themeManager = ThemeManager();
    final primaryColor = Theme.of(context).primaryColor;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    return AppBar(
      backgroundColor: primaryColor,
      centerTitle: true,
      elevation: 0,

      // TAREFA 1 e 2: Row centralizada com o Ícone Quadrado e o RichText
      title: Row(
        mainAxisSize: MainAxisSize.min, // Garante que a Row não ocupe a tela toda e fique centralizada
        children: [
          // Container Quadrado Amarelo
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(10), // Cantos arredondados
            ),
            child: Icon(
              Icons.favorite_border,
              color: primaryColor, // Verde escuro (ou a cor primária dinâmica)
              size: 24,
            ),
          ),
          const SizedBox(width: 12),

          // Texto CuidaPapai+60 com duas cores
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
              children: [
                const TextSpan(
                  text: 'CuidaPapai',
                  style: TextStyle(color: Colors.white),
                ),
                TextSpan(
                  text: '+60',
                  style: TextStyle(color: secondaryColor), // Amarelo
                ),
              ],
            ),
          ),
        ],
      ),

      // TAREFA 3 e 4: Botões com borda fina e Badge de Notificação
      actions: [
        // Botão de Tema (Lua/Sol)
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white54, width: 1),
          ),
          child: IconButton(
            icon: Icon(
              themeManager.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              color: Colors.white,
              size: 22,
            ),
            tooltip: 'Alternar tema',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(), // Reduz o padding extra do IconButton
            onPressed: () {
              themeManager.toggleTheme();
            },
          ),
        ),

        // Botão de Sino com Badge
        Container(
          margin: const EdgeInsets.only(top: 8, bottom: 8, right: 16, left: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white54, width: 1),
          ),
          child: IconButton(
            tooltip: 'Notificações',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                  size: 24,
                ),
                // Badge de notificação (Bolinha Amarela)
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      shape: BoxShape.circle,
                      // Pequena borda da cor de fundo para "recortar" visualmente o sino
                      border: Border.all(color: primaryColor, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {},
          ),
        ),
      ],

      // TAREFA 5: Linha divisória inferior amarela
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(3), // Altura de 3 pixels
        child: Container(
          height: 3,
          width: double.infinity,
          color: secondaryColor,
        ),
      ),
    );
  }

  // Adiciona os 3 pixels da barra inferior ao tamanho padrão da AppBar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 3);
}
