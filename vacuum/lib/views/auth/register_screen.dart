import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../profile/create_profile_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _telephoneController = TextEditingController();
  String _selectedRole = 'employee';
  bool _isLoading = false;
  bool _obscureText = true;
  bool _obscureConfirmText = true;
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
              Colors.blue.shade600,
              Colors.blue.shade500,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon:
                          const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Vacuum',
                      style: GoogleFonts.poppins(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Créez votre compte',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
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
                  padding: const EdgeInsets.all(24),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Inscription',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 30),
                          _buildTextField(
                            hint: 'Nom complet',
                            icon: Icons.person_outline,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            hint: 'Email',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            hint: 'Téléphone',
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            hint: 'Mot de passe',
                            icon: Icons.lock_outline,
                            isPassword: true,
                            obscureText: _obscureText,
                            onTogglePassword: () =>
                                setState(() => _obscureText = !_obscureText),
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            hint: 'Confirmer le mot de passe',
                            icon: Icons.lock_outline,
                            isPassword: true,
                            obscureText: _obscureConfirmText,
                            onTogglePassword: () => setState(() =>
                                _obscureConfirmText = !_obscureConfirmText),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Type de compte',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          _buildRoleSelection(),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: _isLoading ? null : _handleRegister,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade600,
                              minimumSize: const Size(double.infinity, 55),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    "S'inscrire",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Déjà un compte ?',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'Se connecter',
                                  style: GoogleFonts.poppins(
                                    color: Colors.blue.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
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

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool isPassword = false,
    bool? obscureText,
    VoidCallback? onTogglePassword,
  }) {
    return TextField(
      obscureText: obscureText ?? false,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                    obscureText! ? Icons.visibility_off : Icons.visibility),
                onPressed: onTogglePassword,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildRoleSelection() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: _selectedRole == 'employee'
                    ? Colors.blue.shade50
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(15),
              ),
              child: RadioListTile(
                title: Text('Employé', style: GoogleFonts.poppins()),
                value: 'employee',
                groupValue: _selectedRole,
                onChanged: (value) => setState(() => _selectedRole = value!),
                activeColor: Colors.blue.shade700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: _selectedRole == 'employer'
                    ? Colors.blue.shade50
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(15),
              ),
              child: RadioListTile(
                title: Text('Employeur', style: GoogleFonts.poppins()),
                value: 'employer',
                groupValue: _selectedRole,
                onChanged: (value) => setState(() => _selectedRole = value!),
                activeColor: Colors.blue.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<AuthProvider>(context, listen: false).register(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          passwordConfirmation: _passwordConfirmController.text,
          telephone: _telephoneController.text,
          role: _selectedRole,
        );
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CreateProfileScreen()),
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
