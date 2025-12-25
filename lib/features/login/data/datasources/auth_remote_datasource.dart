import 'dart:convert';
import '../../../../core/services/http_service.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginModel> login(LoginRequest request);
  Future<LoginModel> getMe(String token);
  Future<RefreshTokenModel> refreshToken(RefreshTokenRequest request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final HttpService httpService;

  AuthRemoteDataSourceImpl({required this.httpService});

  @override
  Future<LoginModel> login(LoginRequest request) async {
    final response = await httpService.post(
      baseUrlKey: 'BASE_AUTH_URL',
      endpoint: '/auth/login',
      body: request.toJson(),
    );
    
    // response.body is the raw JSON string
    return LoginModel.fromJson(jsonDecode(response.body));
  }

  @override
  Future<LoginModel> getMe(String token) async {
    // This call requires the Bearer token in the header
    final response = await httpService.get(
      baseUrlKey: 'BASE_AUTH_URL',
      endpoint: '/auth/me',
      token: token, // HttpService will attach this as 'Authorization': 'Bearer $token'
    );
    
    return LoginModel.fromJson(jsonDecode(response.body));
  }

  @override
  Future<RefreshTokenModel> refreshToken(RefreshTokenRequest request) async {
    final response = await httpService.post(
      baseUrlKey: 'BASE_AUTH_URL',
      endpoint: '/auth/refresh',
      body: request.toJson(),
    );
    
    return RefreshTokenModel.fromJson(jsonDecode(response.body));
  }
}