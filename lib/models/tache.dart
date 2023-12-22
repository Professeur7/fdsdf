import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion2/models/soustaches.dart';

class Taches {
  String? token;
  String nom;
  List<SousTaches>? sousTaches;
  Taches({required this.nom, this.token, this.sousTaches});
  factory Taches.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> data) {
    final file = data.data();
    final dataSousTaches = file!["SousTaches"];
    List<SousTaches> ListSousTAches;
    if (dataSousTaches != null) {
      ListSousTAches = dataSousTaches.map((e) => SousTaches.fromSnapshot(e));
    } else {
      ListSousTAches = [];
    }
    return Taches(nom: file["nom"], token: data.id, sousTaches: ListSousTAches);
  }
}
