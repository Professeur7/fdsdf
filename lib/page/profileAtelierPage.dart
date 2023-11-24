import 'package:fashion2/firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screen/home_screen.dart';

class ProfileAtelierPage extends StatefulWidget {
  @override
  _ProfileAtelierPageState createState() => _ProfileAtelierPageState();
}

class _ProfileAtelierPageState extends State<ProfileAtelierPage> {
  String workshopName = 'Mon Atelier de Couture';
  String description = 'Atelier de couture de haute qualité';
  String profileImage = 'assets/default_profile_image.png';
  FirebaseManagement _management = Get.put(FirebaseManagement());

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
                builder: (context) => HomeScreen(),
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
                child: _management.tailleurs.length == 0
                    ? Container(
                        child: Image.asset(profileImage),
                      )
                    : CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            NetworkImage(_management.atelier.first.imageUrl),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Nom de l\'atelier : ${_management.atelier.length != 0 ? _management.atelier.first.nom : ""}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Description : ${_management.atelier.length != 0 ? _management.atelier.first.slogan : ""}',
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
