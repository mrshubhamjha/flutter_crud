import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'features/login/data/datasources/auth_remote_datasource.dart';
import 'features/login/data/repositories/auth_repository_impl.dart';
import 'features/login/domain/repositories/auth_repository.dart';
import 'features/login/domain/usecases/login_usecase.dart';
import 'features/login/presentation/bloc/login_bloc.dart';
import 'features/login/presentation/pages/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  // For dev: await dotenv.load(fileName: "env/environment.dev.env");
  // For prod: await dotenv.load(fileName: "env/environment.env");
  // Default: loads env/environment.env (production)
  await dotenv.load(fileName: "env/environment.env");
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo Bloc',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Dependency Injection - Provide BLoC and dependencies
      home: BlocProvider(
        create: (context) {
          // Create the dependency chain
          final AuthRemoteDataSource remoteDataSource =
              AuthRemoteDataSourceImpl();
          final AuthRepository repository =
              AuthRepositoryImpl(remoteDataSource);
          final LoginUseCase loginUseCase = LoginUseCase(repository);
          return LoginBloc(loginUseCase: loginUseCase);
        },
        child: const LoginPage(),
      ),
    );
  }
}
