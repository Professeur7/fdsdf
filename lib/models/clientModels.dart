import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion2/models/commandeModel.dart';
import 'package:fashion2/models/likeModel.dart';
import 'package:fashion2/models/panierModel.dart';

class ClientModel {
  String token;
  String name;
  int age;
  List<LikeModel> likes;
  List<CommandeModel> commandes;
  List<PanierModel> panniers;

  ClientModel({
    required this.token,
    required this.name,
    required this.age,
    required this.likes,
    required this.commandes,
    required this.panniers,
  });

  factory ClientModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return ClientModel(
      token: snapshot.id,
      name: data['name'] ?? '',
      age: data['age'] ?? 0,
      likes: [], // Initialement vide, seront ajoutés plus tard
      commandes: [], // Initialement vide, seront ajoutés plus tard
      panniers: [], // Initialement vide, seront ajoutés plus tard
    );
  }
}
