import '../models/user_model.dart';

/// Remote Data Source - Handles API calls
abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<void> logout();
}

/// Implementation example (you would implement actual API calls here)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> login(String email, String password) async {
    // TODO: Implement actual API call using dotenv.env['BASE_URL_APP']
    // Example:
    // final response = await http.post(
    //   Uri.parse('${Environment.baseUrl}/auth/login'),
    //   body: {'username': email, 'password': password},
    // );
    // return UserModel.fromJson(response.data);
    
    // Mock implementation for now
    await Future.delayed(const Duration(seconds: 1));
    return UserModel(
      id: '1',
      email: email,
      name: 'User Name',
    );
  }

  @override
  Future<void> logout() async {
    // TODO: Implement logout API call
    await Future.delayed(const Duration(milliseconds: 500));
  }
}

