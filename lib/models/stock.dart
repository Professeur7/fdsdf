import 'package:cloud_firestore/cloud_firestore.dart';

class Stock {
  String? token;
  String produitName;
  String produitPrix;
  String qteStock;

  Stock(
      {required this.produitName,
      required this.produitPrix,
      required this.qteStock,
      token});

  factory Stock.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> data) {
    final file = data.data();

    return Stock(
        produitName: file!["produitName"],
        token: data.id,
        produitPrix: file["produitPrix"],
        qteStock: file["qteStock"]);
  }
}
