import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion2/models/image_model.dart';
import 'package:fashion2/models/models.dart';

class Client {
  String? token;
  String username;
  Images? profil;
  String? nom;
  String? prenom;
  String? telephone;
  String email;
  String genre;
  String? trancheAge;
  String password;
  var imageURL;
  List<Models>? model;

  Client(
      {required this.username,
      this.trancheAge,
      required this.password,
      this.nom,
      this.prenom,
      this.model,
      required this.email,
      required this.genre,
      this.telephone,
      this.token,
      this.profil,
      this.imageURL // Utilisez "this.token" pour initialiser la propriété
      });

  factory Client.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> data) {
    final file = data.data();
    final imageProfil = file!["Profil"];
    final modelData = file["Model"];

    Images? profil; // Déclarez logo comme une variable Images nullable

    if (imageProfil != null) {
      // Si imageLogo n'est pas null, créez une instance d'Images à partir des données
      profil = Images.fromSnapshot(imageProfil);
    } else {
      profil = null; // Si imageLogo est null, affectez null à logo
    }

    List<Models> listModel;
    if (modelData != null) {
      listModel = List<Models>.from(
          modelData.map((element) => Models.fromSnapshot(element)));
    } else {
      listModel = [];
    }

    return Client(
      imageURL: file["image"],
      profil: profil,
      password: file['password'] ?? "",
      username: file['username'] ?? "",
      model: listModel,
      token: data.id,
      trancheAge: file["trancheAge"] ?? "",
      nom: file["nom"] ?? "",
      prenom: file["prenom"] ?? "",
      email: file["email"] ?? "",
      genre: file["genre"] ?? "",
      telephone: file["telephone"] ?? "",
    );
  }
}
