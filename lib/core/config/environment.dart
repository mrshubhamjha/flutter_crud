import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration
/// Loads values from .env files using flutter_dotenv
class Environment {
  static String get baseUrl => dotenv.env['BASE_URL'] ?? 'https://dummyjson.com';
  static String get env => dotenv.env['ENV'] ?? 'development';
  
  // Add more environment variables as needed
  // static String get apiKey => dotenv.env['API_KEY'] ?? '';
  // static bool get isProduction => env == 'production';
}

