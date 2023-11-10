import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';



class Tailleur {
  final String nom;
  final String image;
  final double noteMoyenne;

  Tailleur({required this.nom, required this.image, required this.noteMoyenne});
}

class Avis {
  final int etoiles;
  final String commentaire;
  final DateTime date;

  Avis({required this.etoiles, required this.commentaire, required this.date});
}


class HomePageClient extends StatelessWidget {
  final List<Tailleur> tailleursRecommandes = [
    Tailleur(nom: 'Tailleur 1', image: 'assets/images/doctor1.jpg', noteMoyenne: 4.5),
    Tailleur(nom: 'Tailleur 2', image: 'assets/images/doctor2.jpg', noteMoyenne: 4.0),
    // Ajoutez d'autres tailleurs recommandés
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page d\'accueil'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: [
                Image.asset('assets/images/woman.png'),
                Image.asset('assets/images/woman.png'),
                Image.asset('assets/images/woman.png'),
              ],
              options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 16 / 9,
                enlargeCenterPage: true,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Tailleurs Recommandés',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: tailleursRecommandes.length,
              itemBuilder: (context, index) {
                final tailleur = tailleursRecommandes[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(tailleur.image),
                  ),
                  title: Row(
                    children: [
                      Text(tailleur.nom),
                      SizedBox(width: 8),
                      Icon(Icons.star, color: Colors.yellow),
                    ],
                  ),
                  subtitle: Text('Note moyenne : ${tailleur.noteMoyenne}'),
                  // Autres informations sur le tailleur
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
