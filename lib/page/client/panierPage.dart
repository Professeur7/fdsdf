import 'package:flutter/material.dart';

class PanierPage extends StatefulWidget {
  @override
  _PanierPageState createState() => _PanierPageState();
}

class _PanierPageState extends State<PanierPage> {
  List<CartItem> cartItems = [
    CartItem(name: 'Produit 1', price: 10.00, quantity: 1),
    CartItem(name: 'Produit 2', price: 15.00, quantity: 1),
    // Ajoutez d'autres éléments au panier
  ];

  @override
  Widget build(BuildContext context) {
    double total = cartItems.fold(0, (previous, current) => previous + (current.price * current.quantity));

    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Panier'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(cartItems[index].name),
                  subtitle: Text('\$${cartItems[index].price.toStringAsFixed(2)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('Quantité: ${cartItems[index].quantity}'),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            cartItems.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Text('Total du Panier: \$${total.toStringAsFixed(2)}'),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Implémentez ici la logique de paiement ou de passage à la caisse.
            },
            child: Text('Passer à la caisse'),
          ),
        ],
      ),
    );
  }
}

class CartItem {
  final String name;
  final double price;
  int quantity;

  CartItem({required this.name, required this.price, required this.quantity});
}

void main() {
  runApp(MaterialApp(
    home: PanierPage(),
  ));
}
