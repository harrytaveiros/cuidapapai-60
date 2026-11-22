import 'package:flutter/material.dart';

/// Gerenciador de tema utilizando padrão Singleton e ChangeNotifier.
/// Facilita a injeção do estado de tema em toda a árvore de widgets.
class ThemeManager extends ChangeNotifier {
  // 1. Instância estática e privada do Singleton
  static final ThemeManager _instance = ThemeManager._internal();

  // 2. Factory constructor retornando a mesma instância
  factory ThemeManager() {
    return _instance;
  }

  // 3. Construtor interno nomeado
  ThemeManager._internal();

  // Estado inicial do tema (Inicia no Claro, mas pode ser carregado do SharedPreferences)
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  /// Retorna [true] se o tema atual for o de Alto Contraste (Escuro)
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Alterna o tema e notifica a interface para reconstruir
  void toggleTheme() {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}
