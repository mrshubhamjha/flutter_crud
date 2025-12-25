import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../config/environment_config.dart';

/// App-wide constants
class AppConstants {
  static const String appName = 'Todo Bloc';
  static String get apiBaseUrl => dotenv.env['BASE_URL_APP'] ?? '';
  static String get environment => EnvironmentConfig.environment;
  static bool get isProduction => EnvironmentConfig.isProduction;
  
  // Add more constants as needed
}

