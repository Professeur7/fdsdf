import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
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
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage("https://w7.pngwing.com/pngs/650/656/png-transparent-model-fashion-model-celebrities-woman-fashion-model-thumbnail.png"),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              location,
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
