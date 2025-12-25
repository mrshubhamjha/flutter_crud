import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<UserEntity> execute(String username, String password) async {
    // Business Rule: Validation happens here before hitting the repo
    if (username.trim().isEmpty || password.trim().isEmpty) {
      throw Exception("Username and password are required.");
    }
    return await repository.login(username, password, 30);
  }
}