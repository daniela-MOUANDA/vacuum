import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart'; // Import pour AuthProvider

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final isEmployee = user?.role == 'employee';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade600,
        title: Text(
          'Vacuum',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              // TODO: Implémenter les notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white),
            onPressed: () {
              // TODO: Navigation vers le profil
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          // Page d'accueil
          _buildHomeTab(isEmployee),
          // Page de recherche
          _buildSearchTab(isEmployee),
          // Page des messages
          _buildMessagesTab(),
          // Page des paramètres
          _buildSettingsTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue.shade600,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Rechercher',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            activeIcon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Paramètres',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab(bool isEmployee) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          isEmployee ? 'Offres disponibles' : 'Employés disponibles',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        // TODO: Ajouter la liste des offres ou des employés
      ],
    );
  }

  Widget _buildSearchTab(bool isEmployee) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Rechercher...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Filtres',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          // TODO: Ajouter les filtres de recherche
        ],
      ),
    );
  }

  Widget _buildMessagesTab() {
    return ListView.builder(
      itemCount: 0, // TODO: Remplacer par le nombre réel de conversations
      itemBuilder: (context, index) {
        return const ListTile(
          // TODO: Implémenter l'affichage des conversations
        );
      },
    );
  }

  Widget _buildSettingsTab() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: const Text('Mon profil'),
          onTap: () {
            // TODO: Navigation vers le profil
          },
        ),
        ListTile(
          leading: const Icon(Icons.notifications_outlined),
          title: const Text('Notifications'),
          onTap: () {
            // TODO: Paramètres des notifications
          },
        ),
        ListTile(
          leading: const Icon(Icons.help_outline),
          title: const Text('Aide'),
          onTap: () {
            // TODO: Page d'aide
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text('Déconnexion', 
            style: TextStyle(color: Colors.red),
          ),
          onTap: () {
            authProvider.logout();
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ],
    );
  }
}

extension on Map<String, dynamic>? {
  get role => null;
}