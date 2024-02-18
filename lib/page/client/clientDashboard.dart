import 'package:fashion2/firestore.dart';
import 'package:fashion2/models/specialesPromotions.dart';
import 'package:fashion2/models/tailleurs.dart';
import 'package:fashion2/page/client/SpecialesPromotions.dart';
import 'package:fashion2/page/client/profileClientpage.dart';
import 'package:fashion2/page/searchClient.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';

import '../search.dart';
import 'clientDrawer.dart';

class Avis {
  final int etoiles;
  final String commentaire;
  final DateTime date;

  Avis({required this.etoiles, required this.commentaire, required this.date});
}

class HomePageClient extends StatefulWidget {
  @override
  State<HomePageClient> createState() => _HomePageClientState();
}

class _HomePageClientState extends State<HomePageClient> {
  FirebaseManagement _management = Get.put(FirebaseManagement());

  List<Tailleurs> tailleursRecommandes = [];

  @override
  void initState() {
    super.initState();
    tailleursRecommandes = _management.allsTailleur;
    specialPromotions = _management.special;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: Color(0xFF09126C),
        height: height,
        width: width,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: Color(0xFF09126C)),
              height: height * 0.19,
              width: width,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 35, left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ClientPageDrawer(),
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
                          _management.clients.length == 0
                              ? "Dashboard"
                              : _management.clients.first.username,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileClientPage(),
                              ),
                            );
                          },
                          child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              child: _management.clients.length == 0
                                  ? Container()
                                  : ClipOval(
                                      child: FittedBox(
                                        fit: BoxFit.cover,
                                        child: Image.network(
                                          _management.clients.first.imageURL,
                                        ),
                                      ),
                                    )),
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchPageClient(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Container(
                        height: 35,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.white, width: 1.4),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Icon(Icons.search, color: Colors.grey),
                                ),
                                Text(
                                  "Search...",
                                  style: TextStyle(color: Colors.grey),
                                )
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              height: 40,
                              width: 80,
                              child: Center(
                                child: Text(
                                  "Recherche",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              height: height * 0.81 - 60,
              width: width,
              padding: EdgeInsets.only(top: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CarouselSlider(
                      // ... (votre code pour le carrousel)
                      items: [
                        Image.asset('assets/images/homme.jpg'),
                        Image.asset('assets/images/femme.jpg'),
                        Image.asset('assets/images/enfant.jpg'),
                        Image.asset('assets/images/fille.jpg'),
                        Image.asset('assets/images/classe.jpg'),
                        Image.asset('assets/images/garcon.jpg'),
                        Image.asset('assets/images/jeune.jpg'),
                        Image.asset('assets/images/joli.jpg'),
                        Image.asset('assets/images/jolie.jpg'),
                        Image.asset('assets/images/man.jpg'),
                        Image.asset('assets/images/h.jpg'),
                        Image.asset('assets/images/g.jpg'),
                        Image.asset('assets/images/k.jpg'),
                      ],
                      options: CarouselOptions(
                        autoPlay: true,
                        aspectRatio: 16 / 9,
                        enlargeCenterPage: true,
                      ),
                    ),
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Tailleurs Recommandés',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
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
                                        backgroundImage:
                                            NetworkImage(tailleur.image!),
                                        radius: 30,
                                      ),
                                      SizedBox(height: 8),
                                      Text(tailleur.nom!),
                                      Row(
                                        children: [
                                          Icon(Icons.star,
                                              color: Colors.yellow),
                                          Text('10'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ), // Espace fixe avant la partie à faire défiler
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Promotions Spéciales',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.8,
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: specialPromotions.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 8.0,
                                  mainAxisSpacing: 8.0,
                                  childAspectRatio: 0.6,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  return buildSpecialPromotionCard(
                                      specialPromotions[index]);
                                },
                                // ... (ajoutez ici vos éléments de promotions spéciales)
                              ),
                            ),
                            // Autres éléments à défiler dans la colonne si nécessaire
                          ],
                        ),
                        // Vos autres widgets fixes après la partie à faire défiler
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<SpecialPromotion> specialPromotions = [
    // Ajoutez d'autres promotions spéciales selon vos besoins
  ];

  Widget buildSpecialPromotionCard(SpecialPromotion specialPromotion) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Image.network(
              specialPromotion.imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              specialPromotion.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              specialPromotion.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              specialPromotion.date,
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
