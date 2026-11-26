import 'package:flutter/material.dart';

class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen({super.key});

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _timeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      // Fecha a tela atual
      Navigator.pop(context);
      // Mostra o feedback de que no futuro isto vai pra API
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Em breve: Integração com a API para salvar o medicamento.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Medicamento'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Adicione um novo remédio à rotina.', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 24),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome do remédio',
                  hintText: 'Ex: Losartana',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _dosageController,
                decoration: const InputDecoration(
                  labelText: 'Dosagem',
                  hintText: 'Ex: 50mg',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(
                  labelText: 'Horário',
                  hintText: 'Ex: 09:00',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _saveForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Salvar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
