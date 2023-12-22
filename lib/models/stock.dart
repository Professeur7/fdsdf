import 'package:cloud_firestore/cloud_firestore.dart';

class Stock {
  String? token;
  String produitName;
  num produitPrix;
  int qteStock;
  String suplier;

  Stock(
      {required this.produitName,
      required this.produitPrix,
      required this.qteStock,
      required this.suplier,
      this.token});

  factory Stock.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> data) {
    final file = data.data();

    return Stock(
        produitName: file!["produitName"],
        suplier: file['supplier'],
        token: data.id,
        produitPrix: file["produitPrix"],
        qteStock: file["qteStock"]);
  }
}
