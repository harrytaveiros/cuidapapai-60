import 'package:flutter/material.dart';

import '../../core/services/api_service.dart';
import '../../core/models/user_model.dart';
import '../../core/models/medication_model.dart';
import '../auth/login_screen.dart';

// Classe auxiliar para trafegar os dados simultâneos no FutureBuilder
class _ProfileData {
  final UserModel user;
  final List<MedicationModel> medications;

  _ProfileData({required this.user, required this.medications});
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<_ProfileData> _profileDataFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _profileDataFuture = _fetchData();
  }

  // Busca os dados em paralelo (Perfil + Medicamentos)
  Future<_ProfileData> _fetchData() async {
    final results = await Future.wait([
      _apiService.getUserProfile(),
      _apiService.getTodayMedications(),
    ]);

    return _ProfileData(
      user: results[0] as UserModel,
      medications: results[1] as List<MedicationModel>,
    );
  }

  // Lógica inteligente para extrair iniciais (ex: "Carlos Eduardo" -> "CE")
  String _getInitials(String fullName) {
    if (fullName.trim().isEmpty) return "US"; // Fallback "Usuário"
    final nameParts = fullName.trim().split(' ');

    if (nameParts.length > 1) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else {
      // Se tiver só um nome, pega as duas primeiras letras ou só a primeira
      return fullName.substring(0, fullName.length >= 2 ? 2 : 1).toUpperCase();
    }
  }

  // Mantido intacto: Modal de Confirmação de Logout
  void _showLogoutConfirmation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.logout, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Sair da Conta',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000080),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tem certeza que deseja sair do seu perfil?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  await _apiService.logout();

                  if (!context.mounted) return;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Sim, quero sair',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    const darkGreen = Color(0xFF126E51);
    const azulMarinho = Color(0xFF000080);
    final cardBgColor = isDark ? Colors.grey[900] : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        backgroundColor: darkGreen,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: FutureBuilder<_ProfileData>(
        future: _profileDataFuture,
        builder: (context, snapshot) {
          // ESTADO 1: LOADING
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: darkGreen),
            );
          }

          // ESTADO 2: ERRO
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.warning_amber_rounded, size: 64, color: Colors.orange),
                    const SizedBox(height: 16),
                    const Text(
                      'Não foi possível carregar os dados do seu perfil no momento.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _profileDataFuture = _fetchData();
                        });
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: darkGreen, foregroundColor: Colors.white),
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            );
          }

          // ESTADO 3: SUCESSO
          final data = snapshot.data!;
          final user = data.user;
          final meds = data.medications;

          // Mapeamento dos medicamentos ou mensagem de vazio
          final medsText = meds.isEmpty
              ? 'Nenhum medicamento registrado.'
              : meds.map((m) => '${m.nome} ${m.dosagem}').join(', ');

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),

                // AVATAR
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary, // Amarelo
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _getInitials(user.name),
                      style: const TextStyle(
                        color: darkGreen,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // INFORMAÇÕES DO PERFIL (Card)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: cardBgColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Nome Completo', user.name, azulMarinho, isDark),
                      const Divider(height: 32),

                      // TODO: Atualizar quando a API fornecer estes dados
                      _buildInfoRow('Data de Nascimento', '14/05/1954 (Dado Estático)', azulMarinho, isDark),
                      const Divider(height: 32),

                      // TODO: Atualizar quando a API fornecer estes dados
                      _buildInfoRow('Doenças Crônicas', 'Hipertensão (Dado Estático)', azulMarinho, isDark),
                      const Divider(height: 32),

                      _buildInfoRow('Medicamentos de uso contínuo', medsText, azulMarinho, isDark),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                // BOTÃO DE LOGOUT
                ElevatedButton.icon(
                  onPressed: () => _showLogoutConfirmation(context),
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    'Desconectar',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade50,
                    foregroundColor: Colors.red.shade700,
                    minimumSize: const Size(double.infinity, 64),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.red.shade200, width: 2),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper para desenhar as linhas de informação mantendo padrão visual
  Widget _buildInfoRow(String label, String value, Color labelColor, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: isDark ? Colors.white : labelColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
