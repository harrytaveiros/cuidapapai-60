import 'package:flutter/material.dart';
import '../../core/models/appointment_model.dart';
import '../../core/services/api_service.dart';

class EditAppointmentScreen extends StatefulWidget {
  final AppointmentModel appointment;

  const EditAppointmentScreen({super.key, required this.appointment});

  @override
  State<EditAppointmentScreen> createState() => _EditAppointmentScreenState();
}

class _EditAppointmentScreenState extends State<EditAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  static const Color darkGreen = Color(0xFF126E51);
  static const Color lightBlue = Color(0xFFE0E7FF);

  late TextEditingController _titleController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late TextEditingController _locationController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Preenche os campos com os dados existentes da consulta
    _titleController = TextEditingController(text: widget.appointment.title);
    _dateController = TextEditingController(text: widget.appointment.date);
    _timeController = TextEditingController(text: widget.appointment.time);
    _locationController = TextEditingController(text: widget.appointment.subtitle); // Assumindo location no subtitle
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _updateForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        await ApiService().updateAppointment(
          widget.appointment.id,
          _titleController.text.trim(),
          _dateController.text.trim(),
          _timeController.text.trim(),
          _locationController.text.trim(),
        );

        if (!mounted) return;
        Navigator.pop(context, true); // Retorna true informando que houve alteração

      } catch (e) {
        if (!mounted) return;
        _showErrorSnackBar(e.toString());
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _deleteAppointment() async {
    setState(() => _isLoading = true);
    try {
      await ApiService().deleteAppointment(widget.appointment.id);

      if (!mounted) return;
      // Retorna true informando que houve alteração (exclusão) para recarregar a lista
      Navigator.pop(context, true);
      Navigator.pop(context, true); // Fecha o AlertDialog E o Ecrã atual

    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Fecha o AlertDialog
      _showErrorSnackBar(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Excluir Consulta', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
        content: const Text('Tem a certeza que deseja excluir esta consulta? Esta ação não pode ser desfeita.', style: TextStyle(fontSize: 16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            onPressed: _deleteAppointment,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Excluir', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message.replaceAll('Exception: ', ''),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
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
        title: const Text('Editar Consulta', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            tooltip: 'Excluir Consulta',
            onPressed: _isLoading ? null : _showDeleteConfirmation,
          ),
          const SizedBox(width: 8),
        ],
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
                      child: const Icon(Icons.edit_calendar, color: Color(0xFF000080), size: 32),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Atualizar compromisso',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF000080)),
                          ),
                          SizedBox(height: 4),
                          Text('Altere as informações da consulta.', style: TextStyle(fontSize: 14, color: Colors.black54)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // FORMULÁRIO
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
                        suffixIcon: Icons.access_time,
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

                // BOTÃO SALVAR ALTERAÇÕES
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _updateForm,
                  icon: _isLoading
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.check_circle, size: 24),
                  label: Text(
                    _isLoading ? 'Salvando...' : 'Salvar Alterações',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkGreen,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
