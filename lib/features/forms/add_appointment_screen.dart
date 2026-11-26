import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';

class AddAppointmentScreen extends StatefulWidget {
  const AddAppointmentScreen({super.key});

  @override
  State<AddAppointmentScreen> createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  static const Color darkGreen = Color(0xFF126E51);
  static const Color lightBlue = Color(0xFFE0E7FF);

  // Controllers
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _locationController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      try {
        await ApiService().createAppointment(
          _titleController.text.trim(),
          _dateController.text.trim(),
          _timeController.text.trim(),
          _locationController.text.trim(),
        );

        if (!mounted) return;
        Navigator.pop(context, true); // Retorna true para a tela anterior dar um refresh opcional
        
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
      backgroundColor: const Color(0xFFF8FAFC), // Fundo cinza bem claro
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: darkGreen,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Nova Consulta',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
                        color: lightBlue,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.calendar_month, color: Color(0xFF000080), size: 32),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Organize seu compromisso',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF000080),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Preencha as informações da consulta.',
                            style: TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // FORMULÁRIO (Labels Externas)
                _buildAccessibleInput(
                  label: 'Título da consulta',
                  hint: 'Ex.: Consulta com cardiologista',
                  controller: _titleController,
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildAccessibleInput(
                        label: 'Data',
                        hint: 'dd/mm/aaaa',
                        controller: _dateController,
                        suffixIcon: Icons.calendar_today,
                        keyboardType: TextInputType.datetime,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 2,
                      child: _buildAccessibleInput(
                        label: 'Horário',
                        hint: '--:--',
                        controller: _timeController,
                        suffixIcon: Icons.access_time, // Conforme Figma (ícone relógio)
                        keyboardType: TextInputType.datetime,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                _buildAccessibleInput(
                  label: 'Local ou Médico',
                  hint: 'Ex.: Clínica São Lucas - Dr. Roberto',
                  controller: _locationController,
                ),
                const SizedBox(height: 40),

                // BOTÃO SALVAR
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _saveForm,
                  icon: _isLoading 
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.check_circle, size: 24),
                  label: Text(
                    _isLoading ? 'Salvando...' : 'Salvar',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkGreen,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // WIDGET HELPER: Label Externa + TextFormField limpo (Padrão Acessibilidade)
  Widget _buildAccessibleInput({
    required String label,
    required String hint,
    required TextEditingController controller,
    IconData? suffixIcon,
    TextInputType? keyboardType,
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
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 16),
          validator: (val) => val == null || val.isEmpty ? 'Campo obrigatório' : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade500),
            suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: darkGreen) : null,
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
