import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ProfileService {
  final String _baseUrl = 'http://localhost:8000/api'; // Remplace par ton URL

  Future<Map<String, dynamic>> createProfile({
    required String token,
    required String skills,
    required String province,
    required String city,
    required String bio,
    required File? profilePicture,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/profile'),
      );

      // Ajouter les champs du formulaire
      request.fields['skills'] = skills;
      request.fields['province'] = province;
      request.fields['city'] = city;
      request.fields['bio'] = bio;

      // Ajouter l'image de profil si elle existe
      if (profilePicture != null) {
        final file = await http.MultipartFile.fromPath(
          'profile_picture',
          profilePicture.path,
          contentType: MediaType('image', 'jpeg'), // Ajuste le type MIME si nécessaire
        );
        request.files.add(file);
      }

      // Ajouter le token d'authentification
      request.headers['Authorization'] = 'Bearer $token';

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        return {'success': true, 'message': 'Profil créé avec succès'};
      } else {
        final errorData = jsonDecode(responseData);
        return {'success': false, 'message': errorData['message']};
      }
    } catch (e) {
      return {'success': false, 'message': 'Une erreur est survenue: $e'};
    }
  }
}