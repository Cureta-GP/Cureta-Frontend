import 'package:get_it/get_it.dart';
import 'package:cureta/features/authentcation/data/services/auth_service.dart';
import 'package:cureta/features/authentcation/data/repo/auth_repository.dart';

final getIt = GetIt.instance;
void setup() {
  // 🧱 Services
  getIt.registerSingleton<AuthService>(AuthService());

  // 📦 Repositories
  getIt.registerSingleton<AuthRepository>(
    AuthRepository(getIt.get<AuthService>()),
  );
}
