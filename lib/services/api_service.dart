import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // Tambahkan ini
import '../models/cart_model.dart';

class ApiService {
  static const String baseUrl = 'http://YOUR_SERVER_IP/mobile-shop'; // Ganti dengan URL server Anda
  
  // Register
  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'full_name': fullName,
          'phone': phone ?? '',
        }),
      );
      
      return jsonDecode(response.body);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Register error: $e');
      }
      return {'status': 'error', 'message': 'Terjadi kesalahan: $e'};
    }
  }
  
  // Login
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      
      return jsonDecode(response.body);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Login error: $e');
      }
      return {'status': 'error', 'message': 'Terjadi kesalahan: $e'};
    }
  }
  
  // Add to Cart
  static Future<Map<String, dynamic>> addToCart({
    required int userId,
    required int productId,
    int quantity = 1,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/cart_add.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'product_id': productId,
          'quantity': quantity,
        }),
      );
      
      return jsonDecode(response.body);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Add to cart error: $e');
      }
      return {'status': 'error', 'message': 'Terjadi kesalahan: $e'};
    }
  }
  
  // Get Cart
  static Future<CartResponse?> getCart(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/cart_get.php?user_id=$userId'),
      );
      
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        return CartResponse.fromJson(data);
      }
      return null;
    } catch (e) {
      // ✅ PERBAIKAN: Ganti print dengan debugPrint
      if (kDebugMode) {
        debugPrint('Error getting cart: $e');
      }
      return null;
    }
  }
  
  // Update Cart Quantity
  static Future<Map<String, dynamic>> updateCartQuantity({
    required int cartId,
    required int quantity,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/cart_update.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'cart_id': cartId,
          'quantity': quantity,
        }),
      );
      
      return jsonDecode(response.body);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Update cart error: $e');
      }
      return {'status': 'error', 'message': 'Terjadi kesalahan: $e'};
    }
  }
  
  // Delete Cart Item
  static Future<Map<String, dynamic>> deleteCartItem(int cartId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/cart_delete.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'cart_id': cartId,
        }),
      );
      
      return jsonDecode(response.body);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Delete cart item error: $e');
      }
      return {'status': 'error', 'message': 'Terjadi kesalahan: $e'};
    }
  }
}
