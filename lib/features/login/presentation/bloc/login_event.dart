import 'package:equatable/equatable.dart';

/// BLoC Events - Define what actions can be triggered
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends LoginEvent {
  final String username;
  final String password;

  const LoginSubmitted({
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [username, password];
}
