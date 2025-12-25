import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment Configuration
/// Automatically loads the correct .env file based on build mode or dart-define
class EnvironmentConfig {
  /// Loads environment file based on:
  /// 1. --dart-define=ENV=prod or --dart-define=ENV=dev (explicit)
  /// 2. kDebugMode (debug = dev, release = prod)
  static Future<void> load() async {
    // Check for explicit ENV from --dart-define flag
    const envFromDefine = String.fromEnvironment('ENV', defaultValue: '');
    
    String envFile;
    if (envFromDefine.isNotEmpty) {
      // Use explicit env from --dart-define
      envFile = envFromDefine == 'prod' ? 'env/.env.prod' : 'env/.env.dev';
    } else {
      // Auto-detect based on build mode
      // Debug mode = dev, Release mode = prod
      envFile = kDebugMode ? 'env/.env.dev' : 'env/.env.prod';
    }
    
    try {
      await dotenv.load(fileName: envFile);
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Failed to load $envFile: $e');
        print('💡 Make sure the file exists and is properly formatted.');
      }
      rethrow;
    }
    
    if (kDebugMode) {
      print('🌍 Loaded environment: $envFile');
      print('📍 Base URL: ${dotenv.env['BASE_URL_APP'] ?? "NOT SET"}');
      print('🔐 BASE_AUTH_URL: ${dotenv.env['BASE_AUTH_URL'] ?? "NOT SET"}');
      print('📋 All env keys: ${dotenv.env.keys.toList()}');
      if (dotenv.env['BASE_AUTH_URL'] == null) {
        print('❌ WARNING: BASE_AUTH_URL is missing! Add it to $envFile');
      }
    }
  }
  
  /// Get current environment name
  static String get environment => 
      dotenv.env['ENVIRONMENT'] ?? 
      dotenv.env['ENV']?.toUpperCase() ?? 
      'DEVELOPMENT';
  
  /// Check if running in production
  static bool get isProduction => environment == 'PRODUCTION';
  
  /// Check if running in development
  static bool get isDevelopment => environment == 'DEVELOPMENT';
}

