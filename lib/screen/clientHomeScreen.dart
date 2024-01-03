import 'package:fashion2/page/client/clienViewPubPage.dart';
import 'package:flutter/material.dart';
import '../page/client/ClientCommande.dart';
import '../page/client/clientDashboard.dart';
import '../page/client/panierPage.dart';
import '../page/client/profileClient.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({Key? key});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  int currentTab = 0;
  final List<Widget> screens = [
    HomePageClient(),
    PublicationsClient(), // Remplacez par votre widget de publications
    ClientOrderPage(),
    ProfilePage(),
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
        backgroundColor: Color(0xFF09126C),
        child: Icon(Icons.add_shopping_cart), // Utilisez un icône de panier
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  PanierPage(), // Remplacez par votre page de panier
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //scrollDirection: Axis.horizontal,
            children: [
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
                        color: currentTab == 0
                            ? const Color(0xFF3b5999)
                            : Colors.grey,
                      ),
                      Text(
                        'Accueil',
                        style: TextStyle(
                          color: currentTab == 0
                              ? const Color(0xFF3b5999)
                              : Colors.grey,
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
                      currentScreen = PublicationsClient();
                      currentTab = 1;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.public,
                        color: currentTab == 1
                            ? const Color(0xFF3b5999)
                            : Colors.grey,
                      ),
                      Text(
                        'Poste',
                        style: TextStyle(
                          color: currentTab == 1
                              ? const Color(0xFF3b5999)
                              : Colors.grey,
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
                      currentScreen = ClientOrderPage();
                      currentTab = 2;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart,
                        color: currentTab == 2
                            ? const Color(0xFF3b5999)
                            : Colors.grey,
                      ),
                      Text(
                        'Achats',
                        style: TextStyle(
                          color: currentTab == 2
                              ? const Color(0xFF3b5999)
                              : Colors.grey,
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
                      currentScreen = ProfilePage();
                      currentTab = 3;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_box_rounded,
                        color: currentTab == 3
                            ? const Color(0xFF3b5999)
                            : Colors.grey,
                      ),
                      Text(
                        'Profil',
                        style: TextStyle(
                          color: currentTab == 3
                              ? const Color(0xFF3b5999)
                              : Colors.grey,
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
