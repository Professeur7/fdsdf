import 'package:flutter/material.dart';

import '../../screen/home_screen.dart';


class StockManagementPage extends StatefulWidget {
  @override
  _StockManagementPageState createState() => _StockManagementPageState();
}

class _StockManagementPageState extends State<StockManagementPage> {
  List<StockItem> stockItems = [
    StockItem("Tissus", 100, 5.0, "Fournisseur A"),
    StockItem("Fils", 50, 3.0, "Fournisseur B"),
    StockItem("Boutons", 200, 2.0, "Fournisseur C"),
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
                builder: (context) => HomeScreen(),
              ),
            );
          },
        ),
      ),
      body: ListView.builder(
        itemCount: stockItems.length,
        itemBuilder: (context, index) {
          final item = stockItems[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            color: item.quantity < 50 ? Colors.red.withOpacity(0.2) : Colors.white,
            child: ListTile(
              title: Text(
                item.name,
                style: TextStyle(
                  fontWeight: item.quantity < 50 ? FontWeight.bold : FontWeight.normal,
                  color: item.quantity < 50 ? Colors.red : Colors.black,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Quantité en stock : ${item.quantity}"),
                  Text("Prix unitaire : \$${item.unitPrice}"),
                  Text("Fournisseur : ${item.supplier}"),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  _editStockItem(context, item);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _addStockItem(context);
            },
            child: Icon(Icons.add),
            backgroundColor: const Color(0xFF09126C),
            tooltip: 'Ajouter un article',
          ),
        ],
      ),
    );
  }

  void _editStockItem(BuildContext context, StockItem item) {
    int quantityToAdd = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Modifier ${item.name}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  initialValue: item.name,
                  decoration: InputDecoration(labelText: 'Nom'),
                  onChanged: (value) {
                    item.name = value;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  initialValue: item.quantity.toString(),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Quantité'),
                  onChanged: (value) {
                    item.quantity = int.tryParse(value) ?? 0;
                  },
                ),
                SizedBox(height: 10),
                // Ajoutez d'autres champs pour éditer les informations nécessaires
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {});
                Navigator.of(context).pop();
              },
              child: Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  void _addStockItem(BuildContext context) {
    StockItem newItem = StockItem("", 0, 0.0, "");
    _editStockItem(context, newItem);
    setState(() {
      stockItems.add(newItem);
    });
  }
}

class StockItem {
  String name;
  int quantity;
  double unitPrice;
  String supplier;

  StockItem(this.name, this.quantity, this.unitPrice, this.supplier);
}


