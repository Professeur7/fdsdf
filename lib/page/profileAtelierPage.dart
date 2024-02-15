import 'package:fashion2/firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screen/home_screen.dart';

import 'package:fashion2/firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screen/home_screen.dart';

import 'package:fashion2/firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screen/home_screen.dart';

import 'package:fashion2/firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screen/home_screen.dart';

class ProfileAtelierPage extends StatefulWidget {
  @override
  _ProfileAtelierPageState createState() => _ProfileAtelierPageState();
}

class _ProfileAtelierPageState extends State<ProfileAtelierPage> {
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
      body: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: 5, // Le nombre total d'informations
        separatorBuilder: (context, index) => Divider(
          height: 2,
          color: Colors.grey,
        ),
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
              height: 150,
              width: double.infinity,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    // Gérer la mise à jour de la photo de profil ici
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        NetworkImage(_management.atelier.first.imageUrl!),
                  ),
                ),
              ),
            );
          }

          switch (index) {
            case 1:
              return buildInfoCard(
                title: 'Nom de l\'atelier',
                content: _management.atelier.length != 0
                    ? _management.atelier.first.nom
                    : '',
              );
            case 2:
              return buildInfoCard(
                title: 'Responsable',
                content: _management.tailleurs.length != 0
                    ? _management.tailleurs.first.username
                    : '',
              );
            case 3:
              return buildInfoCard(
                title: 'Lieu',
                content: _management.atelier.length != 0
                    ? _management.atelier.first.lieu
                    : '',
              );
            case 4:
              return buildInfoCard(
                title: 'Slogan',
                content: _management.atelier.length != 0
                    ? _management.atelier.first.slogan ?? ""
                    : '',
              );
            default:
              return SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget buildInfoCard({required String title, required String content}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              content,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
