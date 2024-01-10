import 'package:fashion2/screen/loginSignupScreen.dart';
import 'package:flutter/material.dart';

import '../screen/home_screen.dart';

class PageDrawer extends StatefulWidget {
  @override
  _PageDrawerState createState() => _PageDrawerState();
}

class _PageDrawerState extends State<PageDrawer> {
  bool notificationsEnabled = true; // Exemple de paramètre

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF09126C),
        title: Text('Paramètres'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    HomeScreen(), // Remplacez PageDefault par votre widget de page par défaut
              ),
            );
          },
        ),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Notifications'),
            subtitle: Text('Activer/désactiver les notifications'),
            trailing: Switch(
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Langue'),
            subtitle: Text('Choisir la langue de l\'application'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Naviguer vers une page de sélection de langue
            },
          ),

          ListTile(
            title: Text(
              'Déconnexion',
              style: TextStyle(
                color: Color(0xFF09126C), // Utiliser la couleur spécifiée
              ),
            ),
            trailing: Icon(
              Icons.exit_to_app,
              color: Color(0xFF09126C), // Utiliser la même couleur pour l'icône
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginSignupScreen()
                    // Remplacez PageDefault par votre widget de page par défaut
                    ),
              );

              // Logique de déconnexion
            },
          ),
          ListTile(
            title: Text('À propos de'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Naviguer vers la page "À propos de"
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutPage(),
                ),
              );
            },
          ),
          // Ajoutez d'autres paramètres ici
        ],
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('À propos de'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.info,
              size: 64,
            ),
            Text(
              'Votre application de gestion d\'atelier de couture',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Version 1.0.0',
              style: TextStyle(fontSize: 16),
            ),
            // Ajoutez d'autres informations sur l'application ici
          ],
        ),
      ),
    );
  }
}
