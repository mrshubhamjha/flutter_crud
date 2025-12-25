import '../../domain/entities/user.dart';

/// Data Model - Handles JSON serialization/deserialization
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
    };
  }

  // Convert to domain entity (though in this case it already extends it)
  User toEntity() {
    return User(id: id, email: email, name: name);
  }
}

