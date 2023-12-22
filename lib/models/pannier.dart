import 'package:cloud_firestore/cloud_firestore.dart';

class Pannier {
  String? qteProduit;
  String? prixTotal;
  String? token;

  Pannier({this.prixTotal, this.qteProduit, this.token});
  factory Pannier.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> data) {
    final file = data.data();

    return Pannier(
        token: data.id,
        qteProduit: file["produitPrix"],
        prixTotal: file["qteStock"]);
  }
}
