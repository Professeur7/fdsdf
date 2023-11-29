import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion2/models/albums.dart';
import 'package:fashion2/models/atelier.dart';
import 'package:fashion2/models/client.dart';
import 'package:fashion2/models/image_model.dart';
import 'package:fashion2/models/mesure.dart';
import 'package:fashion2/models/models.dart';
import 'package:fashion2/models/poste.dart';
import 'package:fashion2/models/tailleurs.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class FirebaseManagement extends GetxController {
  //create firebase Firestore database instance
  List<Tailleurs> tailleurs = <Tailleurs>[].obs;
  List<Client> clients = <Client>[].obs;
  List<Mesures> mesures = <Mesures>[].obs;
  List<Albums> albums = <Albums>[].obs;
  List<Atelier> atelier = <Atelier>[].obs;
  List<Poste> Postes = <Poste>[].obs;
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
  }

  postPublication(Poste poste, String token) async {
    final ref = await _db
        .collection("tailleurs")
        .doc(token)
        .collection("Poste")
        .add({"description": poste.description});

    for (final image in poste.images!) {
      await _db
          .collection("tailleurs")
          .doc(token)
          .collection("Poste")
          .doc(ref.id)
          .collection("Images")
          .add({"image": image.image});
    }
    Postes.add(poste);
    tailleurs.first.postes = Postes;
  }

  Future<List<Poste>> getPublication(String token) async {
    final poste =
        await _db.collection("tailleurs").doc(token).collection("Poste").get();
    final posteList =
        await poste.docs.map((e) => Poste.fromSnapshot(e)).toList();
    for (final p in posteList) {
      final imgs = await _db
          .collection("tailleurs")
          .doc(token)
          .collection("Poste")
          .doc(p.token)
          .collection("Images")
          .get();
      final img = await imgs.docs.map((e) => Images.fromSnapshot(e)).toList();
      p.images = img;
    }
    Postes = posteList;
    tailleurs.first.postes = posteList;
    return posteList;
  }

  createClient(Client User) async {
    final ref = await _db.collection("Clients").add({
      "email": User.email,
      "password": User.password,
      "gender": User.genre,
      "username": User.username,
      //"isTailleur": isTailleur,
    });
    final tailleur = await _db.collection("Clients").doc(ref.id).get();
    clients.add(Client.fromSnapshot(tailleur));
    print("${tailleurs.length} est la taille de clients");
  }

  //de la fonction
  updateTailleurInformation(Tailleurs client) async {
    try {
      await _db.collection("tailleurs").doc(client.token).update({
        "nom": client.nom,
        "prenom": client.prenom,
        "username": client.username,
        "email": client.email,
        "gender": client.genre,
        "password": client.password,
        "telephone": client.telephone,
      }).then((value) async {
        final tall = await _db.collection("tailleurs").doc(client.token).get();
        tailleurs = [Tailleurs.fromSnapshot(await tall)];
      });
      print("updateClientInformation finish");
    } catch (e) {
      print(e);
    }
  }

  getTailleur(Tailleurs tailleur) async {
    final atelie = await _db
        .collection("tailleurs")
        .doc(tailleur.token)
        .collection("ateliers")
        .get();
    final listaltelier =
        atelie.docs.map((e) => Atelier.fromSnapshot(e)).toList();
    final all = await _db
        .collection("tailleurs")
        .doc(tailleur.token)
        .collection("Albums")
        .get();
    final albums = all.docs.map((e) => Albums.fromSnapshot(e)).toList();
    for (final photo in albums) {
      final photos = await _db
          .collection("tailleurs")
          .doc(tailleur.token)
          .collection("Albums")
          .doc(photo.token)
          .collection("Images")
          .get();
      final gap = photos.docs.map((e) => Images.fromSnapshot(e)).toList();
      photo.images = gap;
    }
    getPublication(tailleur.token!);
    tailleur.albums = albums;
    tailleur.atelier = listaltelier.first;
    atelier = listaltelier;
    tailleurs.isEmpty
        ? tailleurs.add(tailleur)
        : {tailleurs.clear(), tailleurs.add(tailleur)};
  }

  getClient(Client c) async {
    final all = await _db.collection("Clients").doc(c.token).get();
    //final al = all.docs.map((e) => Albums.fromSnapshot(e)).toList();
    //tailleur.albums = albums;
    final client = Client.fromSnapshot(all);
    clients.isEmpty
        ? clients.add(client)
        : {clients.clear(), clients.add(client)};
  }

  Future<List<Tailleurs>> getAllTailleurs() async {
    final all = await _db.collection("tailleurs").get();
    final tailleurs = all.docs.map((e) => Tailleurs.fromSnapshot(e)).toList();
    print(tailleurs);
    print(tailleurs.first.token);
    return tailleurs;
  }

  Future<List<Client>> getAllClient() async {
    final all = await _db.collection("Clients").get();
    final client = all.docs.map((e) => Client.fromSnapshot(e)).toList();
    print(client);
    return client;
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
    final ref = await _db
        .collection("tailleurs")
        .doc(userToken)
        .collection("Albums")
        .add({"title": mode.nom});
    mode.token = await ref.id;
    tailleurs.first.albums!.add(mode);
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
      atelier.add(Atelier.fromSnapshot(await value.get()));
    });
  }

  getAtelier(String userToken) async {
    final monatelier = await _db
        .collection("tailleurs")
        .doc(userToken)
        .collection("ateliers")
        .get();
    atelier = monatelier.docs.map((e) => Atelier.fromSnapshot(e)).toList();
  }

  addImageToAlbums(String? image, String userToken, String modelToken) async {
    final f = await _db
        .collection("tailleurs")
        .doc(userToken)
        .collection("Albums")
        .doc(modelToken)
        .collection("Images")
        .add({"image": image});
    tailleurs.first.albums!
        .where((element) => element.token == modelToken)
        .first
        .images!
        .add(Images(image: image!, token: f.id));
  }

  createMesure(String tokenTailleur, Mesures mesure) async {
    final ref = await _db
        .collection("tailleurs")
        .doc(tokenTailleur)
        .collection("Mesures")
        .add({
      "entreJambe": mesure.hauteurEntrejambe,
      "totale": mesure.hauteurTotale,
      "epaule": mesure.largeursEpaules,
      "jambe": mesure.longueurJambes,
      "manche": mesure.longueurManches,
      "ourlet": mesure.longueurOurlet,
      "bras": mesure.tourBras,
      "cou": mesure.tourCou,
      "dos": mesure.tourDos,
      "hanche": mesure.tourHanche,
      "poignet": mesure.tourPoignet,
      "poitrine": mesure.tourPoitrine,
      "taille": mesure.tourTaille
    });
    await _db
        .collection("tailleurs")
        .doc(tokenTailleur)
        .collection("Mesures")
        .doc(ref.id)
        .collection("Clients")
        .add({
      "username": mesure.client!.username,
      "trancheAge": mesure.client!.trancheAge,
      "telephone": mesure.client!.telephone,
      "prenom": mesure.client!.prenom,
      "password": mesure.client!.password,
      "nom": mesure.client!.nom,
      "gender": mesure.client!.genre,
      "email": mesure.client!.email
    });
    final refmode = await _db
        .collection("tailleurs")
        .doc(tokenTailleur)
        .collection("Mesures")
        .doc(ref.id)
        .collection("Models")
        .add({
      "prix": mesure.models!.prix,
      "nom": mesure.models!.nom,
      "description": mesure.models!.description
    });
    for (final c in mesure.models!.images!) {
      await _db
          .collection("tailleurs")
          .doc(tokenTailleur)
          .collection("Mesures")
          .doc(ref.id)
          .collection("Models")
          .doc(refmode.id)
          .collection("Images")
          .add({"image": c.image});
    }
    mesures.add(mesure);
  }

  UpdateMesure(String tokenTailleur, Mesures mesure, String mesureToken) async {
    await _db
        .collection("tailleurs")
        .doc(tokenTailleur)
        .collection("Mesures")
        .doc(mesureToken)
        .update({
      "entreJambe": mesure.hauteurEntrejambe,
      "totale": mesure.hauteurTotale,
      "epaule": mesure.largeursEpaules,
      "jambe": mesure.longueurJambes,
      "manche": mesure.longueurManches,
      "ourlet": mesure.longueurOurlet,
      "bras": mesure.tourBras,
      "cou": mesure.tourCou,
      "dos": mesure.tourDos,
      "hanche": mesure.tourHanche,
      "poignet": mesure.tourPoignet,
      "poitrine": mesure.tourPoitrine,
      "taille": mesure.tourTaille
    });
    await _db
        .collection("tailleurs")
        .doc(tokenTailleur)
        .collection("Mesures")
        .doc(mesureToken)
        .collection("Clients")
        .doc(mesure.client!.token)
        .update({
      "username": mesure.client!.username,
      "trancheAge": mesure.client!.trancheAge,
      "telephone": mesure.client!.telephone,
      "prenom": mesure.client!.prenom,
      "password": mesure.client!.password,
      "nom": mesure.client!.nom,
      "gender": mesure.client!.genre,
      "email": mesure.client!.email
    });
    final refmode = await _db
        .collection("tailleurs")
        .doc(tokenTailleur)
        .collection("Mesures")
        .doc(mesureToken)
        .collection("Models")
        .doc(mesure.models!.token)
        .update({
      "prix": mesure.models!.prix,
      "nom": mesure.models!.nom,
      "description": mesure.models!.description
    });
    mesures.add(mesure);
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
  deleteTailleurs(Tailleurs client) async {
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
