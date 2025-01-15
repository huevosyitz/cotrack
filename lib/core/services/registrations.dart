import "package:cotrack/core/repo/repo.dart";
import "package:cotrack/core/services/services.dart";
import "package:cotrack/core/state/app_state.dart";
import "package:watch_it/watch_it.dart";

class Registrations {
  static void setup() {
    // Repos
    di.registerSingleton<UserRepo>(UserRepo());
    di.registerSingleton<TransactionRepo>(TransactionRepo());
    di.registerSingleton<TransactionCategoryRepository>(
        TransactionCategoryRepository());

    // Services
    di.registerSingleton<AuthService>(AuthService());
    di.registerSingleton<UserService>(UserService(di.get()));

    di.registerSingleton<TransactionCategoryService>(
        TransactionCategoryService(di.get()));

    di.registerSingleton<TransactionService>(
        TransactionService(di.get(), di.get()));

    // States
    di.registerSingleton<AppState>(AppState());
  }
}
