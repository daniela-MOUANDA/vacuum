import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth/login_screen.dart';  // Ajoutez cet import

class WelcomeScreen extends StatefulWidget {  // Changez en StatefulWidget
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isLoading = false;  // Ajoutez cette variable

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.white,
              Colors.blue.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Container(
                  height: 180,
                  width: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20), // Coins légèrement arrondis
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20), // Même rayon que le Container
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Text(
                  'Vacuum House',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E1E1E),
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Trouvez les meilleurs services domestiques en quelques clics',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),
                const Spacer(),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade400,
                          Colors.blue.shade600,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _isLoading 
                          ? null 
                          : () async {
                              setState(() => _isLoading = true);
                              await Future.delayed(const Duration(milliseconds: 800));
                              if (!mounted) return;
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        minimumSize: const Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Commencer',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}