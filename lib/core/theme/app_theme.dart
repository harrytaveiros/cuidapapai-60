import 'package:flutter/material.dart';

/// Cores específicas do aplicativo que não fazem parte do ColorScheme padrão
class AppColors {
  // Degradê do Card de Medicamentos (Figma)
  static const Color gradientStart = Color(0xFF0F5C47);
  static const Color gradientEnd = Color(0xFF389D7B);
}

class AppTheme {
  // ==========================================
  // CORES DO TEMA CLARO
  // ==========================================
  static const Color _lightBackground = Colors.white;
  static const Color _lightPrimary = Color(0xFF126E51); // Verde Suave (Figma)
  static const Color _lightSecondary = Color(0xFFFFDB58); // Amarelo/Mostarda
  static const Color _lightTextPrimary = Color(0xFF000080); // Azul Marinho
  static const Color _lightTextSecondary = Color(0xFF333333); // Cinza Escuro

  // ==========================================
  // CORES DO TEMA ALTO CONTRASTE (NOTURNO)
  // ==========================================
  static const Color _darkBackground = Colors.black;
  static const Color _darkPrimary = Color(0xFFFF0000); // Vermelho Vibrante
  static const Color _darkTextPrimary = Colors.white;
  static const Color _darkTextSecondary = Color(0xFFE0E0E0); // Cinza Claro

  // ==========================================
  // TEXT THEME ACESSÍVEL (Fontes grandes)
  // ==========================================
  static TextTheme _accessibleTextTheme(Color primaryColor, Color secondaryColor) {
    return TextTheme(
      displayLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: primaryColor),
      displayMedium: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: primaryColor),
      bodyLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: primaryColor), // Texto comum muito legível
      bodyMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: secondaryColor),
      labelLarge: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white), // Para botões
    );
  }

  // ==========================================
  // TEMA CLARO DEFINITION
  // ==========================================
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: _lightBackground,
      primaryColor: _lightPrimary,
      colorScheme: const ColorScheme.light(
        primary: _lightPrimary,
        secondary: _lightSecondary,
        surface: _lightBackground,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: _lightTextPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _lightPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white, size: 36), // Ícones maiores
      ),
      textTheme: _accessibleTextTheme(_lightTextPrimary, _lightTextSecondary),
      elevatedButtonTheme: _elevatedButtonTheme(_lightPrimary),
      iconTheme: const IconThemeData(size: 36, color: _lightPrimary),
    );
  }

  // ==========================================
  // TEMA ESCURO / ALTO CONTRASTE DEFINITION
  // ==========================================
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _darkBackground,
      primaryColor: _darkPrimary,
      colorScheme: const ColorScheme.dark(
        primary: _darkPrimary,
        secondary: _darkPrimary, // Foco no vermelho vibrante
        surface: _darkBackground,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: _darkTextPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkBackground,
        foregroundColor: _darkPrimary, // Ícones e textos do AppBar em vermelho vibrante
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _darkPrimary),
        iconTheme: IconThemeData(color: _darkPrimary, size: 36), // Ícones maiores
      ),
      textTheme: _accessibleTextTheme(_darkTextPrimary, _darkTextSecondary),
      elevatedButtonTheme: _elevatedButtonTheme(_darkPrimary),
      iconTheme: const IconThemeData(size: 36, color: _darkPrimary),
    );
  }

  // ==========================================
  // BOTÕES ACESSÍVEIS (Touch Target grande)
  // ==========================================
  static ElevatedButtonThemeData _elevatedButtonTheme(Color bgColor) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 64), // Altura excelente para idosos clicarem (min > 48)
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
