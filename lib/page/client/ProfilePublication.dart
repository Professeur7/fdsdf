import 'package:fashion2/firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ProfilePage extends StatelessWidget {
  String profileImage = 'assets/default_profile_image.png';
  FirebaseManagement _management = Get.put(FirebaseManagement());
  final String name;
  final String location;
  final double? rating;
  final String imageUrl;

  ProfilePage({
    required this.name,
    required this.location,
    required this.imageUrl,
    this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
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
                            backgroundImage: NetworkImage(
                                _management.atelier.first.imageUrl),
                          ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              '${_management.atelier.length != 0 ? _management.atelier.first.nom : ""}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              '${_management.atelier.length != 0 ? _management.atelier.first.lieu : ""}',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 20),
            // Section d'évaluation en étoiles
            if (rating != null)
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  SizedBox(width: 5),
                  Text(
                    '$rating / 5',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            SizedBox(height: 20),
            // Autres détails à afficher
            // ...
          ],
        ),
      ),
    );
  }
}
