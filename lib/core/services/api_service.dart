import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/api_constants.dart';
import '../models/user_model.dart';
import '../models/medication_model.dart';
import '../models/appointment_model.dart';
import '../models/care_task_model.dart';
import '../models/contact_model.dart';

class ApiService {
  static const String _tokenKey = 'auth_token';

  // ==========================================
  // GESTÃO DE TOKEN (SharedPreferences)
  // ==========================================

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    final headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json',
    };
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // ==========================================
  // AUTENTICAÇÃO
  // ==========================================

  Future<UserModel> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/auth/register'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'short_name': name.split(' ').isNotEmpty ? name.split(' ')[0] : name,
          'email': email,
          'password': password,
          'role': 'elderly',
        }),
      );

      final Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));

      if ((response.statusCode == 200 || response.statusCode == 201) && json['success'] == true) {
        final token = json['token'];
        await _saveToken(token); // Guarda o token localmente
        return UserModel.fromJson(json['user']);
      } else {
        throw Exception(json['message'] ?? 'Erro ao criar conta.');
      }
    } catch (e) {
      throw Exception('Falha ao conectar: $e');
    }
  }

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/auth/login'),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200 && json['success'] == true) {
        final token = json['token'];
        await _saveToken(token); // Guarda o token localmente
        return UserModel.fromJson(json['user']);
      } else {
        // Se a API enviou uma mensagem de erro, lançamos ela
        throw Exception(json['message'] ?? 'E-mail ou senha inválidos.');
      }
    } catch (e) {
      throw Exception('Falha ao conectar: $e');
    }
  }

  // ==========================================
  // DADOS DA APLICAÇÃO (Rotas Protegidas)
  // ==========================================

  // 1. GET /users/me -> UserModel
  Future<UserModel> getUserProfile() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/users/me'),
        headers: headers,
      );

      if (response.statusCode == 200) {
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
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/medications/today'),
        headers: headers,
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
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/appointments/upcoming'),
        headers: headers,
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
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/care-tasks/today'),
        headers: headers,
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
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/network/contacts'),
        headers: headers,
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

  // ==========================================
  // CRIAÇÃO DE DADOS (POST)
  // ==========================================

  // 1. POST /appointments -> Criar nova consulta
  Future<bool> createAppointment(String title, String date, String time, String location) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/appointments'),
        headers: headers,
        body: jsonEncode({
          'title': title,
          'date': date,
          'time': time,
          'location': location,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        final Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        throw Exception(json['message'] ?? 'Erro ao criar compromisso.');
      }
    } catch (e) {
      throw Exception('Falha ao conectar: $e');
    }
  }

  // 2. POST /care-tasks -> Criar/Adicionar novos Hábitos
  Future<bool> createCareTasks(List<String> habits) async {
    try {
      final headers = await _getHeaders();
      
      for (String habit in habits) {
        final response = await http.post(
          Uri.parse('${ApiConstants.baseUrl}/care-tasks'),
          headers: headers,
          body: jsonEncode({
            'title': habit,
          }),
        );

        if (response.statusCode != 200 && response.statusCode != 201) {
          print('Erro no Back-end: ${response.body}');
          throw Exception('Falha ao salvar a meta $habit.');
        }
      }

      return true; // Se o loop terminar sem falhas, tudo foi criado com sucesso
    } catch (e) {
      throw Exception('Falha ao conectar: $e');
    }
  }

  // 3. POST /network/contacts -> Adicionar Novo Contato
  Future<bool> createContact(String type, String name, String phone, String relation) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/network/contacts'),
        headers: headers,
        body: jsonEncode({
          'type': type,
          'name': name,
          'phone': phone,
          'relation': relation,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        final Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        throw Exception(json['message'] ?? 'Erro ao criar contato.');
      }
    } catch (e) {
      throw Exception('Falha ao conectar: $e');
    }
  }

  // 4. PUT /appointments/:id -> Editar Consulta
  Future<bool> updateAppointment(String id, String title, String date, String time, String location) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}/appointments/$id'),
        headers: headers,
        body: jsonEncode({
          'title': title,
          'date': date,
          'time': time,
          'location': location,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
        return true;
      } else {
        final Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        throw Exception(json['message'] ?? 'Erro ao atualizar compromisso.');
      }
    } catch (e) {
      throw Exception('Falha ao conectar: $e');
    }
  }

  // 5. DELETE /appointments/:id -> Excluir Consulta
  Future<bool> deleteAppointment(String id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('${ApiConstants.baseUrl}/appointments/$id'),
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
        return true;
      } else {
        final Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        throw Exception(json['message'] ?? 'Erro ao excluir compromisso.');
      }
    } catch (e) {
      throw Exception('Falha ao conectar: $e');
    }
  }

  // 6. DELETE /care-tasks/:id -> Excluir Tarefa de Cuidado
  Future<bool> deleteCareTask(String id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('${ApiConstants.baseUrl}/care-tasks/$id'),
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
        return true;
      } else {
        final Map<String, dynamic> json = jsonDecode(utf8.decode(response.bodyBytes));
        throw Exception(json['message'] ?? 'Erro ao excluir tarefa.');
      }
    } catch (e) {
      throw Exception('Falha ao conectar: $e');
    }
  }
}
