import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion2/models/client.dart';
import 'package:fashion2/models/tailleurs.dart';
import 'package:flutter/material.dart';

class Compte {
  String? token;
  String motDePasse;
  String telephone;
  String login;
  String role;
  Image? profil;
  Tailleurs tailleurs;
  Client client;
  Compte(
      {required this.motDePasse,
      required this.login,
      this.profil,
      required this.role,
      required this.tailleurs,
      required this.client,
      required this.telephone,
      token});
  factory Compte.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> data) {
    final file = data.data();
    final dataClient = file!["Client"];
    final dataTailleur = file["Tailleur"];

    Client client;
    if (dataClient != null) {
      client = dataClient.map((element) => Client.fromSnapshot(element));
    } else {
      client = [] as Client;
    }

    Tailleurs tailleurs;
    if (dataTailleur != null) {
      tailleurs =
          dataTailleur.map((element) => Tailleurs.fromSnapshot(element));
    } else {
      tailleurs = [] as Tailleurs;
    }

    return Compte(
        token: data.id,
        motDePasse: file["mot de passe"],
        role: file["Role"],
        telephone: file["Telephone"],
        login: file["login"],
        tailleurs: tailleurs,
        client: client);
  }
}
