import 'package:fashion2/firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../screen/clientHomeScreen.dart';

class ProfileClientPage extends StatefulWidget {
  @override
  _ProfileClientPageState createState() => _ProfileClientPageState();
}

class _ProfileClientPageState extends State<ProfileClientPage> {
  FirebaseManagement _management = Get.put(FirebaseManagement());
  String workshopName = 'Mon Atelier de Couture';
  String description = 'Atelier de couture de haute qualité';

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
          children: [
            Center(
              child: GestureDetector(
                onTap: () {
                  // Gérer la mise à jour de la photo de profil ici
                },
                child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      _management.clients.first.imageURL,
                    )),
                //child: Image.network(_management.clients.first.imageURL),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Nom du client : ${_management.clients.first.nom}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Votre Prenom : ${_management.clients.first.prenom}',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Telephone : ${_management.clients.first.telephone}',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Votre email : ${_management.clients.first.email}',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Genre : ${_management.clients.first.genre}',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Nom d\'utilisateur : ${_management.clients.first.username}',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Votre age : ${_management.clients.first.telephone}',
                style: TextStyle(fontSize: 10),
              ),
            ),
            // Ajoutez d'autres informations sur l'atelier de couture ici
          ],
        ),
      ),
    );
  }
}
