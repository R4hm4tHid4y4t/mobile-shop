import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl {
    return dotenv.env['API_BASE_URL'] ?? 'http://192.168.1.12';
  }
  
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
}