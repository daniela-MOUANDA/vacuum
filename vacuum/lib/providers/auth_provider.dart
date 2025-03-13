import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final _authService = AuthService();
  Map<String, dynamic>? _user;
  String? _token;

  Map<String, dynamic>? get user => _user;
  String? get token => _token;
  
  // Méthode pour définir l'utilisateur et le token
  void setUser(Map<String, dynamic> user, String token) {
    _user = user;
    _token = token;
    notifyListeners(); // Notifie les écrans qui écoutent ce provider
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String telephone,
    required String role,
  }) async {
    try {
      print('Attempting registration with data: $email, $role');
      final result = await _authService.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        telephone: telephone,
        role: role,
      );

      print('Registration response: $result');

      if (result['success']) {
        _user = result['user'];
        _token = result['token'];
        await _saveToStorage();
        notifyListeners();
        return true;
      } else {
        throw Exception(result['message'] ?? 'Erreur d\'inscription');
      }
    } catch (e) {
      print('Registration error: $e');
      rethrow;
    }
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_token != null) {
        await prefs.setString('token', _token!);
      }
      if (_user != null) {
        await prefs.setString('user', jsonEncode(_user));
      }
    } catch (e) {
      print('Error saving to storage: $e');
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      _user = null;
      _token = null;
      notifyListeners();
    } catch (e) {
      print('Logout error: $e');
      rethrow;
    }
  }
}