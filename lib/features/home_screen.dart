import 'package:flutter/material.dart';
import '../core/service_locator.dart';
import '../core/services/user_service.dart';
import 'home/widgets/next_medication_card.dart';
import 'home/widgets/quick_access_grid.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _dataAtual = '';

  @override
  void initState() {
    super.initState();
    _formatarData();
  }

  Future<void> _formatarData() async {
    // Garante que o idioma base seja carregado (pt_BR é comumente usado no Brasil)
    await initializeDateFormatting('pt_BR', null);
    final now = DateTime.now();
    // Ex: "Segunda, 14 de maio"
    final formatador = DateFormat("EEEE, d 'de' MMMM", "pt_BR");

    if (mounted) {
      setState(() {
        _dataAtual = formatador.format(now).toUpperCase(); // Coloca tudo em maiúsculo para leitura
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userService = locator<UserService>();
    final themeData = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
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
              'Olá, ${userService.nomeUsuario}!',
              style: themeData.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w900, // Extra negrito para o nome
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Veja como está o seu dia.',
              style: themeData.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600, // Cinza legível e suave
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
                    color: themeData.primaryColor, // Verde escuro
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 24,
                  height: 4,
                  decoration: BoxDecoration(
                    color: themeData.colorScheme.secondary, // Amarelo
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  width: 12,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF000080), // Azul marinho
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // 2. PRÓXIMO MEDICAMENTO (Card)
            const NextMedicationCard(),

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
                    fontSize: 22, // Tamanho sutilmente ajustado para bater com o botão
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Remove o padding fantasma
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
      ),
    );
  }

  // Novo Widget do Card de Compromisso (Estilo Figma)
  Widget _buildCompromissoCardFigma(BuildContext context) {
    const azulMarinho = Color(0xFF000080);
    const azulClaro = Color(0xFFE0E7FF); // Fundo da data
    
    // Tratativa para o tema escuro
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
                    Text(
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
                          color: Theme.of(context).primaryColor, // Verde do tema
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

  // O antigo widget simples que havia antes, agora pode ser deletado ou ignorado,
  // pois não está mais sendo chamado.

}
