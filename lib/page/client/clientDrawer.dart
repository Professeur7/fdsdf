import 'package:fashion2/screen/clientHomeScreen.dart';
import 'package:flutter/material.dart';


class ClientPageDrawer extends StatefulWidget {
  @override
  _ClientPageDrawerState createState() => _ClientPageDrawerState();
}

class _ClientPageDrawerState extends State<ClientPageDrawer> {
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
                builder: (context) => ClientHomeScreen(), // Remplacez PageDefault par votre widget de page par défaut
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
