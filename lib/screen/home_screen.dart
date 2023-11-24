

import 'package:fashion2/page/client.dart';
import 'package:fashion2/page/commande.dart';
import 'package:fashion2/page/dashboard.dart';
import 'package:fashion2/page/pageMesure.dart';
import 'package:flutter/material.dart';

import '../page/todoListPage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentTab = 0;
  final List<Widget> screens = [
    Dashboard(),
    CustomerInformationPage(),
    Transaction(),
    ToDoListPage(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = Dashboard();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: currentScreen, // Ajout de la virgule ici
        bucket: bucket,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF09126C),
        child: Icon(Icons.cut),
        onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MesuresPage(), // Remplacez PageDefault par votre widget de page par défaut
              ),
            );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 10,
          child: Container(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Expanded(
                  child: MaterialButton(
                    minWidth: 30,
                    onPressed: () {
                      setState(() {
                        currentScreen = Dashboard();
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.dashboard,
                          color: currentTab == 0 ? const Color(0xFF3b5999) : Colors.grey,
                        ),
                        Text(
                          'Accueil',
                          style: TextStyle(
                            color: currentTab == 0 ? const Color(0xFF3b5999) : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: MaterialButton(
                    minWidth: 30,
                    onPressed: () {
                      setState(() {
                        currentScreen = CustomerInformationPage();
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          color: currentTab == 1 ? const Color(0xFF3b5999) : Colors.grey,
                        ),
                        Text(
                          'Mesure',
                          style: TextStyle(
                            color: currentTab == 1 ? const Color(0xFF3b5999) : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: MaterialButton(
                    minWidth: 30,
                    onPressed: () {
                      setState(() {
                        currentScreen = Transaction();
                        currentTab = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart,
                          color: currentTab == 2 ? const Color(0xFF3b5999) : Colors.grey,
                        ),
                        Text(
                          'Commande',
                          style: TextStyle(
                            color: currentTab == 2 ? const Color(0xFF3b5999) : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: MaterialButton(
                    minWidth: 25,
                    onPressed: () {
                      setState(() {
                        currentScreen = ToDoListPage();
                        currentTab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.task_rounded,
                          color: currentTab == 3 ? const Color(0xFF3b5999) : Colors.grey,
                        ),
                        Text(
                          'Taches',
                          style: TextStyle(
                            color: currentTab == 3 ? const Color(0xFF3b5999) : Colors.grey,
                          ),
                        ),
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







// import 'package:flutter/material.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);
//
//   @override
//   State<HomeScreen> createState() => _HomeState();
// }
//
// class _HomeState extends State<HomeScreen> {
//   int _selectedItemIndex = 2;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF3b5999),
//         title: const Text(
//           "FASHION MODE",
//           style: TextStyle(
//             fontSize: 18.0,
//             fontWeight: FontWeight.w600,
//             color: Colors.white,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications),
//             onPressed: () {
//               // Gérer l'action de l'icône de la notification ici
//               // Par exemple, afficher les notifications
//               // ouvrir une nouvelle page pour les notifications, etc.
//             },
//           ),
//         ],
//       ),
//       drawer: const Drawer(), // Vous pouvez personnaliser le Drawer ici
//
//       bottomNavigationBar: Row(
//         children: [
//           buildNavBarItem(Icons.task_alt, 0, () {
//             // Code à exécuter lorsque l'élément 0 est sélectionné
//           }),
//           buildNavBarItem(Icons.cut_sharp, 1, () {
//             // Code à exécuter lorsque l'élément 1 est sélectionné
//           }),
//           buildNavBarItem(Icons.home_filled, 2, () {
//             // Code à exécuter lorsque l'élément 1 est sélectionné
//           }),
//           buildNavBarItem(Icons.message, 3, () {
//             // Code à exécuter lorsque l'élément 1 est sélectionné
//           }),
//           buildNavBarItem(Icons.person, 4, () {
//             // Code à exécuter lorsque l'élément 1 est sélectionné
//           }),
//         ],
//       ),
//
//       // bottomNavigationBar: Row(
//       //   children: [
//       //     buildNavBarItem(Icons.task_alt, 0),
//       //     buildNavBarItem(Icons.cut_sharp, 1),
//       //     buildNavBarItem(Icons.home_filled, 2),
//       //     buildNavBarItem(Icons.message, 3),
//       //     buildNavBarItem(Icons.person, 4),
//       //   ],
//       // ),
//       body: Container(
//         color: const Color(0xFF3b5999),
//         child: Column(
//           children: [
//             Positioned(
//               top: 170,
//               child: Column(
//                 children: [
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     padding: const EdgeInsets.only(
//                       left: 20.0,
//                       right: 20.0,
//                       top: 20.0,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[100],
//                       borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(40),
//                         topRight: Radius.circular(40),
//                       ),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           "Models Recents",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.grey,
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 15,
//                         ),
//                         SizedBox(
//                           height: MediaQuery.of(context).size.height * 0.11,
//                           child: ListView(
//                             scrollDirection: Axis.horizontal,
//                             children: [
//                               buildRecentModel("Robe", "assets/images/background.jpg"),
//                               buildRecentModel("Robe", "assets/images/background.jpg"),
//                               buildRecentModel("Chemise", "assets/images/background.jpg"),
//                               buildRecentModel("Yorobani", "assets/images/background.jpg"),
//                               buildRecentModel("Pagne", "assets/images/background.jpg"),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SingleChildScrollView(
//               child: Container(
//                 height: MediaQuery.of(context).size.height * 0.605,
//                 color: Colors.grey.shade100,
//                 child: ListView(
//                   scrollDirection: Axis.vertical,
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   children: [
//                     const Text(
//                       "Galerie (LYFA)",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black54,
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 5,
//                     ),
//                     DashboardRow(),
//                     const SizedBox(
//                       height: 5,
//                     ),
//                     DashboardRow(),
//                     const SizedBox(
//                       height: 15,
//                     ),
//                     const Text(
//                       "Autres activités",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black54,
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     DashboardRow(),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     DashboardRow(),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     DashboardRow(),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   GestureDetector buildNavBarItem(IconData icon, int index, Function() onItemSelected) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _selectedItemIndex = index;
//         });
//       },
//       child: Container(
//         width: MediaQuery.of(context).size.width / 5,
//         height: 60,
//         decoration: index == _selectedItemIndex
//             ? BoxDecoration(
//             border: const Border(
//                 bottom: BorderSide(width: 4, color: Colors.blue)),
//             gradient: LinearGradient(colors: [
//               Colors.blue.withOpacity(0.3),
//               Colors.blue.withOpacity(0.016),
//             ], begin: Alignment.bottomCenter, end: Alignment.topCenter))
//             : const BoxDecoration(),
//         child: Icon(
//           icon,
//           color: index == _selectedItemIndex
//               ? const Color(0xFF3b5999)
//               : Colors.grey,
//         ),
//       ),
//     );
//   }
//
//   Container buildRecentModel(String name, String image) {
//     return Container(
//       margin: const EdgeInsets.only(right: 30),
//       child: Column(
//         children: [
//           Container(
//             width: 60,
//             height: 60,
//             decoration: BoxDecoration(
//               border: Border.all(width: 2, color: Colors.green),
//               borderRadius: BorderRadius.circular(30),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(3.0),
//               child: CircleAvatar(
//                 backgroundImage: AssetImage(image),
//               ),
//             ),
//           ),
//           const SizedBox(
//             height: 5,
//           ),
//           Text(
//             name,
//             style: const TextStyle(
//               fontSize: 10,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
//
// class DashboardRow extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         BuildDashboardItem(
//           "Homme",
//           Colors.blue.withOpacity(0.4),
//           const Color(0xFF3b5999), onItemSelected: () {  },
//         ),
//         BuildDashboardItem(
//           "Femme",
//           Colors.blue.withOpacity(0.4),
//           const Color(0xFF3b5999), onItemSelected: () {  },
//         ),
//         BuildDashboardItem(
//           "Enfant",
//           Colors.blue.withOpacity(0.4),
//           const Color(0xFF3b5999), onItemSelected: () {  },
//         ),
//       ],
//     );
//   }
// }
//
// class BuildDashboardItem extends StatelessWidget {
//   final String title;
//   final Color backgroundColor;
//   final Color iconColor;
//   final Function() onItemSelected;
//
//   const BuildDashboardItem(this.title, this.backgroundColor, this.iconColor, {required this.onItemSelected});
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//         onTap: () {
//           if (onItemSelected != null) {
//             onItemSelected();
//           }
//         },
//       child: Container(
//         margin: const EdgeInsets.all(10.0),
//         height: 85,
//         width: 85,
//         decoration: BoxDecoration(
//           color: Colors.blue.withOpacity(0.2),
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               title,
//               style: const TextStyle(
//                 color: Colors.black54,
//                 fontWeight: FontWeight.bold,
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// //
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';
// //
// // class HomeScreen extends StatelessWidget {
// //   HomeScreen({Key? key}) : super(key: key);
// //
// //   final List<String> symptoms = [
// //     "Boubou",
// //     "Robe",
// //     "Chemise",
// //     "Jupe",
// //     "Tissu",
// //   ];
// //
// //   final List<String> imgs = [
// //     "doctor1.jpg",
// //     "doctor2.jpg",
// //     "doctor3.jpg",
// //     "doctor4.jpg",
// //   ];
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: Scaffold(
// //         body: SingleChildScrollView(
// //           padding: EdgeInsets.only(top: 40),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Padding(
// //                 padding: EdgeInsets.symmetric(horizontal: 15),
// //                 child: Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     InkWell(
// //                       onTap: () {
// //                         // Ajoutez ici la logique de recherche
// //                       },
// //                       child: Icon(
// //                         Icons.search,
// //                         size: 40,
// //                         color: Colors
// //                             .black54, // Choisissez la couleur qui vous convient
// //                       ),
// //                     ),
// //                     Text(
// //                       "Bonjour cher Client",
// //                       style:
// //                           TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
// //                     ),
// //                     CircleAvatar(
// //                       radius: 25,
// //                       backgroundImage: AssetImage("assets/images/doctor1.jpg"),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               SizedBox(height: 30),
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                 children: [
// //                   Expanded(
// //                     child: InkWell(
// //                       onTap: () {},
// //                       child: Container(
// //                         padding: EdgeInsets.all(15),
// //                         decoration: BoxDecoration(
// //                           color: Color(0xFF3b5999),
// //                           borderRadius: BorderRadius.circular(10),
// //                           boxShadow: [
// //                             BoxShadow(
// //                               color: Colors.black12,
// //                               blurRadius: 6,
// //                               spreadRadius: 4,
// //                             ),
// //                           ],
// //                         ),
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Container(
// //                               padding: EdgeInsets.all(8),
// //                               decoration: BoxDecoration(
// //                                 color: Colors.white,
// //                                 shape: BoxShape.circle,
// //                               ),
// //                               child: Icon(
// //                                 Icons.add,
// //                                 color: Color(0xFF3b5999),
// //                                 size: 35,
// //                               ),
// //                             ),
// //                             SizedBox(height: 30),
// //                             Text(
// //                               "Visite atelier",
// //                               style: TextStyle(
// //                                 fontSize: 18,
// //                                 color: Colors.white,
// //                                 fontWeight: FontWeight.w500,
// //                               ),
// //                             ),
// //                             SizedBox(height: 5),
// //                             Text(
// //                               "Prendre un rendez-vous",
// //                               style: TextStyle(color: Colors.white54),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                   SizedBox(width: 5), // Espace entre les deux InkWell
// //                   Expanded(
// //                     child: InkWell(
// //                       onTap: () {},
// //                       child: Container(
// //                         padding: EdgeInsets.all(15),
// //                         decoration: BoxDecoration(
// //                           color: Colors.white,
// //                           borderRadius: BorderRadius.circular(10),
// //                           boxShadow: [
// //                             BoxShadow(
// //                               color: Colors.black12,
// //                               blurRadius: 6,
// //                               spreadRadius: 4,
// //                             ),
// //                           ],
// //                         ),
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Container(
// //                               padding: EdgeInsets.all(8),
// //                               decoration: BoxDecoration(
// //                                 color: Color(0xFFF0EEFA),
// //                                 shape: BoxShape.circle,
// //                               ),
// //                               child: Icon(
// //                                 Icons.home_filled,
// //                                 color: Color(0xFF3b5999),
// //                                 size: 35,
// //                               ),
// //                             ),
// //                             SizedBox(height: 30),
// //                             Text(
// //                               "Visite Home",
// //                               style: TextStyle(
// //                                 fontSize: 18,
// //                                 fontWeight: FontWeight.w500,
// //                               ),
// //                             ),
// //                             SizedBox(height: 5),
// //                             Text(
// //                               "Appelez le tailleur",
// //                               style: TextStyle(color: Colors.black54),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //               SizedBox(height: 25),
// //               Padding(
// //                 padding: EdgeInsets.only(left: 15),
// //                 child: Text(
// //                   "Vos modèles préférés?",
// //                   style: TextStyle(
// //                     fontSize: 23,
// //                     fontWeight: FontWeight.w500,
// //                     color: Colors.black54,
// //                   ),
// //                 ),
// //               ),
// //               SizedBox(
// //                 height: 70,
// //                 child: ListView.builder(
// //                   shrinkWrap: true,
// //                   scrollDirection: Axis.horizontal,
// //                   itemCount: symptoms.length,
// //                   itemBuilder: (context, index) {
// //                     return Container(
// //                       margin:
// //                           EdgeInsets.symmetric(vertical: 10, horizontal: 15),
// //                       padding: EdgeInsets.symmetric(horizontal: 25),
// //                       decoration: BoxDecoration(
// //                         color: Color.fromARGB(255, 107, 129, 176),
// //                         borderRadius: BorderRadius.circular(10),
// //                         boxShadow: [
// //                           BoxShadow(
// //                             color: Colors.black12,
// //                             blurRadius: 4,
// //                             spreadRadius: 2,
// //                           ),
// //                         ],
// //                       ),
// //                       child: Center(
// //                         child: Text(
// //                           symptoms[index],
// //                           style: TextStyle(
// //                             fontSize: 16,
// //                             fontWeight: FontWeight.w500,
// //                             color: Colors.black54,
// //                           ),
// //                         ),
// //                       ),
// //                     );
// //                   },
// //                 ),
// //               ),
// //               SizedBox(height: 15),
// //               Padding(
// //                 padding: EdgeInsets.only(left: 15),
// //                 child: Text(
// //                   "Les Tailleurs Populaires",
// //                   style: TextStyle(
// //                     fontSize: 23,
// //                     fontWeight: FontWeight.w500,
// //                     color: Colors.black54,
// //                   ),
// //                 ),
// //               ),
// //               GridView.builder(
// //                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// //                     crossAxisCount: 2,
// //                   ),
// //                   itemCount: 4,
// //                   shrinkWrap: true,
// //                   physics: NeverScrollableScrollPhysics(),
// //                   itemBuilder: (context, Index) {
// //                     return InkWell(
// //                       onTap: () {},
// //                       child: Container(
// //                         margin: EdgeInsets.all(10),
// //                         padding: EdgeInsets.symmetric(vertical: 15),
// //                         decoration: BoxDecoration(
// //                             color: Colors.white,
// //                             borderRadius: BorderRadius.circular(10),
// //                             boxShadow: [
// //                               BoxShadow(
// //                                   color: Colors.black12,
// //                                   blurRadius: 4,
// //                                   spreadRadius: 2)
// //                             ]),
// //                         child: Column(
// //                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                           children: [
// //                             CircleAvatar(
// //                               radius: 35,
// //                               backgroundImage:
// //                                   AssetImage("assets/images/${imgs[Index]}"),
// //                             ),
// //                             Text(
// //                               "Mr. Nom du tailleur",
// //                               style: TextStyle(
// //                                   fontSize: 10,
// //                                   fontWeight: FontWeight.w500,
// //                                   color: Colors.black54),
// //                             ),
// //                             Text(
// //                               "Specialiste",
// //                               style: TextStyle(color: Colors.black45),
// //                             ),
// //                             Row(
// //                               mainAxisSize: MainAxisSize.min,
// //                               mainAxisAlignment: MainAxisAlignment.center,
// //                               children: [
// //                                 Icon(
// //                                   Icons.star,
// //                                   color: Colors.amber,
// //                                 ),
// //                                 Text(
// //                                   "4.9",
// //                                   style: TextStyle(color: Colors.black45),
// //                                 )
// //                               ],
// //                             )
// //                           ],
// //                         ),
// //                       ),
// //                     );
// //                   })
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
