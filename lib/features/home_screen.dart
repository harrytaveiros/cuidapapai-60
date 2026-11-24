import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../core/services/api_service.dart';
import '../core/models/user_model.dart';
import '../core/models/medication_model.dart';
import '../core/models/appointment_model.dart';
import '../core/models/care_task_model.dart';

import 'home/widgets/next_medication_card.dart';
import 'home/widgets/quick_access_grid.dart';
import 'care/widgets/care_task_card.dart'; // Componente de Cuidados reaproveitado

// Classe auxiliar para trafegar os dados simultâneos no FutureBuilder
class _HomeData {
  final UserModel user;
  final List<MedicationModel> medications;
  final List<AppointmentModel> appointments;
  final List<CareTaskModel> careTasks;

  _HomeData({
    required this.user,
    required this.medications,
    required this.appointments,
    required this.careTasks,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // O Future que será assistido pelo FutureBuilder
  late Future<_HomeData> _homeDataFuture;
  final ApiService _apiService = ApiService();
  String _dataAtual = '';

  @override
  void initState() {
    super.initState();
    _formatarData();
    _homeDataFuture = _fetchData();
  }

  // Helper para converter String Hex ('#126E51') para classe Color
  Color _colorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return Color(int.tryParse(hexColor, radix: 16) ?? 0xFF000000);
  }

  // TAREFA 1: Expansão do Future.wait para carregar Agenda e Cuidados simultaneamente
  Future<_HomeData> _fetchData() async {
    final results = await Future.wait([
      _apiService.getUserProfile(),
      _apiService.getTodayMedications(),
      _apiService.getUpcomingAppointments(),
      _apiService.getTodayCareTasks(),
    ]);

    return _HomeData(
      user: results[0] as UserModel,
      medications: results[1] as List<MedicationModel>,
      appointments: results[2] as List<AppointmentModel>,
      careTasks: results[3] as List<CareTaskModel>,
    );
  }

  Future<void> _formatarData() async {
    await initializeDateFormatting('pt_BR', null);
    final now = DateTime.now();
    final formatador = DateFormat("EEEE, d 'de' MMMM", "pt_BR");

    if (mounted) {
      setState(() {
        _dataAtual = formatador.format(now).toUpperCase();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final isDark = themeData.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF000080);

    return Scaffold(
      body: FutureBuilder<_HomeData>(
        future: _homeDataFuture,
        builder: (context, snapshot) {
          // ESTADO 1: CARREGANDO (Loading)
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: themeData.primaryColor,
              ),
            );
          }

          // ESTADO 2: ERRO
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: themeData.primaryColor),
                    const SizedBox(height: 16),
                    const Text(
                      'Não foi possível carregar seus dados no momento.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _homeDataFuture = _fetchData();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeData.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            );
          }

          // ESTADO 3: SUCESSO (Renderização do Layout)
          final data = snapshot.data!;
          final user = data.user;
          final medications = data.medications;
          final appointments = data.appointments;
          final careTasks = data.careTasks;

          // Busca o primeiro medicamento pendente
          MedicationModel? proximoMed;
          try {
            proximoMed = medications.firstWhere((med) => !med.isTaken);
          } catch (_) {
            proximoMed = null;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. SAUDAÇÃO E DATA
                Text(
                  _dataAtual.isNotEmpty ? _dataAtual : 'HOJE',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: themeData.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Olá, ${user.shortName}!', // Dado da API
                  style: themeData.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Veja como está o seu dia.',
                  style: themeData.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 12),

                // LINHA DECORATIVA TRICOLOR (Figma)
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: themeData.primaryColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      width: 24,
                      height: 4,
                      decoration: BoxDecoration(
                        color: themeData.colorScheme.secondary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      width: 12,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFF000080),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // 2. PRÓXIMO MEDICAMENTO (Card injetando dados da API)
                NextMedicationCard(
                  medication: proximoMed,
                  onMarkAsTaken: () {
                    // Atualização otimista visual
                    setState(() {
                      proximoMed?.isTaken = true;
                    });
                  },
                ),

                const SizedBox(height: 40),

                // 3. ACESSO RÁPIDO (Grid)
                Text(
                  'Acesso rápido',
                  style: themeData.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 16),
                const QuickAccessGrid(),

                const SizedBox(height: 40),

                // ==========================================
                // TAREFA 3: LISTA DE CUIDADOS DIÁRIOS
                // ==========================================
                Text(
                  'Cuidados diários',
                  style: themeData.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 16),

                if (careTasks.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'Tudo certo! Sem pendências para hoje.',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                    ),
                  )
                else
                  // ListView.builder evita problemas de renderização na coluna e é muito eficiente
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: careTasks.length,
                    itemBuilder: (context, index) {
                      final task = careTasks[index];
                      // Definindo um ícone estático genérico, pois a API não retorna ícone
                      // O ideal é mapear o task.category para o IconData correto futuramente
                      IconData taskIcon = Icons.health_and_safety;

                      return CareTaskCard(
                        icon: taskIcon,
                        iconColor: _colorFromHex(task.colorHex),
                        title: task.title,
                        subtitle: task.subtitle,
                        isCompleted: task.isCompleted,
                        onTap: () {
                          // Toggle otimista na tela Home
                          setState(() {
                            task.isCompleted = !task.isCompleted;
                          });
                        },
                      );
                    },
                  ),

                const SizedBox(height: 40),

                // ==========================================
                // TAREFA 2: PRÓXIMOS COMPROMISSOS (AGENDA)
                // ==========================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Próximos compromissos',
                      style: themeData.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Ver agenda',
                        style: TextStyle(
                          color: Color(0xFF000080), // Azul Marinho
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                if (appointments.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: themeData.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Nenhum compromisso agendado para os próximos dias.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 16,
                      ),
                    ),
                  )
                else
                  // ListView mapeando cada Appointment vindo da API
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      final apt = appointments[index];
                      // Para garantir o espaçamento entre múltiplos cards
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: _buildCompromissoCardDinamico(context, apt),
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

  // Novo Widget do Card de Compromisso Injetando os Dados da API
  Widget _buildCompromissoCardDinamico(BuildContext context, AppointmentModel appointment) {
    const azulMarinho = Color(0xFF000080);
    final cardAccentColor = _colorFromHex(appointment.colorHex);
    
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.grey[900] : Colors.white;
    final textColor = isDark ? Colors.white : azulMarinho;
    final bgDateColor = isDark ? Colors.black : cardAccentColor.withValues(alpha: 0.15);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
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
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: cardAccentColor, // Borda da cor definida pelo backend
                width: 4,
              ),
            ),
          ),
          child: Row(
            children: [
              // Bloco da Data (Quadrado Colorido Inteligente)
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: bgDateColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      appointment.dayNumber,
                      style: TextStyle(
                        color: isDark ? Colors.white : cardAccentColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                      ),
                    ),
                    Text(
                      appointment.dayOfWeekShort.toUpperCase(),
                      style: TextStyle(
                        color: isDark ? Colors.white70 : cardAccentColor.withValues(alpha: 0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              
              // Informações Centrais da API
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          appointment.time,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      appointment.title,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      appointment.subtitle,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              
              const Icon(
                Icons.chevron_right,
                color: Colors.grey,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
