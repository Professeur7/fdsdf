import 'package:flutter/material.dart';

import '../../screen/clientHomeScreen.dart';

class ProfileClientPage extends StatefulWidget {
  @override
  _ProfileClientPageState createState() => _ProfileClientPageState();
}

class _ProfileClientPageState extends State<ProfileClientPage> {
  String workshopName = 'Mon Atelier de Couture';
  String description = 'Atelier de couture de haute qualité';
  String profileImage = 'assets/default_profile_image.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF09126C),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ClientHomeScreen(),
              ),
            );
          },
        ),
        title: Text('Profil'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: GestureDetector(
                onTap: () {
                  // Gérer la mise à jour de la photo de profil ici
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(profileImage),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Nom de l\'atelier : $workshopName',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Description : $description',
                style: TextStyle(fontSize: 16),
              ),
            ),
            // Ajoutez d'autres informations sur l'atelier de couture ici
          ],
        ),
      ),
    );
  }
}