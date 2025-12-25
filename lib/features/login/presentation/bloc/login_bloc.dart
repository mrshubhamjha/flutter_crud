import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

/// BLoC - Manages state and business logic for the login feature
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase loginUseCase;

  LoginBloc({required this.loginUseCase}) : super(const LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());
    
    try {
      final user = await loginUseCase.execute(event.username, event.password);
      emit(LoginSuccess(user));
    } catch (e) {
      emit(LoginError(e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
