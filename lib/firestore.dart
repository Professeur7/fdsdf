import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion2/models/albums.dart';
import 'package:fashion2/models/atelier.dart';
import 'package:fashion2/models/client.dart';
import 'package:fashion2/models/image_model.dart';
import 'package:fashion2/models/models.dart';
import 'package:fashion2/models/tailleurs.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseManagement with ChangeNotifier {
  //create firebase Firestore database instance
  List<Tailleurs> tailleurs = [];
  List<Albums> _albums = [];
  List<Albums> get albums => _albums;
  Atelier _atelier = Atelier(nom: "nom", lieu: "lieu");
  Atelier get atelier => _atelier;
  final _db = FirebaseFirestore.instance;

  //create firebase Storage database instance
  final _refs = FirebaseStorage.instance;
//function to login a user

  //Cette fonction permet de mettre a jour l'utilisatuer dont les information seront passer en argument
  createTailleurs(Tailleurs User) async {
    final ref = await _db.collection("tailleurs").add({
      "email": User.email,
      "password": User.password,
      "gender": User.genre,
      "username": User.username,
      //"isTailleur": isTailleur,
    });
    final tailleur = await _db.collection("tailleurs").doc(ref.id).get();
    tailleurs.add(Tailleurs.fromSnapshot(tailleur));
    print("${tailleurs.length} est la taille de tailleurs");
    notifyListeners();
  }

  //de la fonction
  updateClientInformation(Tailleurs client, Models mode) async {
    try {
      await _db.collection("tailleurs").doc(client.token).update({
        "nom": client.nom,
        "prenom": client.prenom,
        "username": client.username,
        "email": client.email,
        "genre": client.genre,
        "password": client.password,
        "telephone": client.telephone,
      });
      print("updateClientInformation finish");
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<List<Tailleurs>> getAllTailleurs() async {
    final all = await _db.collection("tailleurs").get();
    final tailleurs = all.docs.map((e) => Tailleurs.fromSnapshot(e)).toList();
    print(tailleurs);
    return tailleurs;
  }

  creerModel(Models mode, String userToken) async {
    await _db.collection("tailleurs").doc(userToken).collection("Moldels").add(
        {"nom": mode.nom, "prix": mode.prix, "description": mode.description});
  }

  addImageToModel(Images image, String userToken, String modelToken) async {
    await _db
        .collection("tailleurs")
        .doc(userToken)
        .collection("Models")
        .doc(modelToken)
        .collection("Images")
        .add({"image": image.image});
  }

  creerAlbums(Albums mode, String userToken) async {
    await _db
        .collection("tailleurs")
        .doc(userToken)
        .collection("Albums")
        .add({"nom": mode.nom});
  }

  createAtelier(Atelier ateliers, String userToken) async {
    final monatelier = await _db
        .collection("tailleurs")
        .doc(userToken)
        .collection("ateliers")
        .add({
      "nom": ateliers.nom,
      "slogan": ateliers.slogan,
      "image": ateliers.imageUrl,
      "lieu": ateliers.lieu,
      "logo": ateliers.logo
    }).then((value) async {
      _atelier = Atelier.fromSnapshot(await value.get());
      notifyListeners();
    });
  }

  getAtelier(String userToken) async {
    final monatelier = await _db
        .collection("tailleurs")
        .doc(userToken)
        .collection("ateliers")
        .get();
    _atelier =
        monatelier.docs.map((e) => Atelier.fromSnapshot(e)).toList().first;
    notifyListeners();
  }

  addImageToAlbums(Images image, String userToken, String modelToken) async {
    await _db
        .collection("tailleurs")
        .doc(userToken)
        .collection("Albums")
        .doc(modelToken)
        .collection("Images")
        .add({"image": image.image});
    notifyListeners();
  }

  updateModel(Models mode, String userToken) async {
    await _db
        .collection("tailleurs")
        .doc(userToken)
        .collection("Moldels")
        .doc(mode.token)
        .update({
      "nom": mode.nom,
      "prix": mode.prix,
      "description": mode.description
    });
    notifyListeners();
  }

  // Méthode de mise à jour de l'image de profil
  Future<bool> updateProfileImage(String token, String imageUrl) async {
    try {
      print("ffffffffffffhhhhhhhhh");
      await _db.collection("tailleurs").doc(token).update({
        "image": imageUrl,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  //function to delete client instance
  deleteClient(Tailleurs client) async {
    await _db.collection("tailleurs").doc(client.token).delete();
  }

  // //function to get All client
  // Future<List<ClientModel>> getClients() async {
  //   final data = await _db.collection("Client").get();
  //   final clients = data.docs.map((e) => ClientModel.fromSnapshot(e)).toList();
  //   for (final i in clients) {
  //     //get specifics client likes list from firebase
  //     final likes = await _db
  //         .collection("Client")
  //         .doc(i.firebaseToken)
  //         .collection("Like")
  //         .get();
  //     //get specifics client Commandes list from firebase
  //     final commandes = await _db
  //         .collection("Client")
  //         .doc(i.firebaseToken)
  //         .collection("Commande")
  //         .get();
  //     //get specifics client Panniers list from firebase
  //     final panniers = await _db
  //         .collection("Client")
  //         .doc(i.firebaseToken)
  //         .collection("Pannier")
  //         .get();
  //     //add likes list to client likes list
  //     final likesListe =
  //         likes.docs.map((e) => LikeModel.fromSnapshot(e)).toList();
  //     i.likes = likesListe;
  //     //add Commande list to client Commande list
  //     final commandeListe =
  //         commandes.docs.map((e) => CommandeModel.fromSnapshot(e)).toList();
  //     i.commandes = commandeListe;
  //     //add Pannier list to client pannier list
  //     final pannierListe =
  //         panniers.docs.map((e) => PanierModel.fromSnapshot(e)).toList();
  //     i.panniers = pannierListe;
  //   }
  //   return clients;
  // }

  // //function to get All client

  // Future<ClientModel> getClient(String firebaseToken) async {
  //   final data = await _db.collection("Client").doc(firebaseToken).get();

  //   final Lclient = ClientModel.fromSnapshot(data);
  //   return Lclient;
  // }

  // //function get All Categories
  // Future<List<CategorieModel>> getCategorieAndProduc() async {
  //   final data = await _db.collection(categoriCollection).get();
  //   final categories =
  //       data.docs.map((e) => CategorieModel.fromSnapshot(e)).toList();
  //   try {
  //     for (CategorieModel i in categories) {
  //       //get specifics categorie products list from firebase
  //       final products = await _db
  //           .collection(categoriCollection)
  //           .doc(i.firebaseToken)
  //           .collection(productCollection)
  //           .get();
  //       print(i.nom);
  //       final newproducts = await _db
  //           .collection(categoriCollection)
  //           .doc(i.firebaseToken)
  //           .collection(newProductCollection)
  //           .get();
  //       //add products list to client product list
  //       final newList = newproducts.docs
  //           .map((e) => NewProductModel.fromSnapshot(e))
  //           .toList();
  //       final productListe =
  //           products.docs.map((e) => ProduitModel.fromSnapshot(e)).toList();
  //       i.listProduit = productListe;
  //       i.listNews = newList;
  //     }
  //   } catch (e) {
  //     print("errorin Firebase : $e");
  //   }

  //   return categories;
  // }

  // //function to create commande
  // createCommande(String client, CommandeModel commande) async {
  //   final commandeRef =
  //       await _db.collection("Client").doc(client).collection("Commande").add({
  //     "Date": commande.dateCommande,
  //     "Etat": commande.etatCommande,
  //     "qteStock": commande.qteCommande,
  //     "Adresse": commande.adresseLivraison,
  //     "PrixTotal": commande.prix
  //   });
  //   final newRef = commandeRef.id;
  //   for (final cmd in commande.produit) {
  //     final rf = await _db
  //         .collection("Client")
  //         .doc(client)
  //         .collection("Commande")
  //         .doc(newRef)
  //         .collection("Pannier")
  //         .add({
  //       "qteProduit": cmd.qteProduit,
  //       "prixTotal": cmd.prixTotal,
  //     });
  //     for (final prod in commande.produit.first.produit) {
  //       await _db
  //           .collection("Client")
  //           .doc(client)
  //           .collection("Commande")
  //           .doc(newRef)
  //           .collection("Pannier")
  //           .doc(rf.id)
  //           .collection("Produits")
  //           .add({
  //         "Nom": prod.nom,
  //         "Description": prod.description,
  //         "Prix": prod.prix,
  //         "Like": false,
  //         "Image": prod.image,
  //         "qteCommande": prod.qteCommande,
  //       });
  //     }
  //   }
  // }

  // Future<List<CommandeModel>> getAllCommande(String client) async {
  //   try {
  //     final data = await _db
  //         .collection("Client")
  //         .doc(client)
  //         .collection("Commande")
  //         .get();
  //     final commandes =
  //         data.docs.map((e) => CommandeModel.fromSnapshot(e)).toList();

  //     for (final i in commandes) {
  //       // Obtenir la liste spécifique des produits de la catégorie à partir de Firebase
  //       final products = await _db
  //           .collection("Client")
  //           .doc(client)
  //           .collection("Commande")
  //           .doc(i.firebaseToken)
  //           .collection('Pannier')
  //           .get();
  //       // Ajouter la liste des produits à la liste des produits du client
  //       final pannierListe =
  //           products.docs.map((e) => PanierModel.fromSnapshot(e)).toList();
  //       for (final p in pannierListe) {
  //         final product = await _db
  //             .collection("Client")
  //             .doc(client)
  //             .collection("Commande")
  //             .doc(i.firebaseToken)
  //             .collection('Pannier')
  //             .doc(p.firebaseToken)
  //             .collection(productCollection)
  //             .get();
  //         // Ajouter la liste des produits à la liste des produits du client
  //         final produitListe = product.docs
  //             .map((e) => AchatProduitModel.fromSnapshot(e))
  //             .toList();
  //         p.produit = produitListe;
  //       }
  //       i.produit = pannierListe;
  //     }

  //     return commandes;
  //   } catch (e) {
  //     print(e);
  //     return List.empty();
  //   }
  // }

  // //function to delete Commande
  // deleteCommande(ClientModel client, CommandeModel commande) async {
  //   await _db
  //       .collection("Client")
  //       .doc(client.firebaseToken)
  //       .collection("Commande")
  //       .doc(commande.firebaseToken)
  //       .delete();
  // }

  // //function to create pannier
  // createPannier(String client, PanierModel pannier) async {
  //   final pannierRef = await _db
  //       .collection("Client")
  //       .doc(client)
  //       .collection("Pannier")
  //       .add(
  //           {'qteProduit': pannier.qteProduit, 'prixTotal': pannier.prixTotal});
  //   final newRef = pannierRef.id;
  //   {
  //     await _db
  //         .collection("Client")
  //         .doc(client)
  //         .collection("Pannier")
  //         .doc(newRef)
  //         .collection(productCollection)
  //         .add({
  //       "Nom": pannier.produit.last.nom,
  //       "Description": pannier.produit.last.description,
  //       "Prix": pannier.produit.last.prix,
  //       "Like": false,
  //       "Image": pannier.produit.last.image,
  //       "qteCommande": pannier.produit.last.qteCommande,
  //     });
  //   }
  // }

  // Future<List<PanierModel>> getAllPannier(String client) async {
  //   try {
  //     final data = await _db
  //         .collection("Client")
  //         .doc(client)
  //         .collection("Pannier")
  //         .get();
  //     final paniers =
  //         data.docs.map((e) => PanierModel.fromSnapshot(e)).toList();

  //     for (final i in paniers) {
  //       // Obtenir la liste spécifique des produits de la catégorie à partir de Firebase
  //       final products = await _db
  //           .collection("Client")
  //           .doc(client)
  //           .collection("Pannier")
  //           .doc(i.firebaseToken)
  //           .collection(productCollection)
  //           .get();
  //       // Ajouter la liste des produits à la liste des produits du client
  //       final productListe = products.docs
  //           .map((e) => AchatProduitModel.fromSnapshot(e))
  //           .toList();
  //       i.produit = productListe;
  //     }
  //     ;

  //     return paniers;
  //   } catch (e) {
  //     return List.empty();
  //   }
  // }

  // //function to update pannier
  // updatePannier(client, AchatProduitModel pannier, pannierToken) async {
  //   await _db
  //       .collection("Client")
  //       .doc(client)
  //       .collection("Pannier")
  //       .doc(pannierToken)
  //       .collection("Produits")
  //       .add({
  //     "Nom": pannier.nom,
  //     "Description": pannier.description,
  //     "Prix": pannier.prix,
  //     "Image": pannier.image,
  //     "qteCommande": pannier.qteCommande,
  //     "Like": false,
  //   });
  // }

  // deleteProductPannier(client, PanierModel panier, produit) async {
  //   await _db
  //       .collection("Client")
  //       .doc(client)
  //       .collection("Pannier")
  //       .doc(panier.firebaseToken)
  //       .collection(productCollection)
  //       .doc(produit)
  //       .delete();
  // }

  // deletePannier(client, PanierModel panier) async {
  //   await _db
  //       .collection("Client")
  //       .doc(client)
  //       .collection("Pannier")
  //       .doc(panier.firebaseToken)
  //       .delete();
  // }

  // //function to like product
  // addToLike(String client, ProduitModel like) async {
  //   await _db.collection("Client").doc(client).collection("Like").add({
  //     "Nom": like.nom,
  //     "Description": like.description,
  //     "Prix": like.prix,
  //     "Image": like.image,
  //     "qteStock": like.qteStock,
  //     "Like": like.like,
  //     "FirebaseToken": like.firebaseToken
  //   });
  // }

  // //fuction to get liked product

  // Future<List<LikeModel>> getLikedList(String client) async {
  //   final data =
  //       await _db.collection("Client").doc(client).collection("Like").get();
  //   final likes = data.docs.map((e) => LikeModel.fromSnapshot(e)).toList();
  //   return likes;
  // }

  // //function to diselike product
  // deleteLike(String client, LikeModel like) async {
  //   await _db
  //       .collection("Client")
  //       .doc(client)
  //       .collection("Like")
  //       .doc(like.firebaseToken)
  //       .delete();
  // }
}
