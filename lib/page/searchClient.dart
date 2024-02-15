import 'package:fashion2/firestore.dart';
import 'package:fashion2/models/tailleurs.dart';
import 'package:fashion2/page/tailleursInfosClient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SearchPageClient extends StatefulWidget {
  SearchPageClient({super.key});

  @override
  State<SearchPageClient> createState() => _SearchPageClientState();
}

class _SearchPageClientState extends State<SearchPageClient> {
  //FirebaseManagement _management = Get.put(FirebaseManagement());
  ScrollController _scrollController = ScrollController();
  String searchName = '';
  late Stream<List<Tailleurs>> tailleursRecommandes;

  @override
  void initState() {
    super.initState();
    tailleursRecommandes = Get.find<FirebaseManagement>().streamTailleurs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CupertinoSearchTextField(
          autofocus: true,
          onChanged: (value) {
            setState(() {
              searchName = value.toLowerCase();
            });
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: StreamBuilder<List<Tailleurs>>(
        stream: tailleursRecommandes,
        // Utilisez la méthode qui retourne le stream depuis Firebase
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          // Mettez à jour la liste avec les données du stream
          final t = snapshot.data ?? [];

          return Container(
            color: Colors.white,
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              itemCount: t.length,
              itemBuilder: (context, index) {
                final tailleur = t[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TailleurDetailsPage(tailleur: t[index]),
                      ),
                    );
                    // Ajoutez ici la logique pour afficher les détails du tailleur
                  },
                  child: Container(
                    margin: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(tailleur.image!),
                          radius: 30,
                        ),
                        SizedBox(height: 8),
                        Text(tailleur.nom!),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.yellow),
                            Text(tailleur.toString()),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
