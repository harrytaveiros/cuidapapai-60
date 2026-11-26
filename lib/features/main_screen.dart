import 'package:flutter/material.dart';
import '../core/theme/theme_manager.dart';
import 'home_screen.dart';
import 'agenda/agenda_screen.dart';
import 'care/care_screen.dart';
import 'family/family_screen.dart';

import '../shared/widgets/custom_app_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Índice da aba atualmente selecionada
  int _currentIndex = 0;

  // Lista de telas que serão empilhadas
  late final List<Widget> _screens = [
    HomeScreen(
      onNavigateToAgenda: () => _onItemTapped(1), // Índice 1 = Agenda
    ),
    const AgendaScreen(),
    const CareScreen(),
    const FamilyScreen(),
  ];

  // Método chamado ao tocar em um item do BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Utilizamos o nosso componente reutilizável e com fundo colorido
      appBar: const CustomAppBar(title: 'CuidaPapai+50'),
      // O IndexedStack mantém o estado das telas (scroll, formulários, etc)
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,

        // FUNDAMENTAL para idosos: "fixed" impede que os ícones se movam
        // e garante que todos os textos fiquem sempre visíveis.
        type: BottomNavigationBarType.fixed,

        // Cores baseadas no tema atual
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,

        // Acessibilidade: Ícones e textos levemente maiores
        iconSize: 32,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        unselectedLabelStyle: const TextStyle(fontSize: 14),

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Agenda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Cuidados',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups),
            label: 'Família',
          ),
        ],
      ),
    );
  }
}
