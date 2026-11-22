import 'package:get_it/get_it.dart';
import 'services/user_service.dart';
import 'services/care_service.dart';

/// Instância global do GetIt
final GetIt locator = GetIt.instance;

/// Configura a Injeção de Dependências.
/// Deve ser chamada no main.dart antes do runApp().
void setupLocator() {
  // registerLazySingleton cria a instância apenas quando ela for solicitada
  // pela primeira vez, economizando memória no carregamento do app.

  locator.registerLazySingleton<UserService>(() => UserService());
  locator.registerLazySingleton<CareService>(() => CareService());
}
