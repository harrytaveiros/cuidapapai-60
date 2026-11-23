import 'package:flutter/material.dart';

// Importações do Core utilizando absolute paths (Boa prática no Flutter)
import 'package:cuida_papai/core/theme/app_theme.dart';
import 'package:cuida_papai/core/theme/theme_manager.dart';
import 'package:cuida_papai/core/service_locator.dart';

// Importação da tela de Login (Nova Rota Inicial)
import 'package:cuida_papai/features/auth/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(const CuidaPapaiApp());
}

class CuidaPapaiApp extends StatefulWidget {
  const CuidaPapaiApp({super.key});

  @override
  State<CuidaPapaiApp> createState() => _CuidaPapaiAppState();
}

class _CuidaPapaiAppState extends State<CuidaPapaiApp> {
  final ThemeManager _themeManager = ThemeManager();

  @override
  void initState() {
    super.initState();
    _themeManager.addListener(_themeListener);
  }

  @override
  void dispose() {
    _themeManager.removeListener(_themeListener);
    super.dispose();
  }

  void _themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CuidaPapai+50',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeManager.themeMode,
      // Agora o app inicia na Tela de Login
      home: const LoginScreen(),
    );
  }
}
