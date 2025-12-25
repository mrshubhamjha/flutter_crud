// The Payload we send to the server
class LoginRequest {
  final String username;
  final String password;
  final int expiresInMins;

  LoginRequest({
    required this.username,
    required this.password,
    required this.expiresInMins,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
    'expiresInMins': expiresInMins,
  };
}

// The Response we get back from the server
class LoginModel {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String gender;
  final String image;
  final String? accessToken; // Optional because /me doesn't return it
  final String? refreshToken; // Optional because /me doesn't return it

  LoginModel({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.image,
    this.accessToken,
    this.refreshToken,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      gender: json['gender'] as String,
      image: json['image'] as String,
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
    );
  }
}

// Refresh Token Response Model
class RefreshTokenModel {
  final String accessToken;
  final String refreshToken;

  RefreshTokenModel({
    required this.accessToken,
    required this.refreshToken,
  });

  factory RefreshTokenModel.fromJson(Map<String, dynamic> json) {
    return RefreshTokenModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }
}

// Refresh Token Request Model
class RefreshTokenRequest {
  final String? refreshToken; // Optional, if not provided, server uses cookie
  final int? expiresInMins; // Optional, defaults to 60

  RefreshTokenRequest({
    this.refreshToken,
    this.expiresInMins,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (refreshToken != null) {
      json['refreshToken'] = refreshToken;
    }
    if (expiresInMins != null) {
      json['expiresInMins'] = expiresInMins;
    }
    return json;
  }
}