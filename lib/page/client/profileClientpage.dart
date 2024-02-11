import 'package:fashion2/firestore.dart';
import 'package:fashion2/screen/clientHomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';

class ProfileClientPage extends StatefulWidget {
  @override
  _ProfileClientPageState createState() => _ProfileClientPageState();
}

class _ProfileClientPageState extends State<ProfileClientPage> {
  // Remplacez cette ligne par votre gestionnaire FirebaseManagement
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
            Navigator.pop(context);
          },
        ),
        title: Text('Votre Profil'),
      ),
      body: ListView(
        children: [
          _buildProfilePicture(),
          _buildClientDetails(),
          // Ajoutez d'autres informations sur l'atelier de couture ici
        ],
      ),
    );
  }

  Widget _buildProfilePicture() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            _management.clients.first
                .imageURL, // Remplacez par _management.clients.first.imageURL
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildClientDetails() {
    return Card(
      elevation: 5,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetail(
              'Nom', '${_management.clients.first.nom}', 20, FontWeight.bold),
          _buildDivider(),
          _buildDetail('Prenom', '${_management.clients.first.prenom}', 20,
              FontWeight.bold),
          _buildDivider(),
          _buildDetail('Telephone', '${_management.clients.first.telephone}',
              20, FontWeight.bold),
          _buildDivider(),
          _buildDetail('Email', '${_management.clients.first.email}', 20,
              FontWeight.bold),
          _buildDivider(),
          _buildDetail('Genre', '${_management.clients.first.genre}', 20,
              FontWeight.bold),
          _buildDivider(),
          _buildDetail('Nom d\'utilisateur',
              '${_management.clients.first.username}', 20, FontWeight.bold),
          _buildDivider(),
          _buildDetail('Age', '${_management.clients.first.trancheAge}', 20,
              FontWeight.bold),
        ],
      ),
    );
  }

  Widget _buildDetail(String label, String value, double fontSize,
      [FontWeight fontWeight = FontWeight.normal]) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize - 4,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: Colors.grey[300],
      indent: 16,
      endIndent: 16,
    );
  }
}
