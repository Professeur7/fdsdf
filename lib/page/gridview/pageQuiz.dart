import 'package:flutter/material.dart';

import '../../screen/home_screen.dart';



class StockManagementPage extends StatefulWidget {
  @override
  _StockManagementPageState createState() => _StockManagementPageState();
}

class _StockManagementPageState extends State<StockManagementPage> {
  List<StockItem> stockItems = [
    StockItem("Tissus", 100),
    StockItem("Fils", 50),
    StockItem("Boutons", 200),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gestion des Stocks"),
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
                builder: (context) => HomeScreen(), // Remplacez PageDefault par votre widget de page par défaut
              ),
            );
          },
        ),
      ),
      body: ListView.builder(
        itemCount: stockItems.length,
        itemBuilder: (context, index) {
          final item = stockItems[index];
          return ListTile(
            title: Text(item.name),
            subtitle: Text("Quantité en stock : ${item.quantity}"),
            trailing: ElevatedButton(
              onPressed: () {
                // Simulation de réapprovisionnement
                item.restock();
                setState(() {}); // Met à jour la vue après le réapprovisionnement
              },
              child: Text("Réapprovisionner"),
            ),
          );
        },
      ),
    );
  }
}

class StockItem {
  String name;
  int quantity;

  StockItem(this.name, this.quantity);

  void restock() {
    // Ici, vous pouvez implémenter la logique de réapprovisionnement, par exemple, augmenter la quantité en stock.
    // Dans cet exemple, nous augmentons la quantité de 50 unités à chaque réapprovisionnement.
    quantity += 50;
  }
}
