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
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: AlignmentDirectional.centerEnd,
                    color: Colors.red,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      cartItems.removeAt(index);
                    });
                  },
                  child: ListTile(
                    leading: Container(
                      width: 80, // Large espace pour l'image
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        // Ajoutez ici votre logique pour afficher l'image du produit
                      ),
                    ),
                    title: Text(cartItems[index].name),
                    subtitle:
                        Text('${cartItems[index].price.toString()} F CFA'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            // Implémentez ici la logique pour acheter ce produit
                            buyProduct(index);
                          },
                          child: Text('Acheter'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void buyProduct(int index) {
    // Implémentez ici la logique d'achat du produit à l'index spécifié
    // Par exemple, vous pouvez ouvrir une page de confirmation d'achat pour ce produit
  }
}

class CartItem {
  final String name;
  final int price;
  int quantity;

  CartItem({required this.name, required this.price, required this.quantity});
}
