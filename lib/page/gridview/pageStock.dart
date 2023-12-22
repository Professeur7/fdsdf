import 'package:fashion2/models/stock.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../firestore.dart';
import '../../screen/home_screen.dart';

class StockManagementPage extends StatefulWidget {
  @override
  _StockManagementPageState createState() => _StockManagementPageState();
}

class _StockManagementPageState extends State<StockManagementPage> {
  FirebaseManagement _management = Get.put(FirebaseManagement());
  List<Stock> stockItems = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stockItems = _management.tailleurs.first.stock!;
  }

  @override
  Widget build(BuildContext context) {
    stockItems = _management.tailleurs.first.stock!;
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
            color:
                item.qteStock < 50 ? Colors.red.withOpacity(0.2) : Colors.white,
            child: ListTile(
              title: Text(
                item.produitName,
                style: TextStyle(
                  fontWeight:
                      item.qteStock < 50 ? FontWeight.bold : FontWeight.normal,
                  color: item.qteStock < 50 ? Colors.red : Colors.black,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Quantité en stock : ${item.qteStock}"),
                  Text("Prix unitaire : ${item.produitPrix}"),
                  Text("Fournisseur : ${item.suplier}"),
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
              _addStockItem(context, null);
            },
            child: Icon(Icons.add),
            backgroundColor: const Color(0xFF09126C),
            tooltip: 'Ajouter un article',
          ),
        ],
      ),
    );
  }

  void _editStockItem(BuildContext context, item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController nom = TextEditingController(
                text: item != null ? item.produitName : ""),
            prix = TextEditingController(
                text: item != null ? item.produitPrix.toString() : ""),
            qte = TextEditingController(
                text: item != null ? item.qteStock.toString() : ""),
            suplier =
                TextEditingController(text: item != null ? item.suplier : "");
        return AlertDialog(
          title:
              Text('${item != null ? "Modifier " + item.produitName : "New"}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: nom,
                  //initialValue: item != null ? item.produitName : "",
                  decoration: InputDecoration(labelText: 'Nom'),
                  onChanged: (value) {
                    item != null ? item.produitName = value : "";
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: qte,
                  //initialValue: item != null ? item.qteStock.toString() : "",
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Quantité'),
                  onChanged: (value) {
                    item != null
                        ? item.qteStock = int.tryParse(value) ?? 0
                        : "";
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: suplier,
                  //initialValue: item != null ? item.suplier : "",
                  decoration: InputDecoration(labelText: 'Fournisseur'),
                  onChanged: (value) {
                    item != null ? item.suplier = value : "";
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: prix,
                  //initialValue: item != null ? item.produitPrix.toString() : "",
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Prix unitaire'),
                  onChanged: (value) {
                    item != null
                        ? item.produitPrix = int.tryParse(value) ?? 0
                        : "";
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
                Stock st = Stock(
                    produitName: nom.text,
                    produitPrix: int.parse(prix.text),
                    qteStock: int.parse(qte.text),
                    suplier: suplier.text);
                if (item != null) {
                  _management.updateStock(
                      item, _management.tailleurs.first.token!, item.token);
                } else {
                  _management.manageStock(
                      st, _management.tailleurs.first.token!);
                  stockItems.add(st);
                }
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

  void _addStockItem(BuildContext context, Stock? stock) {
    _editStockItem(context, stock);
  }
}
