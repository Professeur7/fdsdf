import 'dart:io';
import 'package:fashion2/firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

import '../../screen/clientHomeScreen.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseManagement _management = Get.put(FirebaseManagement());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil du Client'),
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
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildUserInfo(),
            SizedBox(height: 20),
            _buildSectionTitle('Commandes en cours'),
            _buildCurrentOrders(),
            SizedBox(height: 20),
            _buildSectionTitle('Historique des Commandes'),
            _buildOrderHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  _management.clients.first.imageURL) // Image par défaut
              ),
        ),
        SizedBox(height: 10),
        Center(
          child: Text(
            'Nom: ${_management.clients.first.nom}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 5),
        Center(
          child: Text(
            'Email: ${_management.clients.first.email}',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentOrders() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text('Commande 1'),
            subtitle: Text('Détails de la commande'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Actions à effectuer lorsqu'une commande est sélectionnée
            },
          ),
          // Ajoutez d'autres tuiles de commande si nécessaire
        ],
      ),
    );
  }

  Widget _buildOrderHistory() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text('Commande précédente'),
            subtitle: Text('Détails de l\'historique de la commande'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Actions à effectuer lorsqu'une commande passée est sélectionnée
            },
          ),
          // Ajoutez d'autres tuiles d'historique de commande si nécessaire
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
