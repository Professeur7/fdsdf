import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../screen/clientHomeScreen.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;

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
          onTap: _pickProfileImage,
          child: CircleAvatar(
            radius: 50,
            // backgroundImage: _profileImage != null
            //     ? FileImage(_profileImage!)
            //     : AssetImage('assets/images/woman.png'), // Image par défaut
          ),
        ),
        SizedBox(height: 10),
        Center(
          child: Text(
            'Nom du Client',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 5),
        Center(
          child: Text(
            'Adresse Email du Client',
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

  Future<void> _pickProfileImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: ProfilePage(),
  ));
}
