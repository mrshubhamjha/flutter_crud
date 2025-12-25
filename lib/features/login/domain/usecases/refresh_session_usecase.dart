import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RefreshSessionUseCase {
  final AuthRepository repository;

  RefreshSessionUseCase(this.repository);

  Future<Map<String, String>> execute(String refreshToken) async {
    return await repository.refreshSession(refreshToken, 30);
  }
}