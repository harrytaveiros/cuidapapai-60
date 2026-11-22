/// Serviço responsável pelos dados do usuário atual (Idoso ou Cuidador).
class UserService {
  // Dado mockado. No futuro, isso pode vir de uma API, Firebase ou banco local.
  String get nomeUsuario => 'Dona Maria';

  // Espaço para futuras regras de negócio, como:
  // bool get isCuidador => false;
  // Future<void> loadUserProfile() async { ... }
}
