import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  static const Color darkGreen = Color(0xFF126E51);
  final Set<String> selectedHabits = {};
  bool _isLoading = false;

  final List<Map<String, dynamic>> _habitsMock = [
    {'title': 'Beber Água', 'subtitle': 'Meta: 2 litros', 'icon': Icons.water_drop, 'color': Colors.blue},
    {'title': 'Caminhada', 'subtitle': 'Meta: 30 minutos', 'icon': Icons.directions_walk, 'color': Color(0xFF00BCD4)},
    {'title': 'Alongamento', 'subtitle': 'Meta: 10 minutos', 'icon': Icons.accessibility_new, 'color': Color(0xFFF39C12)},
    {'title': 'Leitura', 'subtitle': 'Meta: 15 páginas', 'icon': Icons.menu_book, 'color': Color(0xFF000080)},
  ];

  void _toggleHabit(String title) {
    setState(() {
      if (selectedHabits.contains(title)) {
        selectedHabits.remove(title);
      } else {
        selectedHabits.add(title);
      }
    });
  }

  Future<void> _saveForm() async {
    if (selectedHabits.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      await ApiService().createCareTasks(selectedHabits.toList());

      if (!mounted) return;
      Navigator.pop(context, true);

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceAll('Exception: ', ''),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: darkGreen,
        elevation: 0,
        centerTitle: true,
        title: const Text('Minhas Metas de Hoje', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // CABEÇALHO FIXO NO TOPO
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'HÁBITOS SAUDÁVEIS',
                    style: TextStyle(
                      color: darkGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Cuide de você, um passo por vez',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF000080),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Selecione as metas que deseja acompanhar hoje.',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),

            // LISTA DE HÁBITOS (Scrollable)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                itemCount: _habitsMock.length,
                itemBuilder: (context, index) {
                  final habit = _habitsMock[index];
                  final isSelected = selectedHabits.contains(habit['title']);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _HabitCard(
                      title: habit['title'],
                      subtitle: habit['subtitle'],
                      icon: habit['icon'],
                      iconColor: habit['color'],
                      isSelected: isSelected,
                      onTap: () => _toggleHabit(habit['title']),
                    ),
                  );
                },
              ),
            ),

            // RODAPÉ FIXO COM O BOTÃO SALVAR
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: (selectedHabits.isEmpty || _isLoading) ? null : _saveForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkGreen,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading 
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Confirmar Metas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget Privado para o Card do Hábito
class _HabitCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _HabitCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color darkGreen = Color(0xFF126E51);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? darkGreen : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: darkGreen.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ] : null,
        ),
        child: Row(
          children: [
            // Ícone colorido com fundo claro
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),

            // Textos Centrais
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF000080),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            // Círculo Check/Uncheck (Acessibilidade Visual)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected ? darkGreen : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? darkGreen : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
