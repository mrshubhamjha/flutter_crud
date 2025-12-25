import 'package:flutter_dotenv/flutter_dotenv.dart';

/// App-wide constants
class AppConstants {
  static const String appName = 'Todo Bloc';
  static String get apiBaseUrl => dotenv.env['BASE_URL_APP'] ?? 'https://dummyjson.com';
  
  // Add more constants as needed
}

