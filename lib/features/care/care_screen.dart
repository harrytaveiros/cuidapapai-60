import 'package:flutter/material.dart';

import '../../core/services/api_service.dart';
import '../../core/models/user_model.dart';
import '../../core/models/care_task_model.dart';
import '../../core/theme/app_theme.dart';
import 'widgets/care_task_card.dart';

class _CareData {
  final UserModel user;
  final List<CareTaskModel> tasks;

  _CareData({required this.user, required this.tasks});
}

class CareScreen extends StatefulWidget {
  const CareScreen({super.key});

  @override
  State<CareScreen> createState() => _CareScreenState();
}

class _CareScreenState extends State<CareScreen> {
  late Future<_CareData> _careDataFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _careDataFuture = _fetchData();
  }

  Future<_CareData> _fetchData() async {
    final results = await Future.wait([
      _apiService.getUserProfile(),
      _apiService.getTodayCareTasks(),
    ]);

    return _CareData(
      user: results[0] as UserModel,
      tasks: results[1] as List<CareTaskModel>,
    );
  }

  Color _colorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) hexColor = "FF$hexColor";
    return Color(int.tryParse(hexColor, radix: 16) ?? 0xFF000000);
  }

  // Ícone fixo genérico ou mapeamento manual de categorias
  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'blood_pressure':
        return Icons.monitor_heart;
      case 'meal':
        return Icons.restaurant;
      case 'mood':
        return Icons.sentiment_satisfied_alt;
      case 'exercise':
        return Icons.directions_walk;
      default:
        return Icons.health_and_safety;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    const azulMarinho = Color(0xFF000080);
    final textColor = isDark ? Colors.white : azulMarinho;
    final primaryColor = theme.primaryColor;

    return Scaffold(
      body: FutureBuilder<_CareData>(
        future: _careDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: primaryColor));
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: primaryColor),
                  const SizedBox(height: 16),
                  const Text('Não foi possível carregar as tarefas.', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => setState(() => _careDataFuture = _fetchData()),
                    style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          final data = snapshot.data!;
          final user = data.user;
          final careTasks = data.tasks;

          final completedCount = careTasks.where((task) => task.isCompleted).length;
          final totalTasks = careTasks.isNotEmpty ? careTasks.length : 1; // Evita divisão por zero
          final progressValue = careTasks.isEmpty ? 0.0 : (completedCount / totalTasks);

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CABEÇALHO DA PÁGINA
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(Icons.favorite, color: primaryColor, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ACOMPANHAMENTO',
                          style: TextStyle(
                            color: isDark ? theme.colorScheme.secondary : azulMarinho.withValues(alpha: 0.8),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          'Cuidados de hoje',
                          style: theme.textTheme.displayMedium?.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 32,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // CARD DE PROGRESSO
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.gradientStart, AppColors.gradientEnd],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            careTasks.isEmpty ? '0 de 0' : '$completedCount de ${careTasks.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              height: 1.0,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Text(
                              'registros preenchidos',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0, end: progressValue),
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          builder: (context, value, _) {
                            return LinearProgressIndicator(
                              value: value,
                              minHeight: 8,
                              backgroundColor: Colors.black.withValues(alpha: 0.2),
                              color: theme.colorScheme.secondary,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // TÍTULO DA SEÇÃO DINÂMICO
                Text(
                  'Como ${user.shortName} está?',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 16),

                // LISTA DE TAREFAS DINÂMICA DA API
                if (careTasks.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'Tudo certo! Sem pendências para hoje.',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: careTasks.length,
                    itemBuilder: (context, index) {
                      final task = careTasks[index];
                      return CareTaskCard(
                        icon: _getIconForCategory(task.category),
                        iconColor: _colorFromHex(task.colorHex),
                        title: task.title,
                        subtitle: task.isCompleted ? 'Registrado hoje' : task.subtitle,
                        isCompleted: task.isCompleted,
                        onTap: () {
                          // Toggle otimista na tela Cuidados
                          setState(() {
                            task.isCompleted = !task.isCompleted;
                          });
                        },
                      );
                    },
                  ),

                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }
}
