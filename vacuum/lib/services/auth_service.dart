import 'dart:convert';
import 'package:http/http.dart' as http;


class AuthService {

  final String _baseUrl = 'http://127.0.0.1:8000/api';



  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'), // Endpoint de connexion
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Echec de la connexion');
    }
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String telephone,
    required String role,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'telephone': telephone,
          'role': role,
        }),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return {
          'success': true,
          'user': responseData['user'],
          'token': responseData['token'],
        };
      } else {
        final errorData = jsonDecode(response.body);
        return {'success': false, 'message': errorData['message']};
      }
    } catch (e) {
      return {'success': false, 'message': 'Une erreur est survenue: $e'};
    }
  }
}