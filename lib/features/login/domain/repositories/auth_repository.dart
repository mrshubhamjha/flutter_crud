import '../entities/user.dart';

/// Repository Interface - Defines what operations are available
/// Implementation will be in the data layer
abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<void> logout();
  Future<User?> getCurrentUser();
}

