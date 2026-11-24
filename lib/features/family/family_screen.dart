import 'package:flutter/material.dart';

import '../../core/services/api_service.dart';
import '../../core/models/contact_model.dart';
import 'widgets/contact_card.dart';

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  late Future<List<ContactModel>> _contactsFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _contactsFuture = _apiService.getNetworkContacts();
  }

  Color _colorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) hexColor = "FF$hexColor";
    return Color(int.tryParse(hexColor, radix: 16) ?? 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    const azulMarinho = Color(0xFF000080);
    final primaryColor = theme.primaryColor;
    final secondaryColor = theme.colorScheme.secondary;

    final textColor = isDark ? Colors.white : azulMarinho;
    final bgIconColor = isDark ? Colors.grey[800] : secondaryColor.withValues(alpha: 0.2);
    final iconColor = isDark ? Colors.white : const Color(0xFFD48B00);

    return Scaffold(
      body: FutureBuilder<List<ContactModel>>(
        future: _contactsFuture,
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
                  const Text('Não foi possível carregar a sua rede de apoio.', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => setState(() => _contactsFuture = _apiService.getNetworkContacts()),
                    style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            );
          }

          final contacts = snapshot.data ?? [];

          // Filtra a lista vinda da API
          final familiares = contacts.where((c) => !c.isProfessional).toList();
          final profissionais = contacts.where((c) => c.isProfessional).toList();

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
                      child: Icon(Icons.groups, color: iconColor, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'REDE DE APOIO',
                          style: TextStyle(
                            color: isDark ? secondaryColor : azulMarinho.withValues(alpha: 0.8),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Text(
                          'Família e cuidadores',
                          style: theme.textTheme.displayMedium?.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 28,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // BANNER DE ACOLHIMENTO
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[900] : const Color(0xFFFFF8E1),
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
                        border: Border(left: BorderSide(color: azulMarinho, width: 6)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.favorite_border,
                              color: isDark ? Colors.black : const Color(0xFFD48B00),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Você não está sozinho',
                                  style: TextStyle(
                                    color: isDark ? Colors.white : const Color(0xFF8D6E63),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Sua rede recebe as atualizações importantes.',
                                  style: TextStyle(
                                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // SEÇÃO: FAMILIARES
                Text(
                  'Familiares',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 16),

                if (familiares.isEmpty)
                  Text(
                    'Nenhum familiar adicionado.',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: familiares.length,
                    itemBuilder: (context, index) {
                      final contato = familiares[index];
                      return ContactCard(
                        name: contato.name,
                        relation: contato.relation,
                        initials: contato.initials,
                        avatarColor: _colorFromHex(contato.avatarColorHex),
                        isProfessional: false,
                        onCall: () {},
                      );
                    },
                  ),

                const SizedBox(height: 32),

                // SEÇÃO: CUIDADORA RESPONSÁVEL
                Text(
                  'Cuidadores profissionais',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 16),

                if (profissionais.isEmpty)
                  Text(
                    'Nenhum profissional adicionado.',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: profissionais.length,
                    itemBuilder: (context, index) {
                      final prof = profissionais[index];
                      return ContactCard(
                        name: prof.name,
                        relation: prof.relation,
                        initials: prof.initials,
                        avatarColor: _colorFromHex(prof.avatarColorHex),
                        isProfessional: true,
                        onCall: () {},
                      );
                    },
                  ),

                const SizedBox(height: 32),

                // BOTÃO "ENCONTRAR OUTRO CUIDADOR"
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryColor,
                    side: BorderSide(color: primaryColor, width: 2),
                    minimumSize: const Size(double.infinity, 64),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_search, size: 28),
                      SizedBox(width: 8),
                      Text(
                        'Encontrar outro cuidador',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
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
