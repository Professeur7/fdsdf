import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion2/models/albums.dart';
import 'package:fashion2/models/atelier.dart';
import 'package:fashion2/models/mesClients.dart';
import 'package:fashion2/models/models.dart';
import 'package:fashion2/models/paiement.dart';
import 'package:fashion2/models/poste.dart';
import 'package:fashion2/models/postevideo.dart';
import 'package:fashion2/models/rendez_vous.dart';
import 'package:fashion2/models/stock.dart';
import 'package:fashion2/models/tache.dart';

import 'mesure.dart';

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
  List<RDV>? rdv;
  List<Atelier>? atelier;
  List<Models>? model;
  List<Stock>? stock;
  List<Paiement>? paiement;
  List<Albums>? albums;

  List<Taches>? taches;
  List<Mesures>? mesure;
  List<MesClients>? mesClients;

  List<Poste>? postes;
  List<PosteVideo>? posteVideos;

  Tailleurs(
      {required this.password,
      this.paiement,
      this.stock,
      this.postes,
      this.nom,
      this.rdv,
      this.mesure,
      this.mesClients,
      this.prenom,
      this.image,
      this.albums,
      required this.username,
      this.model,
      this.atelier,
      required this.email,
      required this.genre,
      this.telephone,
      this.posteVideos,
      this.taches,
      this.token});
  factory Tailleurs.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> data) {
    final file = data.data();
    final modelData = file!["Model"];
    final albumsData = file["Albums"];
    final atelierData = file["Atelier"];

    final tacheData = file["Tache"];
    final rdvData = file["RDV"];
    final mesureData = file["Mesures"];
    final mesClientsData = file["MesClients"];
    final stockData = file["Stock"];
    final PaiementData = file["Paiement"];

    List<Paiement> listPaiement;
    if (PaiementData != null) {
      listPaiement = PaiementData.map((e) => Stock.fromSnapshot(e));
    } else {
      listPaiement = [];
    }

    List<Stock> listStock;
    if (stockData != null) {
      listStock = stockData.map((e) => Stock.fromSnapshot(e));
    } else {
      listStock = [];
    }

    List<MesClients> listMesClients;
    if (mesClientsData != null) {
      listMesClients = mesClientsData.map((e) => MesClients.fromSnapshot(e));
    } else {
      listMesClients = [];
    }

    List<Mesures> listMesures;
    if (tacheData != null) {
      listMesures = mesureData.map((e) => Mesures.fromSnapshot(e));
    } else {
      listMesures = [];
    }

    List<Taches> listTaches;
    if (tacheData != null) {
      listTaches = tacheData.map((e) => Taches.fromSnapshot(e));
    } else {
      listTaches = [];
    }
    List<RDV> listRDV;
    if (rdvData != null) {
      listRDV = rdvData.map((e) => RDV.fromSnapshot(e));
    } else {
      listRDV = [];
    }
    final posteData = file['Poste'];
    final posteVideoData = file['PosteVideos'];
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

    List<Atelier> listAtelier;
    if (atelierData != null) {
      listAtelier = atelierData.map((element) => Atelier.fromSnapshot(element));
    } else {
      listAtelier = [];
    }

    List<Poste>? listpsote;
    if (posteData != null) {
      listpsote = List<Poste>.from(
          posteData.map((element) => Poste.fromSnapshot(element)));
    } else {
      listpsote = [];
    }

    List<PosteVideo>? listvideopsote;
    if (posteVideoData != null) {
      listvideopsote = List<PosteVideo>.from(
          posteVideoData.map((element) => PosteVideo.fromSnapshot(element)));
    } else {
      listvideopsote = [];
    }
    return Tailleurs(
        rdv: listRDV,
        paiement: listPaiement,
        stock: listStock,
        postes: listpsote,
        mesClients: listMesClients,
        albums: listAlbums,
        mesure: listMesures,
        username: file['username'],
        image: file["image"] ?? "",
        model: listModel,
        atelier: listAtelier,
        taches: listTaches,
        token: data.id,
        password: file["password"],
        nom: file["nom"] ?? "",
        prenom: file["prenom"] ?? "",
        email: file["email"],
        genre: file["gender"],
        posteVideos: listvideopsote,
        telephone: file["telephone"] ?? "");
  }
}
