import 'package:flutter/material.dart';
import 'package:fashion2/page/client.dart';
import 'package:fashion2/page/dashboard.dart';
import 'package:fashion2/page/pageMesure.dart';
import 'package:fashion2/page/todoListPage.dart';

import '../page/client/clientDashboard.dart';
import '../page/client/pagePublication.dart';
import '../page/client/panierPage.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({Key? key});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  int currentTab = 0;
  final List<Widget> screens = [
    HomePageClient(),
    Publications(), // Remplacez par votre widget de publications
    ClientsScreen(),
    ToDoListPage(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = HomePageClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3b5999),
        child: Icon(Icons.add_shopping_cart), // Utilisez un icône de panier
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PanierPage(), // Remplacez par votre page de panier
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
                      currentScreen = HomePageClient();
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
                      currentScreen = Publications();
                      currentTab = 1;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.public,
                        color: currentTab == 1 ? const Color(0xFF3b5999) : Colors.grey,
                      ),
                      Text(
                        'Publication',
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
                      currentScreen = ClientsScreen();
                      currentTab = 2;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite,
                        color: currentTab == 2 ? const Color(0xFF3b5999) : Colors.grey,
                      ),
                      Text(
                        'Favoris',
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
                        Icons.account_box_rounded,
                        color: currentTab == 3 ? const Color(0xFF3b5999) : Colors.grey,
                      ),
                      Text(
                        'Profil',
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
