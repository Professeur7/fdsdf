import 'package:fashion2/firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../screen/clientHomeScreen.dart';

class PanierPage extends StatefulWidget {
  @override
  _PanierPageState createState() => _PanierPageState();
}

class _PanierPageState extends State<PanierPage> {
  final FirebaseManagement c = Get.put(FirebaseManagement());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Panier'),
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
      body: Column(
        children: <Widget>[
          FutureBuilder(
            future: c.getAllPannier(c.clients.first.token!),
            builder: (context, snap) {
              final data = snap.data;
              return Expanded(
                child: ListView.builder(
                  itemCount: data != null ? data.length : 0,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        leading: Container(
                          width: 80, // Large espace pour l'image
                          height: 80,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                              // Ajoutez ici votre logique pour afficher l'image du produit
                              image: DecorationImage(
                                  image: NetworkImage(
                                      data![index].produit.isNotEmpty
                                          ? data[index].produit.first.image
                                          : ""))),
                        ),
                        title: Text(data![index].produit.isNotEmpty
                            ? data[index].produit.first.nom
                            : "no product"),
                        subtitle: Text(
                          '${data[index].produit.first.prix.toString()} F CFA',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  data[index].prixTotal++;
                                });
                              },
                              icon: Icon(Icons.shop_rounded),
                            ),
                            Text(data[index].prixTotal.toString()),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  if (data[index].prixTotal > 1) {
                                    data[index].prixTotal--;
                                  }
                                });
                              },
                              icon: Icon(Icons.payment),
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
          // ElevatedButton(
          //   onPressed: () {
          //     // Implémentez ici la logique pour acheter les produits
          //     buyProducts();
          //   },
          //   child: Text('Acheter'),
          // ),
          // SizedBox(height: 16),
        ],
      ),
    );
  }

  void buyProducts() {
    // Implémentez ici la logique pour acheter tous les produits du panier
    // Par exemple, afficher une boîte de dialogue de confirmation d'achat
  }
}

class CartItem {
  final String name;
  final int price;
  int quantity;

  CartItem({required this.name, required this.price, required this.quantity});
}
