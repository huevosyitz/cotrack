import "package:cotrack/core/repo/repo.dart";
import "package:cotrack/core/services/services.dart";
import "package:cotrack/core/state/app_state.dart";
import "package:watch_it/watch_it.dart";

class Registrations {
  static void setup() {
    // Services
    di.registerSingleton<AuthService>(AuthService());
    di.registerSingleton<UserService>(UserService());
    di.registerSingleton<TransactionCategoryRepository>(
        TransactionCategoryRepository());

    di.registerSingleton<TransactionCategoryService>(
        TransactionCategoryService(di.get()));

    // States
    di.registerSingleton<AppState>(AppState());
  }
}
