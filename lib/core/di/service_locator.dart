import 'package:get_it/get_it.dart';
import '../../services/user_service.dart';
import '../../services/care_service.dart';

/// Instância global do GetIt
final GetIt getIt = GetIt.instance;

/// Função responsável por registrar e injetar todas as dependências do app.
/// Deve ser chamada ANTES do runApp() no main.dart.
void setupServiceLocator() {
  // registerLazySingleton garante que o serviço só será instanciado (na memória)
  // na primeira vez que for chamado. Depois disso, a mesma instância será reutilizada.

  getIt.registerLazySingleton<UserService>(() => UserService());

  getIt.registerLazySingleton<CareService>(() => CareService());

  // Exemplo futuro: getIt.registerLazySingleton<ThemeManager>(() => ThemeManager());
}
