import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion2/models/albums.dart';
import 'package:fashion2/models/atelier.dart';
import 'package:fashion2/models/models.dart';

class Tailleurs {
  String? token;
  String? image;
  String username;
  String? nom;
  String? prenom;
  String? telephone;
  String email;
  String genre;
  String password;
  Atelier? atelier;
  List<Models>? model;
  List<Albums>? albums;
  Tailleurs(
      {required this.password,
      this.nom,
      this.prenom,
      this.image,
      this.albums,
      required this.username,
      this.model,
      this.atelier,
      required this.email,
      required this.genre,
      this.telephone,
      token});
  factory Tailleurs.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> data) {
    final file = data.data();
    final modelData = file!["Model"];
    final albumsData = file["Albums"];
    final atelierData = file["Atelier"];
    List<Models> listModel;
    if (modelData != null) {
      listModel = List<Models>.from(
          modelData.map((element) => Models.fromSnapshot(element)));
    } else {
      listModel = [];
    }
    List<Albums>? listAlbums;
    if (albumsData != null) {
      listAlbums = List<Albums>.from(
          albumsData.map((element) => Albums.fromSnapshot(element)));
    } else {
      listAlbums = [];
    }

    Atelier? atelier;
    if (atelierData != null) {
      atelier =
          atelierData.map((element) => Atelier.fromSnapshot(element)).first;
    } else {
      atelier = null;
    }
    return Tailleurs(
        albums: listAlbums,
        username: file['username'],
        image: file['image'] ?? "",
        model: listModel,
        atelier: atelier,
        token: data.id,
        password: file["password"],
        nom: file["nom"] ?? "",
        prenom: file["prenom"] ?? "",
        email: file["email"],
        genre: file["gender"],
        telephone: file["telephone"] ?? "");
  }
}
