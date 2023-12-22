import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion2/page/gridview/pageClient.dart';
import 'package:fashion2/page/gridview/pageModels.dart';
import 'package:fashion2/page/gridview/pagePaiement.dart';
import 'package:fashion2/page/gridview/pagePromotion.dart';
import 'package:fashion2/page/gridview/pageRDV.dart';
import 'package:fashion2/page/gridview/pageStock.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  ScrollController _scrollController = ScrollController();
  String searchName = '';
  List imgData = [
    "assets/images/models.png",
    "assets/images/stock.png",
    "assets/images/paiement.png",
    "assets/images/apointment.png",
    "assets/images/media.png",
    "assets/images/clients.png",
  ];

  List titles = [
    "Models",
    "Stock",
    "Paiement",
    "Rendez-vous",
    "Publication",
    "Client"
  ];

  List<Widget> pages = [
    PageModels(), // Remplacez PageOne, PageTwo, etc. par vos propres widgets de page
    StockManagementPage(),
    InvoiceAndAccountingPage(),
    AppointmentAndSchedulingPage(),
    NewPostPage(),
    ClientsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        int foundIndex = titles
            .indexWhere((title) => title.toLowerCase().contains(searchName));
        if (foundIndex != -1) {
          double itemHeight = 120.0; // Hauteur estimée de chaque élément
          double scrollOffset = foundIndex * itemHeight;
          _scrollController.jumpTo(scrollOffset);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController
        .dispose(); // N'oubliez pas de libérer le contrôleur lorsque le widget est supprimé
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: CupertinoSearchTextField(
            autofocus: true,
            onChanged: (value) {
              setState(() {
                searchName =
                    value.toLowerCase(); // Mettre la recherche en minuscules
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
        // Après la barre de recherche
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Container(
              //   color: Colors.white,
              //   padding: EdgeInsets.all(20),
              //   child: TextField(
              //     onChanged: (value) {
              //       setState(() {
              //         searchName =
              //             value.toLowerCase(); // Mettre la recherche en minuscules
              //       });
              //     },
              //     decoration: InputDecoration(
              //       hintText: 'Rechercher...',
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //       prefixIcon: Icon(Icons.search),
              //     ),
              //   ),
              // ),
              if (searchName.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(10),
                  child: GridView.builder(
                    controller: _scrollController,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.1,
                      mainAxisSpacing: 15,
                    ),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: imgData.length,
                    itemBuilder: (context, index) {
                      // Filtrer les éléments selon la recherche
                      if (searchName.isEmpty ||
                          titles[index].toLowerCase().contains(searchName)) {
                        return InkWell(
                          onTap: () {
                            if (index >= 0 && index < pages.length) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => pages[index]),
                              );
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  spreadRadius: 1,
                                  blurRadius: 6,
                                )
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(
                                  imgData[index],
                                  width: 100,
                                ),
                                Text(
                                  titles[index],
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        // Retourner un conteneur vide si l'élément ne correspond pas à la recherche
                        return SizedBox.shrink();
                      }
                    },
                  ),
                ),
            ],
          ),
        ));
  }
}
