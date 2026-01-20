import '../database/database_provider.dart';
import '../models/user_model.dart';
import '../security/crypto_util.dart';

class AuthService {
  Future<UserModel?> login(String username, String password) async {
    final user = await db.getUser(username);
    if (user == null) return null;

    return CryptoUtil.hashPassword(password) == user.passwordHash
        ? user
        : null;
  }
}
