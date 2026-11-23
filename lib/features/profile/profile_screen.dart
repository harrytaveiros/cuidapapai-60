import 'package:flutter/material.dart';
import '../auth/login_screen.dart'; // Ajuste este import para o caminho correto do seu LoginScreen

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color darkGreen = Color(0xFF126E51);
  static const Color yellow = Color(0xFFFBBF24);
  static const Color bgGrey = Color(0xFFF8FAFC);
  static const Color alertRed = Color(0xFFD32F2F);

  void _showLogoutConfirmation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Icon(Icons.exit_to_app, color: alertRed, size: 48),
              const SizedBox(height: 16),
              const Text(
                'Deseja sair do aplicativo?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: darkGreen,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Você precisará digitar sua senha novamente para acessar sua rotina.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkGreen,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Ficar no aplicativo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (route) => false,
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: alertRed,
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: const Text('Sim, quero sair', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
    return Scaffold(
      backgroundColor: bgGrey,
      appBar: AppBar(
        backgroundColor: darkGreen, // Cor do cabeçalho alinhada com o seu print
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Meu Perfil',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // AVATAR
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: darkGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        'DM',
                        style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: yellow,
                      shape: BoxShape.circle,
                      border: Border.all(color: bgGrey, width: 3),
                    ),
                    child: const Icon(Icons.camera_alt, color: darkGreen, size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Alterar foto',
              style: TextStyle(color: darkGreen, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
            ),
            const SizedBox(height: 8),
            Text(
              'Personalize como sua família vê você.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 32),

            // CARD 1: DADOS
            _buildProfileCard(
              icon: Icons.person_outline,
              title: 'Meus Dados',
              subtitle: 'Suas informações pessoais',
              children: [
                _buildDisabledInput('Nome', 'Dona Maria'),
                const SizedBox(height: 16),
                _buildDisabledInput('Data de nascimento', '17/08/1952', suffixIcon: Icons.calendar_today),
              ],
            ),
            const SizedBox(height: 24),

            // CARD 2: SAÚDE
            _buildProfileCard(
              icon: Icons.favorite_border,
              title: 'Minha Saúde',
              subtitle: 'Dados importantes para seu cuidado',
              children: [
                _buildDisabledInput('Medicamentos de uso contínuo', 'Losartana 50mg, Sinvastatina 20mg'),
                const SizedBox(height: 16),
                const Text('Doenças crônicas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    Chip(
                      label: const Text('Hipertensão', style: TextStyle(color: darkGreen, fontWeight: FontWeight.bold)),
                      backgroundColor: darkGreen.withValues(alpha: 0.1),
                      side: const BorderSide(color: darkGreen),
                      avatar: const Icon(Icons.check, color: darkGreen, size: 16),
                    ),
                    Chip(
                      label: Text('Diabetes', style: TextStyle(color: Colors.grey.shade700)),
                      backgroundColor: Colors.grey.shade100,
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 32),

            // BOTÃO SALVAR
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: darkGreen,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Salvar alterações', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 40),

            // BOTÃO SAIR DA CONTA
            OutlinedButton.icon(
              onPressed: () => _showLogoutConfirmation(context),
              icon: const Icon(Icons.logout, color: alertRed),
              label: const Text('Sair da conta', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: alertRed)),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                side: const BorderSide(color: alertRed, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard({required IconData icon, required String title, required String subtitle, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: darkGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: darkGreen),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkGreen)),
                  Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDisabledInput(String label, String value, {IconData? suffixIcon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          readOnly: true,
          decoration: InputDecoration(
            suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: darkGreen) : null,
            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
          ),
        ),
      ],
    );
  }
}