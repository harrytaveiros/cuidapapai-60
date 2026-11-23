import 'package:flutter/material.dart';
import '../../core/theme/theme_manager.dart';
import '../../features/profile/profile_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

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

      // Leading: Botão de Perfil do Usuário com margens controladas
      leading: Padding(
        padding: const EdgeInsets.only(left: 12.0, top: 8.0, bottom: 8.0),
        child: Container(
          decoration: BoxDecoration(
            color: secondaryColor,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              Icons.person_outline,
              color: primaryColor,
              size: 20, // Ícone ajustado
            ),
            padding: EdgeInsets.zero,
            tooltip: 'Meu Perfil',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ),
      ),
      leadingWidth: 52, // Limita a largura total gasta pelo leading

      // Título Inteligente com Prevenção de Overflow (FittedBox + Flexible)
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo
          Container(
            width: 32, // Levemente menor
            height: 32,
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.favorite_border,
              color: primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 8),

          // Envolvendo o texto num Flexible + FittedBox para que encolha automaticamente
          // caso a tela do dispositivo seja muito fina (prevenindo o Right Overflow)
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 20, // Ajuste sensato da tipografia
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  children: [
                    const TextSpan(
                      text: 'CuidaPapai',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextSpan(
                      text: '+50', // NOME ATUALIZADO
                      style: TextStyle(color: secondaryColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // Actions com margens reduzidas para dar espaço ao Título Central
      actions: [
        // Botão de Tema (Lua/Sol)
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white54, width: 1),
          ),
          child: IconButton(
            icon: Icon(
              themeManager.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              color: Colors.white,
              size: 18,
            ),
            tooltip: 'Alternar tema',
            padding: EdgeInsets.zero,
            onPressed: () {
              themeManager.toggleTheme();
            },
          ),
        ),

        // Botão de Sino com Badge
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 10, right: 12, left: 6),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white54, width: 1),
          ),
          child: IconButton(
            tooltip: 'Notificações',
            padding: EdgeInsets.zero,
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                  size: 20,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      shape: BoxShape.circle,
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

      // Linha divisória inferior amarela
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(3),
        child: Container(
          height: 3,
          width: double.infinity,
          color: secondaryColor,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 3);
}
