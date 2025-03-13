import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vacuum/providers/auth_provider.dart';
import 'package:vacuum/utils/constants.dart';
import '../home/home_screen.dart';
import 'package:vacuum/services/profile_service.dart'; // Import du service

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _profileService = ProfileService();
  final _skillsController = TextEditingController();
  final _cityController = TextEditingController();
  final _bioController = TextEditingController();

  String _selectedProvince = GabonProvinces.values[0];
  File? _imageFile;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final result = await _profileService.createProfile(
        token: authProvider.token!,
        skills: _skillsController.text,
        province: _selectedProvince,
        city: _cityController.text,
        bio: _bioController.text,
        profilePicture: _imageFile,
      );

      if (result['success']) {
        if (!mounted) return;

        // Rediriger vers la page d'accueil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        setState(() {
          _errorMessage = result['message'];
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade700,
              Colors.blue.shade500,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Créez votre profil',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: _imageFile != null
                                  ? FileImage(_imageFile!)
                                  : null,
                              child: _imageFile == null
                                  ? const Icon(Icons.camera_alt, size: 30)
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _skillsController,
                            decoration: InputDecoration(
                              labelText: 'Compétences',
                              hintText: 'Ex: Ménage, Babysitting, Jardinage',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Ce champ est requis';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _selectedProvince,
                            decoration: InputDecoration(
                              labelText: 'Province',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            items: GabonProvinces.values.map((province) {
                              return DropdownMenuItem(
                                value: province,
                                child: Text(province),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedProvince = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _cityController,
                            decoration: InputDecoration(
                              labelText: 'Ville',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'Ce champ est requis';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _bioController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: 'Bio',
                              hintText: 'Parlez-nous un peu de vous...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          if (_errorMessage != null)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                _errorMessage!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleSubmit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade600,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : const Text('Créer mon profil'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
