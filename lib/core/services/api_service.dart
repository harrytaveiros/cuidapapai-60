import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../models/user_model.dart';
import '../models/medication_model.dart';
import '../models/appointment_model.dart';
import '../models/care_task_model.dart';
import '../models/contact_model.dart';

class ApiService {
  /// Retorna o cabeçalho base de autorização para cada requisição.
  /// (No futuro, você buscará o Bearer token salvo localmente).
  Map<String, String> get _headers => {
        'Content-Type': 'application/json; charset=utf-8',
        'Accept': 'application/json',
        // 'Authorization': 'Bearer <MEU_TOKEN_SALVO>',
      };

  // 1. GET /users/me -> UserModel
  Future<UserModel> getUserProfile() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/users/me'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        // Usa utf8.decode para evitar problemas de acentuação como "ç" e "ã"
        final Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        return UserModel.fromJson(json);
      } else {
        throw Exception('Erro ao carregar o perfil do usuário (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Falha de conexão ao tentar buscar o perfil: $e');
    }
  }

  // 2. GET /medications/today -> List<MedicationModel>
  Future<List<MedicationModel>> getTodayMedications() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/medications/today'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(utf8.decode(response.bodyBytes));
        return jsonList.map((json) => MedicationModel.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao carregar os medicamentos (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Falha de conexão ao tentar buscar os medicamentos: $e');
    }
  }

  // 3. GET /appointments/upcoming -> List<AppointmentModel>
  Future<List<AppointmentModel>> getUpcomingAppointments() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/appointments/upcoming'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(utf8.decode(response.bodyBytes));
        return jsonList.map((json) => AppointmentModel.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao carregar os compromissos (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Falha de conexão ao tentar buscar os compromissos: $e');
    }
  }

  // 4. GET /care-tasks/today -> List<CareTaskModel>
  Future<List<CareTaskModel>> getTodayCareTasks() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/care-tasks/today'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(utf8.decode(response.bodyBytes));
        return jsonList.map((json) => CareTaskModel.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao carregar as tarefas de cuidado (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Falha de conexão ao tentar buscar as tarefas de cuidado: $e');
    }
  }

  // 5. GET /network/contacts -> List<ContactModel>
  Future<List<ContactModel>> getNetworkContacts() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/network/contacts'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(utf8.decode(response.bodyBytes));
        return jsonList.map((json) => ContactModel.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao carregar a rede de contatos (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Falha de conexão ao tentar buscar a rede de contatos: $e');
    }
  }
}
