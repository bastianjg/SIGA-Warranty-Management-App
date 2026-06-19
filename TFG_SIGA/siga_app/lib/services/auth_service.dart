import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';

class AuthService {

  Future<bool> login({
    required String email,
    required String password,
  }) async {

    final response = await http.post(
      Uri.parse('${ApiService.baseUrl}/auth/login'),

      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('token', data['token']);
      await prefs.setString('nombre', data['nombre']);

      return true;
    }

    return false;
  }

  Future<int?> getUserId() async {

    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt('userId');
  }

  Future<bool> isLoggedIn() async {

    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('token') != null;
  }

  Future<void> logout() async {

  final prefs =
        await SharedPreferences.getInstance();

      await prefs.remove('token');
      await prefs.remove('userId');
      await prefs.remove('nombre');
    }

    Future<bool> sendCode({
    required String nombre,
    required String email,
    required String password,
  }) async {

    final response = await http.post(
      Uri.parse('${ApiService.baseUrl}/auth/send-code'),

      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode({
        'nombre': nombre,
        'email': email,
        'password': password,
      }),
    );

    return response.statusCode == 200;
  }

  Future<void> verifyCode({
    required String email,
    required int codigo,
  }) async {

    final response = await http.post(

      Uri.parse('${ApiService.baseUrl}/auth/verify-code'),

      headers: {
        'Content-Type': 'application/json',
      },

      body: jsonEncode({
        'email': email,
        'codigo': codigo,
      }),
    );

    if (response.statusCode != 200) {

      throw Exception(
        response.body,
      );
    }
  }
}