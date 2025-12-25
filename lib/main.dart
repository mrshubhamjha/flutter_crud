import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/config/environment_config.dart';
import 'core/services/http_service.dart';
import 'features/login/data/datasources/auth_remote_datasource.dart';
import 'features/login/data/repositories/auth_repository_impl.dart';
import 'features/login/domain/usecases/login_usecase.dart';
import 'features/login/presentation/bloc/login_bloc.dart';
import 'features/login/presentation/pages/login_page.dart';
import 'features/todo/data/datasources/todo_remote_datasource.dart';
import 'features/todo/data/repositories/todo_repository_impl.dart';
import 'features/todo/domain/usecases/get_todos_usecase.dart';
import 'features/todo/domain/usecases/add_todo_usecase.dart';
import 'features/todo/domain/usecases/update_todo_usecase.dart';
import 'features/todo/domain/usecases/delete_todo_usecase.dart';
import 'features/todo/presentation/bloc/todo_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Automatically loads the correct .env file:
  // - Debug mode -> env/.env.dev
  // - Release mode -> env/.env.prod
  // - Or use --dart-define=ENV=prod for explicit control
  await EnvironmentConfig.load();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Dependency Injection Setup
    final httpService = HttpService();
    
    // Auth dependencies
    final authRemoteDataSource = AuthRemoteDataSourceImpl(httpService: httpService);
    final authRepository = AuthRepositoryImpl(remoteDataSource: authRemoteDataSource);
    final loginUseCase = LoginUseCase(authRepository);
    
    // Todo dependencies
    final todoRemoteDataSource = TodoRemoteDataSourceImpl(httpService: httpService);
    final todoRepository = TodoRepositoryImpl(remoteDataSource: todoRemoteDataSource);
    final getTodosUseCase = GetTodosUseCase(todoRepository);
    final addTodoUseCase = AddTodoUseCase(todoRepository);
    final updateTodoUseCase = UpdateTodoUseCase(todoRepository);
    final deleteTodoUseCase = DeleteTodoUseCase(todoRepository);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(loginUseCase: loginUseCase),
        ),
        BlocProvider(
          create: (context) => TodoBloc(
            getTodosUseCase: getTodosUseCase,
            addTodoUseCase: addTodoUseCase,
            updateTodoUseCase: updateTodoUseCase,
            deleteTodoUseCase: deleteTodoUseCase,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Todo Bloc',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const LoginPage(),
      ),
    );
  }
}
