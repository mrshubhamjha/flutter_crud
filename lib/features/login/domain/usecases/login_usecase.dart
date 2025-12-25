import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use Case - Contains business logic for a specific operation
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<User> call(String email, String password) {
    // Business logic validation can go here
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password cannot be empty');
    }
    return repository.login(email, password);
  }
}

