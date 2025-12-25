import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserEntity> login(String username, String password, int? expiresInMins) async {
    // 1. Convert inputs to a Request Model
    final request = LoginRequest(
      username: username, 
      password: password, 
      expiresInMins: expiresInMins ?? 30,
    );

    // 2. Call the Remote Data Source
    final loginModel = await remoteDataSource.login(request);

    // 3. MAP: Transform the Data Model into a Domain Entity
    return _mapToEntity(loginModel);
  }

  @override
  Future<UserEntity> getCurrentUser(String token) async {
    final loginModel = await remoteDataSource.getMe(token);
    return _mapToEntity(loginModel);
  }

  @override
  Future<Map<String, String>> refreshSession(String refreshToken, int? expiresInMins) async {
    final request = RefreshTokenRequest(
      refreshToken: refreshToken,
      expiresInMins: expiresInMins,
    );
    
    final refreshModel = await remoteDataSource.refreshToken(request);
    
    return {
      'accessToken': refreshModel.accessToken,
      'refreshToken': refreshModel.refreshToken,
    };
  }

  // Private helper to convert LoginModel -> UserEntity
  UserEntity _mapToEntity(LoginModel model) {
    return UserEntity(
      id: model.id,
      username: model.username,
      email: model.email,
      firstName: model.firstName,
      lastName: model.lastName,
      image: model.image,
      accessToken: model.accessToken,
      refreshToken: model.refreshToken,
    );
  }
}