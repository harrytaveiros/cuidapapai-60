import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controle de estado das condições de saúde selecionadas
  final Set<String> _condicoesSelecionadas = {};

  // Lista fixa de opções para o Wrap de Chips
  final List<String> _opcoesSaude = [
    'Hipertensão',
    'Diabetes',
    'Colesterol',
    'Nenhuma'
  ];

  // Paleta de Cores
  static const Color darkGreen = Color(0xFF126E51);
  static const Color bgGrey = Color(0xFFF8FAFC);
  static const Color yellow = Color(0xFFFBBF24);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGrey,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. CABEÇALHO SUPERIOR (Voltar + Logo)
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios, color: darkGreen),
                    tooltip: 'Voltar',
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                  ),
                  const Spacer(),
                  // Logo Amarelo
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: yellow,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      color: darkGreen,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                      children: [
                        TextSpan(
                          text: 'CuidaPapai',
                          style: TextStyle(color: darkGreen),
                        ),
                        TextSpan(
                          text: '+50',
                          style: TextStyle(color: yellow),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 2), // Equilibra o espaço do botão voltar
                ],
              ),
              const SizedBox(height: 32),

              // 2. TEXTOS INTRODUTÓRIOS
              Text(
                'SEU CUIDADO COMEÇA AQUI',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Nova Conta',
                style: TextStyle(
                  color: darkGreen,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Vamos conhecer você e sua saúde.',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),

              // 3. INDICADOR DE PROGRESSO
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: darkGreen.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: darkGreen.withValues(alpha: 0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Progresso do cadastro - 4 etapas',
                      style: TextStyle(
                        color: darkGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildProgressSegment(darkGreen),
                        const SizedBox(width: 4),
                        _buildProgressSegment(darkGreen),
                        const SizedBox(width: 4),
                        _buildProgressSegment(darkGreen),
                        const SizedBox(width: 4),
                        _buildProgressSegment(yellow),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // 4. CARD 1: DADOS DE ACESSO
              _buildSectionCard(
                stepNumber: '1',
                title: 'Dados de Acesso',
                children: [
                  _buildInputField('E-mail válido', 'Ex: maria@email.com', keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 16),
                  _buildInputField('Crie uma senha forte', 'Mínimo de 8 caracteres', obscureText: true),
                ],
              ),

              // 5. CARD 2: PERFIL DO IDOSO
              _buildSectionCard(
                stepNumber: '2',
                title: 'Perfil do Idoso',
                children: [
                  _buildInputField('Nome completo', 'Como prefere ser chamado?'),
                  const SizedBox(height: 16),
                  _buildInputField(
                    'Data de nascimento',
                    'DD/MM/AAAA',
                    keyboardType: TextInputType.datetime,
                    suffixIcon: Icons.calendar_month_outlined,
                  ),
                ],
              ),

              // 6. CARD 3: FICHA MÉDICA
              _buildSectionCard(
                stepNumber: '3',
                title: 'Ficha Médica',
                children: [
                  const Text(
                    'Condições de Saúde',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  // Wrap com FilterChips para seleção múltipla amigável
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: _opcoesSaude.map((condicao) {
                      final isSelected = _condicoesSelecionadas.contains(condicao);
                      return FilterChip(
                        label: Text(
                          condicao,
                          style: TextStyle(
                            color: isSelected ? darkGreen : Colors.grey.shade700,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: darkGreen.withValues(alpha: 0.15),
                        checkmarkColor: darkGreen,
                        backgroundColor: Colors.grey.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: isSelected ? darkGreen : Colors.grey.shade300,
                          ),
                        ),
                        onSelected: (bool selected) {
                          setState(() {
                            if (condicao == 'Nenhuma' && selected) {
                              _condicoesSelecionadas.clear();
                              _condicoesSelecionadas.add(condicao);
                            } else {
                              _condicoesSelecionadas.remove('Nenhuma');
                              if (selected) {
                                _condicoesSelecionadas.add(condicao);
                              } else {
                                _condicoesSelecionadas.remove(condicao);
                              }
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Medicamentos de uso contínuo',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Ex: Losartana 50mg (Manhã e Noite)',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      contentPadding: const EdgeInsets.all(16),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: darkGreen, width: 2),
                      ),
                    ),
                  ),
                ],
              ),

              // 7. CARD 4: REDE DE APOIO
              _buildSectionCard(
                stepNumber: '4',
                title: 'Rede de Apoio',
                children: [
                  _buildInputField('Convidar familiar ou cuidador (E-mail)', 'email@exemplo.com', keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 16),
                  // Botão Outlined representando a ação de adicionar extra
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add, color: darkGreen),
                    label: const Text(
                      'Adicionar outro familiar',
                      style: TextStyle(color: darkGreen, fontWeight: FontWeight.bold),
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      side: const BorderSide(color: darkGreen, width: 1.5), // Borda visível para acessibilidade
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 8. CALL TO ACTION FINAL
              ElevatedButton(
                onPressed: () {
                  // Ação de concluir o cadastro
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkGreen,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56), // 56px height
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Concluir cadastro e Entrar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 9. TERMOS DE USO (Rodapé)
              Center(
                child: Text(
                  'Ao concluir, você concorda com nossos\nTermos de Uso e Política de Privacidade.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // ==== WIDGETS AUXILIARES E MODULARES ====

  /// Cria uma linha de progresso
  Widget _buildProgressSegment(Color color) {
    return Expanded(
      child: Container(
        height: 6,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  /// Constrói um Card de Seção com número, título e conteúdo dinâmico
  Widget _buildSectionCard({
    required String stepNumber,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header do Card
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: darkGreen,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    stepNumber,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: darkGreen,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Corpo do Card (Campos)
          ...children,
        ],
      ),
    );
  }

  /// Constrói um campo de texto com label externa (Excelente para acessibilidade)
  Widget _buildInputField(
    String label,
    String hint, {
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    IconData? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: darkGreen) : null,
            // Mantém os 56px de altura para excelente área de toque
            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: darkGreen, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
