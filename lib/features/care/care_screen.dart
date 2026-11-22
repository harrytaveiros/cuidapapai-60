import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'widgets/care_task_card.dart';

class CareScreen extends StatefulWidget {
  const CareScreen({super.key});

  @override
  State<CareScreen> createState() => _CareScreenState();
}

class _CareScreenState extends State<CareScreen> {
  // Lista de estados booleanos para as 4 tarefas.
  // [0] = Pressão, [1] = Alimentação, [2] = Humor, [3] = Atividade Física
  final List<bool> _taskStatus = [true, false, false, false];

  // Método responsável por inverter o status da tarefa e atualizar a interface
  void _toggleTask(int index) {
    setState(() {
      _taskStatus[index] = !_taskStatus[index];
    });
  }

  // Auxiliar para gerar o subtítulo dinâmico baseado no status de conclusão
  String _getSubtitle(int index, bool isCompleted) {
    if (!isCompleted) return 'Toque para registrar';

    // O primeiro item (Pressão) ganha o texto mockado extra se estiver concluído
    if (index == 0) return 'Registrado hoje (120x80)';

    // Texto padrão para as outras tarefas concluídas
    return 'Registrado hoje';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    const azulMarinho = Color(0xFF000080);
    final textColor = isDark ? Colors.white : azulMarinho;
    final primaryColor = theme.primaryColor;

    // Cálculo dinâmico do número de tarefas concluídas
    final completedCount = _taskStatus.where((status) => status).length;
    final totalTasks = _taskStatus.length;
    final progressValue = completedCount / totalTasks;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. CABEÇALHO DA PÁGINA
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.favorite,
                    color: primaryColor,
                    size: 32,
                  ),
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

            // 2. CARD DE PROGRESSO
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.gradientStart,
                    AppColors.gradientEnd,
                  ],
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
                      // Texto de Progresso Dinâmico
                      Text(
                        '$completedCount de $totalTasks',
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

                  // Barra de Progresso Dinâmica com animação
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

            Text(
              'Como Dona Maria está?',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),

            const SizedBox(height: 16),

            // 4. LISTA DE TAREFAS (Interativas)

            // 4.1 Pressão Arterial
            CareTaskCard(
              icon: Icons.monitor_heart,
              iconColor: primaryColor,
              title: 'Pressão arterial',
              subtitle: _getSubtitle(0, _taskStatus[0]),
              isCompleted: _taskStatus[0],
              onTap: () => _toggleTask(0),
            ),

            // 4.2 Alimentação
            CareTaskCard(
              icon: Icons.restaurant,
              iconColor: const Color(0xFF0D47A1),
              title: 'Alimentação',
              subtitle: _getSubtitle(1, _taskStatus[1]),
              isCompleted: _taskStatus[1],
              onTap: () => _toggleTask(1),
            ),

            // 4.3 Humor
            CareTaskCard(
              icon: Icons.sentiment_satisfied_alt,
              iconColor: const Color(0xFFF39C12),
              title: 'Humor e disposição',
              subtitle: _getSubtitle(2, _taskStatus[2]),
              isCompleted: _taskStatus[2],
              onTap: () => _toggleTask(2),
            ),

            // 4.4 Atividade Física
            CareTaskCard(
              icon: Icons.directions_walk,
              iconColor: const Color(0xFF00BCD4),
              title: 'Atividade física',
              subtitle: _getSubtitle(3, _taskStatus[3]),
              isCompleted: _taskStatus[3],
              onTap: () => _toggleTask(3),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
