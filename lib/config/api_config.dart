import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl {
    String host = dotenv.env['API_BASE_URL'] ?? 'http://localhost:8000';
    
    // Otomatis convert localhost ke 10.0.2.2 untuk Android Emulator
    if (!kIsWeb && Platform.isAndroid && host.contains('localhost')) {
      host = host.replaceAll('localhost', '10.0.2.2');
    }
    
    return host;
  }
  
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
}