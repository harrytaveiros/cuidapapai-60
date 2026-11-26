import 'package:flutter/material.dart';

import '../../core/services/api_service.dart';
import '../../core/models/appointment_model.dart';
import '../forms/add_appointment_screen.dart';
import '../forms/edit_appointment_screen.dart'; 
import 'widgets/timeline_event_card.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  late Future<List<AppointmentModel>> _appointmentsFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _appointmentsFuture = _apiService.getUpcomingAppointments();
  }

  Color _colorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) hexColor = "FF$hexColor";
    return Color(int.tryParse(hexColor, radix: 16) ?? 0xFF000000);
  }

  // TAREFA 2: Método para exibir as opções de Editar/Excluir no Cartão
  void _showOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.edit_outlined, color: Color(0xFF000080)),
                title: const Text(
                  'Editar compromisso',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Em breve: Edição de compromisso')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text(
                  'Excluir compromisso',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Em breve: Exclusão de compromisso')),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    const azulMarinho = Color(0xFF000080);
    const cianoColor = Color(0xFF00BCD4);

    final isDark = themeData.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : azulMarinho;
    final bgIconColor = isDark ? Colors.grey[800] : const Color(0xFFE0E7FF);
    final iconColor = isDark ? Colors.white : azulMarinho;

    return Scaffold(
      body: FutureBuilder<List<AppointmentModel>>(
        future: _appointmentsFuture,
        builder: (context, snapshot) {
          // ESTADO 1: CARREGANDO
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: themeData.primaryColor),
            );
          }

          // ESTADO 2: ERRO
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: themeData.primaryColor),
                  const SizedBox(height: 16),
                  const Text('Não foi possível carregar a agenda.', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => setState(() => _appointmentsFuture = _apiService.getUpcomingAppointments()),
                    style: ElevatedButton.styleFrom(backgroundColor: themeData.primaryColor, foregroundColor: Colors.white),
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          // ESTADO 3: SUCESSO
          final appointments = snapshot.data ?? [];

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
                        color: bgIconColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(Icons.calendar_month, color: iconColor, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ORGANIZAÇÃO',
                          style: TextStyle(
                            color: isDark ? cianoColor : azulMarinho.withValues(alpha: 0.8),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          'Minha agenda',
                          style: themeData.textTheme.displayMedium?.copyWith(
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

                // BOTÃO NOVO COMPROMISSO
                ElevatedButton(
                  onPressed: () async {
                    // Aguarda o resultado do formulário
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddAppointmentScreen()),
                    );
                    
                    // Se result for true, recarrega a lista de compromissos da API
                    if (result == true) {
                      setState(() {
                        _appointmentsFuture = _apiService.getUpcomingAppointments();
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeData.primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 64),
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, size: 28),
                      SizedBox(width: 8),
                      Text('Novo compromisso', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // TÍTULO DE SEÇÃO "ESTA SEMANA"
                Text(
                  'Esta semana',
                  style: themeData.textTheme.bodyLarge?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 16),

                // LISTA DE COMPROMISSOS DINÂMICA
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
                      style: TextStyle(color: textColor, fontSize: 16),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      final apt = appointments[index];
                      // Envolve o card para gerenciar a interatividade de Editar/Excluir
                      return InkWell(
                        onLongPress: () => _showOptionsBottomSheet(context),
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => EditAppointmentScreen(appointment: apt)),
                          );
                          // Se houve edição ou exclusão, recarregamos a Agenda
                          if (result == true) {
                            setState(() {
                              _appointmentsFuture = _apiService.getUpcomingAppointments();
                            });
                          }
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: TimelineEventCard(
                          bulletColor: _colorFromHex(apt.colorHex),
                          dayOfWeek: apt.dayOfWeekShort,
                          dayNumber: apt.dayNumber,
                          time: apt.time,
                          title: apt.title,
                          subtitle: apt.subtitle,
                        ),
                      );
                    },
                  ),

                const SizedBox(height: 48),
              ],
            ),
          );
        },
      ),
    );
  }
}
