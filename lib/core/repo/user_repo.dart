import 'package:cotrack/core/models/models.dart';
import 'package:cotrack/core/repo/transaction_category_repo.dart';

class UserRepo {
  Future<UserModel> getUser(String userId) async {
    var result =
        await supaClient.from("profiles").select().eq("id", userId).single();

    return UserModel.fromMap(result);
  }
}
