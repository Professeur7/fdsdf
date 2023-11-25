import 'package:fashion2/page/client/profileClientpage.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../search.dart';
import 'clientDrawer.dart';

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
    Tailleur(nom: 'Tailleur 2', image: 'assets/images/doctor2.jpg', noteMoyenne: 3.0),
    Tailleur(nom: 'Tailleur 3', image: 'assets/images/doctor1.jpg', noteMoyenne: 2.5),
    Tailleur(nom: 'Tailleur 4', image: 'assets/images/doctor2.jpg', noteMoyenne: 4.0),
    Tailleur(nom: 'Tailleur 1', image: 'assets/images/doctor1.jpg', noteMoyenne: 4.5),
    Tailleur(nom: 'Tailleur 2', image: 'assets/images/doctor2.jpg', noteMoyenne: 3.0),
    Tailleur(nom: 'Tailleur 3', image: 'assets/images/doctor1.jpg', noteMoyenne: 2.5),
    Tailleur(nom: 'Tailleur 4', image: 'assets/images/doctor2.jpg', noteMoyenne: 4.0),
      // Ajoutez d'autres tailleurs recommandés
  ];


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var widget;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            color: Color(0xFF09126C),
            height: height,
            width: width,
            child: Column(
                children: [
            Container(
            decoration: BoxDecoration(
            color: Color(0xFF09126C)
        ),
        height: height * 0.19,
        width: width,
        child: Column(
            children: [
        Padding(
        padding: const EdgeInsets.only(
            top: 35,
            left: 20,
            right: 20
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: (){
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClientPageDrawer(), // Remplacez PageDefault par votre widget de page par défaut
                  ),
                );
              },
              child: Icon(
                Icons.sort,
                color: Colors.white,
                size: 40,
              ),
            ),
            Text(
              "Dashboard",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
              ),
            ),
            InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileClientPage()));
                  // Naviguer vers la nouvelle page de profil ici
                  // Vous devez définir votre propre logique de navigation
                  // Par exemple, vous pouvez utiliser Navigator pour naviguer vers la nouvelle page.
                },
                child:
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    // image: widget.selectedImage != null
                    //     ? DecorationImage(
                    //   image: FileImage(widget.selectedImage),
                    //   fit: BoxFit.cover,
                    // )
                    //     : null,
                  ),
                )
            )
          ],
        ),
      ),
      InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage()));
        },
        child: Padding(
          padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20
          ),
          child: Container(
            height: 35,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: Colors.white,
                    width: 1.4
                ),
                borderRadius: BorderRadius.circular(25)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(Icons.search, color: Colors.grey),
                    ),
                    Text(
                      "Search...",
                      style: TextStyle(
                          color: Colors.grey
                      ),
                    )
                  ],
                ),

                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(25)
                  ),
                  height: 40,
                  width: 80,
                  child: Center(
                    child: Text(
                      "Recherche",
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
            ],
        ),
      ),
      SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          height: height * 0.81,
          width: width,
          padding: EdgeInsets.only(
              bottom: 10
          ),
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
              Container(
                color: Colors.white,
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: tailleursRecommandes.length,
                  itemBuilder: (context, index) {
                    final tailleur = tailleursRecommandes[index];
                    return GestureDetector(
                      onTap: () {
                        // Ajoutez ici la logique pour afficher les détails du tailleur
                      },
                      child: Container(
                        margin: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage(tailleur.image),
                              radius: 30,
                            ),
                            SizedBox(height: 8),
                            Text(tailleur.nom),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.yellow),
                                Text('${tailleur.noteMoyenne}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Promotions Spéciales',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              // ... (ajoutez ici des éléments de promotions spéciales)
            ],
          ),
        ),
      ),
                ],
            ),
        ),
      ),
    );
  }
}

