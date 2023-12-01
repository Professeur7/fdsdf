import 'package:cloud_firestore/cloud_firestore.dart';

class MesClients {
  String? token;
  String? nom;
  String? prenom;
  String? telephone;
  String? email;
  String? genre;
  String? trancheAge;

  MesClients({
    this.trancheAge,
    required this.nom,
    this.prenom,
    this.email,
    this.genre,
    this.telephone,
    this.token, // Utilisez "this.token" pour initialiser la propriété
  });

  factory MesClients.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> data) {
    final file = data.data();

    return MesClients(
      token: data.id,
      trancheAge: file!["trancheAge"],
      nom: file["nom"],
      prenom: file["prenom"],
      email: file["email"],
      genre: file["gender"],
      telephone: file["telephone"],
    );
  }
}
