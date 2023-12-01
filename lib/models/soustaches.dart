import 'package:cloud_firestore/cloud_firestore.dart';

class SousTaches {
  String? token;
  bool valide;
  DateTime debut;
  DateTime fin;
  String description;

  SousTaches(
      {required this.debut,
      required this.fin,
      required this.valide,
      required this.description,
      token});
  factory SousTaches.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> data) {
    final file = data.data();
    return SousTaches(
      token: data.id,
      description: file!["description"],
      valide: file["valide"],
      debut: file["Debut"],
      fin: file["Fin"],
    );
  }
}
