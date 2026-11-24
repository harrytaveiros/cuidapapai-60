import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../core/services/api_service.dart';
import '../core/models/user_model.dart';
import '../core/models/medication_model.dart';
import 'home/widgets/next_medication_card.dart';
import 'home/widgets/quick_access_grid.dart';

// Classe auxiliar para trafegar os dados simultâneos no FutureBuilder
class _HomeData {
  final UserModel user;
  final List<MedicationModel> medications;

  _HomeData({required this.user, required this.medications});
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

  // Método que busca simultaneamente os dados da API
  Future<_HomeData> _fetchData() async {
    final results = await Future.wait([
      _apiService.getUserProfile(),
      _apiService.getTodayMedications(),
    ]);

    return _HomeData(
      user: results[0] as UserModel,
      medications: results[1] as List<MedicationModel>,
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

          // Busca o primeiro medicamento pendente (não tomado)
          MedicationModel? proximoMed;
          try {
            proximoMed = medications.firstWhere((med) => !med.isTaken);
          } catch (_) {
            proximoMed = null; // Todos foram tomados (ou lista veio vazia)
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
                  'Olá, ${user.shortName}!', // DADO REAL DA API AQUI
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

                // 2. PRÓXIMO MEDICAMENTO (Card injetando dados reais da API)
                NextMedicationCard(
                  medication: proximoMed,
                  onMarkAsTaken: () {
                    // Como a API não está completa para receber requisições, vamos forçar uma re-renderização local para fins visuais
                    // Exemplo: apiService.markMedicationAsTaken(proximoMed.id);
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

                // 4. PRÓXIMOS COMPROMISSOS (Header)
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

                // Card de Compromisso Refatorado (Figma)
                _buildCompromissoCardFigma(context),

                // Espaçamento extra no fim do Scroll
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  // Novo Widget do Card de Compromisso (Estilo Figma)
  Widget _buildCompromissoCardFigma(BuildContext context) {
    const azulMarinho = Color(0xFF000080);
    const azulClaro = Color(0xFFE0E7FF);
    
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.grey[900] : Colors.white;
    final textColor = isDark ? Colors.white : azulMarinho;

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
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(
                color: azulMarinho, // Borda "fita" lateral esquerda
                width: 4,
              ),
            ),
          ),
          child: Row(
            children: [
              // Bloco da Data (Quadrado Azul Claro)
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: azulClaro,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '14',
                      style: TextStyle(
                        color: azulMarinho,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                      ),
                    ),
                    Text(
                      'MAI',
                      style: TextStyle(
                        color: azulMarinho.withValues(alpha: 0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              
              // Informações Centrais
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ícone de Relógio e Horário
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '10:30',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    
                    // Título do Compromisso
                    Text(
                      'Consulta com cardiologista',
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
                    
                    // Subtítulo / Local
                    Text(
                      'Clínica São Lucas - Dr. Roberto',
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
              
              // Ícone Seta para a direita (Call to Action implícita)
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
