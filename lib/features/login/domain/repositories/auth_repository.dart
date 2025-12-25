import '../entities/user.dart';

abstract class AuthRepository {
  // Logic for POST /auth/login
  Future<UserEntity> login(String username, String password, int? expiresInMins);

  // Logic for GET /auth/me
  Future<UserEntity> getCurrentUser(String token);

  // Logic for POST /auth/refresh
  // We return a Map or a specific TokenEntity for the new tokens
  Future<Map<String, String>> refreshSession(String refreshToken, int? expiresInMins);
}