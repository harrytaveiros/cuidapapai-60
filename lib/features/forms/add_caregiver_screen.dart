import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';

class AddCaregiverScreen extends StatefulWidget {
  const AddCaregiverScreen({super.key});

  @override
  State<AddCaregiverScreen> createState() => _AddCaregiverScreenState();
}

class _AddCaregiverScreenState extends State<AddCaregiverScreen> {
  final _formKey = GlobalKey<FormState>();
  static const Color darkGreen = Color(0xFF126E51);
  bool isFamily = true;
  bool _isLoading = false;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _relationController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _relationController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final type = isFamily ? 'family' : 'professional';
        
        await ApiService().createContact(
          type,
          _nameController.text.trim(),
          _phoneController.text.trim(),
          _relationController.text.trim(),
        );

        if (!mounted) return;
        Navigator.pop(context, true);

      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString().replaceAll('Exception: ', ''),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: darkGreen,
        elevation: 0,
        centerTitle: true,
        title: const Text('Adicionar Contato', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CABEÇALHO
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF9E6), // Amarelo claro
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.groups, color: Color(0xFFFBBF24), size: 32),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Amplie sua rede de apoio',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF000080), // Azul marinho
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // TOGGLE: TIPO DE CONTATO
                const Text(
                  'Tipo de contato',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isFamily = true),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: isFamily ? darkGreen : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                'Familiar',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isFamily ? Colors.white : Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => isFamily = false),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: !isFamily ? darkGreen : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                'Profissional',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: !isFamily ? Colors.white : Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // FORMULÁRIO
                _buildAccessibleInput(
                  label: 'Nome completo',
                  hint: 'Ex.: Ana Paula Silva',
                  controller: _nameController,
                ),
                const SizedBox(height: 20),

                _buildAccessibleInput(
                  label: 'Telefone / WhatsApp',
                  hint: '(00) 00000-0000',
                  controller: _phoneController,
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),

                // CAMPO DINÂMICO
                _buildAccessibleInput(
                  label: isFamily ? 'Grau de parentesco' : 'Especialidade',
                  hint: isFamily ? 'Ex.: Filha' : 'Ex.: Enfermeira',
                  controller: _relationController,
                ),
                const SizedBox(height: 40),

                // BOTÃO SALVAR
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkGreen,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading 
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Salvar Contato', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccessibleInput({
    required String label,
    required String hint,
    required TextEditingController controller,
    IconData? prefixIcon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 16),
          validator: (val) => val == null || val.isEmpty ? 'Campo obrigatório' : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade500),
            prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: darkGreen) : null,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: darkGreen, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
