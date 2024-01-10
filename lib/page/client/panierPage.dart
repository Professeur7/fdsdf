import 'package:flutter/material.dart';
import '../../screen/clientHomeScreen.dart';

class PanierPage extends StatefulWidget {
  @override
  _PanierPageState createState() => _PanierPageState();
}

class _PanierPageState extends State<PanierPage> {
  List<CartItem> cartItems = [
    CartItem(name: 'Produit 1', price: 5000, quantity: 1),
    CartItem(name: 'Produit 2', price: 7500, quantity: 1),
    // Ajoutez d'autres éléments au panier
  ];

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
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
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
                      ),
                    ),
                    title: Text(cartItems[index].name),
                    subtitle: Text(
                      '${cartItems[index].price.toString()} F CFA',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            setState(() {
                              cartItems[index].quantity++;
                            });
                          },
                          icon: Icon(Icons.shop_rounded),
                        ),
                        Text(cartItems[index].quantity.toString()),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (cartItems[index].quantity > 1) {
                                cartItems[index].quantity--;
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
          ),
          ElevatedButton(
            onPressed: () {
              // Implémentez ici la logique pour acheter les produits
              buyProducts();
            },
            child: Text('Acheter'),
          ),
          SizedBox(height: 16),
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
