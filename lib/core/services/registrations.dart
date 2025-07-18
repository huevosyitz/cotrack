import "package:cotrack/core/state/app_state.dart";
import "package:cotrack/features/accounts/transaction_account_repo.dart";
import "package:cotrack/features/accounts/transaction_account_service.dart";
import "package:cotrack/features/auth/auth.dart";
import "package:cotrack/features/category/transaction_category_repo.dart";
import "package:cotrack/features/category/transaction_category_service.dart";
import "package:cotrack/features/transactions/transaction_repo.dart";
import "package:cotrack/features/transactions/transaction_service.dart";
import "package:watch_it/watch_it.dart";

class Registrations {
  static void setup() {
    // Repos
    di.registerSingleton<UserRepo>(UserRepo());
    di.registerSingleton<TransactionRepo>(TransactionRepo());
    di.registerSingleton<TransactionAccountRepository>(
        TransactionAccountRepository());
    di.registerSingleton<TransactionCategoryRepository>(
        TransactionCategoryRepository());

    // Services
    di.registerSingleton<AuthService>(AuthService());
    di.registerSingleton<UserService>(UserService(di.get()));

    di.registerSingleton<TransactionCategoryService>(
        TransactionCategoryService(di.get()));
    di.registerSingleton<TransactionAccountService>(
        TransactionAccountService(di.get()));

    di.registerSingleton<TransactionService>(
        TransactionService(di.get(), di.get()));

    // States
    di.registerSingleton<AppState>(AppState());
  }
}
