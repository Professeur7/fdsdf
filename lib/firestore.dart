import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion2/models/achatProduitModel.dart';
import 'package:fashion2/models/albums.dart';
import 'package:fashion2/models/atelier.dart';
import 'package:fashion2/models/categorieModel.dart';
import 'package:fashion2/models/chat/message.dart';
import 'package:fashion2/models/client.dart';
import 'package:fashion2/models/clientModels.dart';
import 'package:fashion2/models/commandeModel.dart';
import 'package:fashion2/models/habit.dart';
import 'package:fashion2/models/image_model.dart';
import 'package:fashion2/models/likeModel.dart';
import 'package:fashion2/models/mesClients.dart';
import 'package:fashion2/models/models.dart';
import 'package:fashion2/models/newProduitModel.dart';
import 'package:fashion2/models/paiement.dart';
import 'package:fashion2/models/panierModel.dart';
import 'package:fashion2/models/poste.dart';
import 'package:fashion2/models/posteAtelier.dart';
import 'package:fashion2/models/postevideo.dart';
import 'package:fashion2/models/produitModel.dart';
import 'package:fashion2/models/soustaches.dart';
import 'package:fashion2/models/stock.dart';
import 'package:fashion2/models/tache.dart';
import 'package:fashion2/models/tailleurs.dart';
import 'package:fashion2/models/video_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'models/mesure.dart';
import 'models/rendez_vous.dart';

class FirebaseManagement extends GetxController {
  final auth = FirebaseAuth.instance.obs;
  static var isnotIn = false.obs;
  //create firebase Firestore database instance
  List<Tailleurs> tailleurs = <Tailleurs>[].obs;
  List<Client> clients = <Client>[].obs;
  List<Albums> albums = <Albums>[].obs;
  List<Stock> stock = <Stock>[].obs;
  List<CommandeModel> commandes = <CommandeModel>[].obs;
  List<CommandeModel> commandestailleurs = <CommandeModel>[].obs;
  List<Tailleurs> allsTailleur = <Tailleurs>[].obs;
  List<PostAtelierVideo> allVideoPostes = <PostAtelierVideo>[].obs;
  List<PostAtelier> allPoste = <PostAtelier>[].obs;
  List<Taches> taches = <Taches>[].obs;
  List<Paiement> paiement = <Paiement>[].obs;
  List<RDV> rdv = <RDV>[].obs;
  List<Client> allClient = <Client>[].obs;
  List<CommandeModel> allCommandes = <CommandeModel>[].obs;
  List<MesClients> mesClients = <MesClients>[].obs;
  List<Mesures> mesures = <Mesures>[].obs;
  List<Atelier> atelier = <Atelier>[].obs;

  List<Poste> Postes = <Poste>[].obs;
  List<PosteVideo> posteVideos = <PosteVideo>[].obs;
  final _db = FirebaseFirestore.instance;

  //create firebase Storage database instance
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
        "image": client.image,
        "prenom": client.prenom,
        "username": client.username,
        "email": client.email,
        "gender": client.genre,
        "password": client.password,
        "telephone": client.telephone,
      }).then((value) async {
        await auth.value.currentUser!.updateEmail(client.email);
        auth.value.currentUser!.updatePassword(client.password);
        final tall = await _db.collection("tailleurs").doc(client.token).get();
        tailleurs = [Tailleurs.fromSnapshot(await tall)];
      });
      print("updateClientInformation finish");
    } catch (e) {
      print(e);
    }
  }

  updateClientInformation(Client client, clientoken) async {
    try {
      await _db.collection("Clients").doc(clientoken).update({
        "image": client.imageURL,
        "nom": client.nom,
        "prenom": client.prenom,
        "username": client.username,
        "email": client.email,
        "gender": client.genre,
        "password": client.password,
        "telephone": client.telephone,
      }).then((value) async {
        await auth.value.currentUser!.updateEmail(client.email);
        auth.value.currentUser!.updatePassword(client.password);
        final Clien = await _db.collection("Clients").doc(client.token).get();
        clients = [Client.fromSnapshot(await Clien)];
      });
      print("updateClientInformation finish");
    } catch (e) {
      print(e);
    }
  }

  getTailleur(Tailleurs tailleur) async {
    final all = await _db
        .collection("tailleurs")
        .doc(tailleur.token)
        .collection("Albums")
        .get();
    final albums = all.docs.map((e) => Albums.fromSnapshot(e)).toList();
    for (final al in albums) {
      final img = await _db
          .collection("tailleurs")
          .doc(tailleur.token)
          .collection("Albums")
          .doc(al.token)
          .collection("Images")
          .get();
      final imgList = img.docs.map((e) => Images.fromSnapshot(e)).toList();
      al.images = imgList;
    }
    final end = await getAtelier(tailleur.token!);
    tailleur.atelier = end;
    tailleur.mesClients = await getMesClient(tailleur.token!);
    tailleur.mesure = await getMesures(tailleur.token!);
    tailleur.rdv = await getRDV(tailleur.token!);
    tailleur.taches = await getTaches(tailleur.token!);
    tailleur.paiement = await getPaiement(tailleur.token!);
    tailleur.stock = await getStock(tailleur.token!);
    tailleur.albums = albums;
    getAllClients();
    commandes = await getAllCommande(tailleur.token!);
    //commandestailleurs = await tailleurCommande();

    tailleur.postes = await getPublication(tailleur.token!);
    tailleur.posteVideos = await getVideoPublication(tailleur.token!);
    tailleurs.isEmpty
        ? tailleurs.add(tailleur)
        : {tailleurs.clear(), tailleurs.add(tailleur)};
    getAllTailleurs();
    List<CommandeModel> list = [];
    for (final i in commandes) {
      if (i.tailleurToken == tailleur.token) {
        list.add(i);
      }
    }
    commandestailleurs = list;
  }

  getAllClients() async {
    allClient = await getAllClient();
    List<CommandeModel> list = [];
    for (final i in allClient) {
      list = await getAllCommande(i.token!);
      for (final j in list) {
        allCommandes.add(j);
      }
    }
  }

  tailleurCommande() async {
    List<CommandeModel> list = [];
    for (final i in allCommandes) {
      if (i.tailleurToken == tailleurs.first.token) {
        list.add(i);
      }
    }
    commandestailleurs = list;
  }

  Future<Client> getClient(Client c) async {
    final all = await _db.collection("Clients").doc(c.token).get();
    //final al = all.docs.map((e) => Albums.fromSnapshot(e)).toList();
    //tailleur.albums = albums;
    final client = Client.fromSnapshot(all);
    clients.isEmpty
        ? clients.add(client)
        : {clients.clear(), clients.add(client)};

    commandes = await getAllCommande(client.token!);
    return client;
  }

  Future<List<Tailleurs>> getAllTailleurs() async {
    final all = await _db.collection("tailleurs").get();
    final tailleurs = all.docs.map((e) => Tailleurs.fromSnapshot(e)).toList();
    print(tailleurs);
    allsTailleur = tailleurs;
    print(tailleurs.first.token);
    try {
      for (final i in tailleurs) {
        final listPost = await getPublication(i.token!);
        final listPostVideo = await getVideoPublication(i.token!);
        i.atelier = await getAtelier(i.token!);
        if (i.atelier!.isNotEmpty) {
          allPoste.add(PostAtelier(
              tailleurToken: i.token!,
              atelierNAme: i.atelier!.first.nom,
              lieux: i.atelier!.first.lieu,
              photAtelier: i.atelier!.first.imageUrl!,
              pub: listPost));
          allVideoPostes.add(PostAtelierVideo(
              tailleurToken: i.token!,
              atelierNAme: i.atelier!.first.nom,
              lieux: i.atelier!.first.lieu,
              photAtelier: i.atelier!.first.imageUrl!,
              pub: listPostVideo));
        }
      }
    } catch (e) {
      print("this the post error $e");
    }

    return tailleurs;
  }

  Future<List<Client>> getAllClient() async {
    final all = await _db.collection("Clients").get();
    final client = all.docs.map((e) => Client.fromSnapshot(e)).toList();
    print(client);
    return client;
  }

  CreerMesures(Mesures mesure, String tailleurToken) async {
    final ref = await _db
        .collection("tailleurs")
        .doc(tailleurToken)
        .collection("Mesures")
        .add({
      "avance": mesure.avance,
      "reste": mesure.reste,
      "image": mesure.habit.first.image,
      "descriptionHabit": mesure.habit.first.descriptionHabit,
      "tourPoitrine": mesure.tourPoitrine,
      "tourDos": mesure.tourDos,
      "tourHanche": mesure.tourHanche,
      "longueurManches": mesure.longueurManches,
      "largeursEpaules": mesure.largeursEpaules,
      "longueurJambes": mesure.longueurJambes,
      "hauteurEntreJambes": mesure.hauteurEntrejambe,
      "longueurOurlet": mesure.longueurOurlet,
      "tourBras": mesure.tourBras,
      "tourPoignet": mesure.tourPoignet,
      "HauteurTotale": mesure.hauteurTotale,
      "tourCou": mesure.tourCou,
    });

    await _db
        .collection("tailleurs")
        .doc(tailleurToken)
        .collection("Mesures")
        .doc(ref.id)
        .collection("MesClients")
        .add({
      "nom": mesure.client.first.nom,
      "gender": mesure.client.first.genre,
      "prenom": mesure.client.first.prenom,
      "telephone": mesure.client.first.telephone,
      "trancheAge": mesure.client.first.trancheAge
    });

    await _db
        .collection("tailleurs")
        .doc(tailleurToken)
        .collection("Mesures")
        .doc(ref.id)
        .collection("Habit")
        .add({
      "image": mesure.habit.first.image,
      "description": mesure.habit.first.descriptionHabit
    });

    final ref2 = await _db
        .collection("tailleurs")
        .doc(tailleurToken)
        .collection("Mesures")
        .doc(ref.id)
        .collection("Model")
        .add({
      "description": mesure.models.first.description,
      "prix": mesure.models.first.prix,
      "nom": mesure.models.first.nom
    });
    for (final i in mesure.models.first.images!) {
      await _db
          .collection("tailleurs")
          .doc(tailleurToken)
          .collection("Mesures")
          .doc(ref.id)
          .collection("Model")
          .doc(ref2.id)
          .collection("Image")
          .add({"image": i.image});
    }

    mesures.add(mesure);
    tailleurs.first.mesure = mesures;
  }

  postPublication(Poste poste, String token) async {
    final ref = await _db
        .collection("tailleurs")
        .doc(token)
        .collection("Poste")
        .add({"description": poste.description, "date": poste.date});

    for (final image in poste.images!) {
      await _db
          .collection("tailleurs")
          .doc(token)
          .collection("Poste")
          .doc(ref.id)
          .collection("Images")
          .add({"image": image.image});
    }
    print("publication done");
    Postes.add(poste);
    tailleurs.first.postes = Postes;
  }

  postVideoPublication(PosteVideo poste, String token) async {
    final ref = await _db
        .collection("tailleurs")
        .doc(token)
        .collection("PosteVideos")
        .add({"description": poste.description, "date": poste.date});

    for (final image in poste.videos!) {
      await _db
          .collection("tailleurs")
          .doc(token)
          .collection("PosteVideos")
          .doc(ref.id)
          .collection("Videos")
          .add({"video": image.video});
    }
    posteVideos.add(poste);
    tailleurs.first.posteVideos = posteVideos;
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
    print("end publication");
    // tailleurs.first.postes = posteList;
    return posteList;
  }

  Future<List<PosteVideo>> getVideoPublication(String token) async {
    final postes = await _db
        .collection("tailleurs")
        .doc(token)
        .collection("PosteVideos")
        .get();
    final posteList =
        await postes.docs.map((e) => PosteVideo.fromSnapshot(e)).toList();
    for (final p in posteList) {
      final imgs = await _db
          .collection("tailleurs")
          .doc(token)
          .collection("PosteVideos")
          .doc(p.token)
          .collection("Videos")
          .get();
      final img = await imgs.docs.map((e) => Video.fromSnapshot(e)).toList();
      p.videos = img;
    }
    posteVideos = posteList;
    // tailleurs.first.postes = posteList;
    return posteList;
  }

  Future<List<Mesures>> getMesures(String tailleursToken) async {
    final mess = await _db
        .collection("tailleurs")
        .doc(tailleursToken)
        .collection("Mesures")
        .get();
    final mesureList =
        await mess.docs.map((e) => Mesures.fromSnapshot(e)).toList();
    for (final i in mesureList) {
      final mesclientss = await _db
          .collection("tailleurs")
          .doc(tailleursToken)
          .collection("Mesures")
          .doc(i.token)
          .collection("MesClients")
          .get();
      final mesclientList = await mesclientss.docs
          .map((e) => MesClients.fromSnapshot(e))
          .toList();
      final hab = await _db
          .collection("tailleurs")
          .doc(tailleursToken)
          .collection("Mesures")
          .doc(i.token)
          .collection("Habit")
          .get();
      final habitList =
          await hab.docs.map((e) => Habit.fromSnapshot(e)).toList();
      final mode = await _db
          .collection("tailleurs")
          .doc(tailleursToken)
          .collection("Mesures")
          .doc(i.token)
          .collection("Model")
          .get();
      final modeList =
          await mode.docs.map((e) => Models.fromSnapshot(e)).toList();
      for (final k in modeList) {
        final img = await _db
            .collection("tailleurs")
            .doc(tailleursToken)
            .collection("Mesures")
            .doc(i.token)
            .collection("Model")
            .doc(k.token)
            .collection("Image")
            .get();
        final imgList =
            await img.docs.map((e) => Images.fromSnapshot(e)).toList();
        k.images = imgList;
      }
      i.client = mesclientList;
      i.habit = habitList;
      i.models = modeList;
    }
    mesures = mesureList;
    return mesureList;
  }

  Future<List<Paiement>> getPaiement(String tailleursToken) async {
    final paie = await _db
        .collection("tailleurs")
        .doc(tailleursToken)
        .collection("Paiement")
        .get();
    final paiementList =
        await paie.docs.map((e) => Paiement.fromSnapshot(e)).toList();
    for (final i in paiementList) {
      final mesclientss = await _db
          .collection("tailleurs")
          .doc(tailleursToken)
          .collection("Paiement")
          .doc(i.token)
          .collection("MesClients")
          .get();
      final mesclientList = await mesclientss.docs
          .map((e) => MesClients.fromSnapshot(e))
          .toList();
      final habi = await _db
          .collection("tailleurs")
          .doc(tailleursToken)
          .collection("Paiement")
          .doc(i.token)
          .collection("Habit")
          .get();
      final habitList =
          await habi.docs.map((e) => Habit.fromSnapshot(e)).toList();
      i.client = mesclientList;
      i.habit = habitList;
    }
    paiement = paiementList;
    return paiementList;
  }

  PaiementManage(Paiement p, String t) async {
    final ref =
        await _db.collection("tailleurs").doc(t).collection("Paiement").add({
      "montantPaye": p.montantPaye,
      "datePaiement": p.datePaiement,
    });
    await _db
        .collection("tailleurs")
        .doc(t)
        .collection("Paiement")
        .doc(ref.id)
        .collection("MesClients")
        .add({
      "nom": p.client.first.nom,
      "gender": p.client.first.genre,
      "prenom": p.client.first.prenom,
      "telephone": p.client.first.telephone,
      "trancheAge": p.client.first.trancheAge
    });

    await _db
        .collection("tailleurs")
        .doc(t)
        .collection("Paiement")
        .doc(ref.id)
        .collection("Habit")
        .add({
      "image": p.habit.first.image,
      "description": p.habit.first.descriptionHabit
    });
    await _db.collection("tailleurs").doc(t).collection("Paiement").doc();

    paiement.add(p);
    tailleurs.first.paiement = paiement;
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

  creerRDV(RDV desc, String userToken) async {
    await _db.collection("tailleurs").doc(userToken).collection("RDV").add({
      "motif": desc.motif,
      "client_name": desc.client,
      "dateRDV": desc.date,
      "client_image": desc.client_image ?? ""
    });

    rdv.add(desc);
    tailleurs.first.rdv = rdv;
  }

  Future<List<RDV>> getRDV(String usertoken) async {
    final rd = await _db
        .collection("tailleurs")
        .doc(usertoken)
        .collection("RDV")
        .get();
    final lisRDV = await rd.docs.map((e) => RDV.fromSnapshot(e)).toList();
    rdv = lisRDV;
    return lisRDV;
  }

  manageStock(Stock stoc, String userToken) async {
    await _db.collection("tailleurs").doc(userToken).collection("Stock").add({
      "produitName": stoc.produitName,
      "supplier": stoc.suplier,
      "produitPrix": stoc.produitPrix,
      "qteStock": stoc.qteStock,
    });
    stock.add(stoc);
    tailleurs.first.stock = stock;
  }

  updateStock(Stock stoc, String userToken, String stockToken) async {
    await _db
        .collection("tailleurs")
        .doc(userToken)
        .collection("Stock")
        .doc(stockToken)
        .update({
      "produitName": stoc.produitName,
      "supplier": stoc.suplier,
      "produitPrix": stoc.produitPrix,
      "qteStock": stoc.qteStock,
    });
    getStock(userToken);
    tailleurs.first.stock = stock;
  }

  Future<List<Stock>> getStock(String usertoken) async {
    final st = await _db
        .collection("tailleurs")
        .doc(usertoken)
        .collection("Stock")
        .get();
    final listStock = await st.docs.map((e) => Stock.fromSnapshot(e)).toList();
    stock = listStock;
    return listStock;
  }

  creerMesClients(MesClients mesClientss, String userToken) async {
    await _db
        .collection("tailleurs")
        .doc(userToken)
        .collection("MesClients")
        .add({
      "nom": mesClientss.nom,
      "prenom": mesClientss.prenom,
      "telephone": mesClientss.telephone,
      "email": mesClientss.email,
      "genre": mesClientss.genre,
      "trancheAge": mesClientss.trancheAge
    });
    mesClients.add(mesClientss);
    tailleurs.first.mesClients!.add(mesClientss);
  }

  Future<List<MesClients>> getMesClient(String token) async {
    final mes = await _db
        .collection("tailleurs")
        .doc(token)
        .collection("MesClients")
        .get();
    final mesList = mes.docs.map((e) => MesClients.fromSnapshot(e)).toList();
    mesClients = mesList;
    //tailleurs.first.mesClients = mesList;
    return mesList;
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
    }).then((value) async {
      final atel = Atelier.fromSnapshot(await value.get());
      atelier.add(atel);
      tailleurs.first.atelier = [atel];
    });
  }

  Future<List<Atelier>> getAtelier(String userToken) async {
    final monatelier = await _db
        .collection("tailleurs")
        .doc(userToken)
        .collection("ateliers")
        .get();
    atelier = monatelier.docs.map((e) => Atelier.fromSnapshot(e)).toList();
    return atelier;
  }

  addImageToAlbums(String? image, String userToken, String modelToken) async {
    await _db
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
        .add(Images(image: image!));
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

  createTache(Taches tache, String userToken) async {
    await _db.collection("tailleurs").doc(userToken).collection("Taches").add({
      "nom": tache.nom,
    });
    taches.add(tache);
    tailleurs.first.taches = taches;
  }

  createSousTache(
      SousTaches soustache, String userToken, String tacheToken) async {
    await _db
        .collection("tailleurs")
        .doc(userToken)
        .collection("Taches")
        .doc(tacheToken)
        .collection("SousTaches")
        .add({
      "description": soustache.description,
      "valide": soustache.valide,
      'date': soustache.date,
      "Debut": soustache.debut,
      "Fin": soustache.fin
    });
    for (final i in taches) {
      if (i.token == tacheToken) {
        i.sousTaches!.add(soustache);
      }
    }
    tailleurs.first.taches = taches;
  }

  Future<List<Taches>> getTaches(String usertoken) async {
    final tc = await _db
        .collection("tailleurs")
        .doc(usertoken)
        .collection("Taches")
        .get();
    final lisTaches = await tc.docs.map((e) => Taches.fromSnapshot(e)).toList();
    for (final i in lisTaches) {
      final tcs = await _db
          .collection("tailleurs")
          .doc(usertoken)
          .collection("Taches")
          .doc(i.token)
          .collection("SousTaches")
          .get();
      final soustaches =
          tcs.docs.map((e) => SousTaches.fromSnapshot(e)).toList();
      i.sousTaches = soustaches;
    }
    taches = lisTaches;
    return lisTaches;
  }

  //function to get All client
  Future<List<ClientModel>> getClients() async {
    final data = await _db.collection("Clients").get();
    final clients = data.docs.map((e) => ClientModel.fromSnapshot(e)).toList();
    for (final i in clients) {
      //get specifics client likes list from firebase
      final likes =
          await _db.collection("Clients").doc(i.token).collection("Like").get();
      //get specifics client Commandes list from firebase
      final commandes = await _db
          .collection("Clients")
          .doc(i.token)
          .collection("Commande")
          .get();
      //get specifics client Panniers list from firebase
      final panniers = await _db
          .collection("Clients")
          .doc(i.token)
          .collection("Pannier")
          .get();

      //add likes list to client likes list
      final likesListe =
          likes.docs.map((e) => LikeModel.fromSnapshot(e)).toList();
      i.likes = likesListe;
      //add Commande list to client Commande list
      final commandeListe =
          commandes.docs.map((e) => CommandeModel.fromSnapshot(e)).toList();
      i.commandes = commandeListe;
      //add Pannier list to client pannier list
      final pannierListe =
          panniers.docs.map((e) => PanierModel.fromSnapshot(e)).toList();
      i.panniers = pannierListe;
    }
    return clients;
  }

  //function to get All client

  Future<ClientModel> getCliens(String firebaseToken) async {
    final data = await _db.collection("Clients").doc(firebaseToken).get();

    final Lclient = ClientModel.fromSnapshot(data);
    return Lclient;
  }

  //function get All Categories
  Future<List<CategorieModel>> getCategorieAndProduc() async {
    final data = await _db.collection("categoriCollection").get();
    final categories =
        data.docs.map((e) => CategorieModel.fromSnapshot(e)).toList();
    try {
      for (CategorieModel i in categories) {
        //get specifics categorie products list from firebase
        final products = await _db
            .collection("categoriCollection")
            .doc(i.firebaseToken)
            .collection("productCollection")
            .get();
        print(i.nom);
        final newproducts = await _db
            .collection("categoriCollection")
            .doc(i.firebaseToken)
            .collection("newProductCollection")
            .get();
        //add products list to client product list
        final newList = newproducts.docs
            .map((e) => NewProductModel.fromSnapshot(e))
            .toList();
        final productListe =
            products.docs.map((e) => ProduitModel.fromSnapshot(e)).toList();
        i.listProduit = productListe;
        i.listNews = newList;
      }
    } catch (e) {
      print("errorin Firebase : $e");
    }

    return categories;
  }

  createMessage(String idClient, String idCommande, MessageT m) async {
    await _db
        .collection("Clients")
        .doc(idClient)
        .collection("Commande")
        .doc(idCommande)
        .collection("Message")
        .add({
      "message": m.message,
      "isTailleur": m.isTailleur,
      "time": m.timestamp
    });
  }

  StreamController<List<MessageT>> _messagesStreamController =
      StreamController<List<MessageT>>();
  BehaviorSubject<List<MessageT>> _messagesSubject =
      BehaviorSubject<List<MessageT>>.seeded([]);

  Stream<List<MessageT>> getMessages(
      String idClient, String idCommande) async* {
    // _db
    //     .collection("Clients")
    //     .doc(idClient)
    //     .collection("Commande")
    //     .doc(idCommande)
    //     .collection("Message")
    //     .orderBy("time", descending: true)
    //     .snapshots()
    //     .listen((snapshot) {
    //   List<MessageT> messages =
    //       snapshot.docs.map((e) => MessageT.fromMap(e)).toList();
    //   _messagesStreamController.add(messages);
    // });

    _db
        .collection("Clients")
        .doc(idClient)
        .collection("Commande")
        .doc(idCommande)
        .collection("Message")
        .orderBy("time", descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((e) => MessageT.fromMap(e)).toList())
        .listen((messages) {
      _messagesSubject.add(messages);
    });

    yield* _messagesSubject.stream;

    //yield* _messagesStreamController.stream;
  }

  Stream<List<Tailleurs>> streamTailleurs() async* {
    List<Tailleurs> t = await getAllTailleurs();
    yield t;
  }

  Future<List<MessageT>> getMessage(String idClient, String idCommande) async {
    final m = await _db
        .collection("Clients")
        .doc(idClient)
        .collection("Commande")
        .doc(idCommande)
        .collection("Message")
        .orderBy("time", descending: true)
        .get();
    List<MessageT> mess = [];
    mess = m.docs.map((e) => MessageT.fromMap(e)).toList();
    print(mess);
    return mess;
  }

  // function to create commande
  createCommande(String client, CommandeModel commande) async {
    final commandeRef =
        await _db.collection("Clients").doc(client).collection("Commande").add({
      "clientToken": commande.clientToken,
      "Date": commande.dateCommande,
      "tailleurToken": commande.tailleurToken,
      "Etat": commande.etatCommande,
      "qteCommande": commande.qteCommande,
      "Adresse": commande.adresseLivraison,
      "PrixTotal": commande.prix
    });
    final newRef = commandeRef.id;
    for (final cmd in commande.produit) {
      final rf = await _db
          .collection("Clients")
          .doc(client)
          .collection("Commande")
          .doc(newRef)
          .collection("Pannier")
          .add({
        "qteProduit": cmd.qteProduit,
        "prixTotal": cmd.prixTotal,
      });
      for (final prod in commande.produit.first.produit) {
        await _db
            .collection("Clients")
            .doc(client)
            .collection("Commande")
            .doc(newRef)
            .collection("Pannier")
            .doc(rf.id)
            .collection("Produits")
            .add({
          "Nom": prod.nom,
          "Description": prod.description,
          "Prix": prod.prix,
          "Like": false,
          "Image": prod.image,
          "qteCommande": prod.qteCommande,
        });
      }
    }
  }

  Future<List<CommandeModel>> getAllCommande(String client) async {
    try {
      final data = await _db
          .collection("Clients")
          .doc(client)
          .collection("Commande")
          .get();
      final commandes =
          data.docs.map((e) => CommandeModel.fromSnapshot(e)).toList();

      for (final i in commandes) {
        // final mess = await _db
        //     .collection("Clients")
        //     .doc(client)
        //     .collection("Commande")
        //     .doc(i.firebaseToken)
        //     .collection("Message")
        //     .get();
        List<MessageT> m = await getMessage(client, i.firebaseToken);
        // Obtenir la liste spécifique des produits de la catégorie à partir de Firebase
        final products = await _db
            .collection("Clients")
            .doc(client)
            .collection("Commande")
            .doc(i.firebaseToken)
            .collection('Pannier')
            .get();
        // Ajouter la liste des produits à la liste des produits du client
        final pannierListe =
            products.docs.map((e) => PanierModel.fromSnapshot(e)).toList();
        for (final p in pannierListe) {
          final product = await _db
              .collection("Clients")
              .doc(client)
              .collection("Commande")
              .doc(i.firebaseToken)
              .collection('Pannier')
              .doc(p.token)
              .collection("productCollection")
              .get();
          // Ajouter la liste des produits à la liste des produits du client
          final produitListe = product.docs
              .map((e) => AchatProduitModel.fromSnapshot(e))
              .toList();
          p.produit = produitListe;
        }
        i.message = m;
        i.produit = pannierListe;
      }

      return commandes;
    } catch (e) {
      print(e);
      return List.empty();
    }
  }

  //function to delete Commande
  deleteCommande(ClientModel client, CommandeModel commande) async {
    await _db
        .collection("Clients")
        .doc(client.token)
        .collection("Commande")
        .doc(commande.firebaseToken)
        .delete();
  }

  //function to create pannier
  createPannier(String client, PanierModel pannier) async {
    final pannierRef = await _db
        .collection("Clients")
        .doc(client)
        .collection("Pannier")
        .add(
            {'qteProduit': pannier.qteProduit, 'prixTotal': pannier.prixTotal});
    final newRef = pannierRef.id;
    {
      await _db
          .collection("Clients")
          .doc(client)
          .collection("Pannier")
          .doc(newRef)
          .collection("ProductCollection")
          .add({
        "Nom": pannier.produit.last.nom,
        "Description": pannier.produit.last.description,
        "Prix": pannier.produit.last.prix,
        "Like": false,
        "Image": pannier.produit.last.image,
        "qteCommande": pannier.produit.last.qteCommande,
      });
    }
  }

  Future<List<PanierModel>> getAllPannier(String client) async {
    try {
      final data = await _db
          .collection("Clients")
          .doc(client)
          .collection("Pannier")
          .get();
      List<PanierModel> paniers = [];
      paniers = data.docs.map((e) => PanierModel.fromSnapshot(e)).toList();

      for (final i in paniers) {
        // Obtenir la liste spécifique des produits de la catégorie à partir de Firebase
        final products = await _db
            .collection("Clients")
            .doc(client)
            .collection("Pannier")
            .doc(i.token)
            .collection("ProductCollection")
            .get();
        // Ajouter la liste des produits à la liste des produits du client
        final productListe = products.docs
            .map((e) => AchatProduitModel.fromSnapshot(e))
            .toList();
        i.produit = productListe;
      }
      ;

      return paniers;
    } catch (e) {
      return List.empty();
    }
  }

  //function to update pannier
  updatePannier(client, AchatProduitModel pannier, pannierToken) async {
    await _db
        .collection("Client")
        .doc(client)
        .collection("Pannier")
        .doc(pannierToken)
        .collection("Produits")
        .add({
      "Nom": pannier.nom,
      "Description": pannier.description,
      "Prix": pannier.prix,
      "Image": pannier.image,
      "qteCommande": pannier.qteCommande,
      "Like": false,
    });
  }

  deleteProductPannier(client, PanierModel panier, produit) async {
    await _db
        .collection("Client")
        .doc(client)
        .collection("Pannier")
        .doc(panier.token)
        .collection("productCollection")
        .doc(produit)
        .delete();
  }

  deletePannier(client, PanierModel panier) async {
    await _db
        .collection("Client")
        .doc(client)
        .collection("Pannier")
        .doc(panier.token)
        .delete();
  }

  //function to like product
  addToLike(String client, ProduitModel like) async {
    await _db.collection("Client").doc(client).collection("Like").add({
      "Nom": like.nom,
      "Description": like.description,
      "Prix": like.prix,
      "Image": like.image,
      "Like": like.like,
      "Token": like.token
    });
  }

  //fuction to get liked product

  Future<List<LikeModel>> getLikedList(String client) async {
    final data =
        await _db.collection("Clients").doc(client).collection("Like").get();
    final likes = data.docs.map((e) => LikeModel.fromSnapshot(e)).toList();
    return likes;
  }

  //function to diselike product
  deleteLike(String client, LikeModel like) async {
    await _db
        .collection("Clients")
        .doc(client)
        .collection("Like")
        .doc(like.token)
        .delete();
  }

  // //function to get All client
  // Future<List<ClientModel>> getClients() async {
  //   final data = await _db.collection("Clients").get();
  //   final clients = data.docs.map((e) => ClientModel.fromSnapshot(e)).toList();
  //   for (final i in clients) {
  //     //get specifics client likes list from firebase
  //     final likes =
  //         await _db.collection("Clients").doc(i.token).collection("Like").get();
  //     //get specifics client Commandes list from firebase
  //     final commandes = await _db
  //         .collection("Clients")
  //         .doc(i.token)
  //         .collection("Commande")
  //         .get();
  //     //get specifics client Panniers list from firebase
  //     final panniers = await _db
  //         .collection("Clients")
  //         .doc(i.token)
  //         .collection("Pannier")
  //         .get();

  //     // final favoris = await _db
  //     //     .collection("Clients")
  //     //     .doc(i.token)
  //     //     .collection("Favoris")
  //     //     .get();
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
  //     // final favorisListe =
  //     //     favoris.docs.map((e) => FavorisModel.fromSnapshot(e)).toList();
  //     // i.favoris = favorisListe;
  //   }
  //   return clients;
  // }

  //function to get All client

  // Future<ClientModel> getClients(String firebaseToken) async {
  //   final data = await _db.collection("Clients").doc(firebaseToken).get();

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

//   // function to create commande
//   createCommande(String client, CommandeModel commande) async {
//     final commandeRef =
//         await _db.collection("Client").doc(client).collection("Commande").add({
//       "Date": commande.dateCommande,
//       "Etat": commande.etatCommande,
//       "qteCommande": commande.qteCommande,
//       "Adresse": commande.adresseLivraison,
//       "PrixTotal": commande.prix
//     });
//     final newRef = commandeRef.id;
//     for (final cmd in commande.produit) {
//       final rf = await _db
//           .collection("Clients")
//           .doc(client)
//           .collection("Commande")
//           .doc(newRef)
//           .collection("Pannier")
//           .add({
//         "qteProduit": cmd.qteProduit,
//         "prixTotal": cmd.prixTotal,
//       });
//       for (final prod in commande.produit.first.produit) {
//         await _db
//             .collection("Client")
//             .doc(client)
//             .collection("Commande")
//             .doc(newRef)
//             .collection("Pannier")
//             .doc(rf.id)
//             .collection("Produits")
//             .add({
//           "Nom": prod.nom,
//           "Description": prod.description,
//           "Prix": prod.prix,
//           "Like": false,
//           "Image": prod.image,
//           "qteCommande": prod.qteCommande,
//         });
//       }
//     }
//   }

//   Future<List<CommandeModel>> getAllCommande(String client) async {
//     try {
//       final data = await _db
//           .collection("Client")
//           .doc(client)
//           .collection("Commande")
//           .get();
//       final commandes =
//           data.docs.map((e) => CommandeModel.fromSnapshot(e)).toList();

//       for (final i in commandes) {
//         // Obtenir la liste spécifique des produits de la catégorie à partir de Firebase
//         final products = await _db
//             .collection("Clients")
//             .doc(client)
//             .collection("Commande")
//             .doc(i.firebaseToken)
//             .collection('Pannier')
//             .get();
//         // Ajouter la liste des produits à la liste des produits du client
//         final pannierListe =
//             products.docs.map((e) => PanierModel.fromSnapshot(e)).toList();
//         for (final p in pannierListe) {
//           final product = await _db
//               .collection("Client")
//               .doc(client)
//               .collection("Commande")
//               .doc(i.firebaseToken)
//               .collection('Pannier')
//               .doc(p.token)
//               .collection(productCollection)
//               .get();
//           // Ajouter la liste des produits à la liste des produits du client
//           final produitListe = product.docs
//               .map((e) => AchatProduitModel.fromSnapshot(e))
//               .toList();
//           p.produit = produitListe;
//         }
//         i.produit = pannierListe;
//       }

//       return commandes;
//     } catch (e) {
//       print(e);
//       return List.empty();
//     }
//   }

//   //function to delete Commande
//   deleteCommande(ClientModel client, CommandeModel commande) async {
//     await _db
//         .collection("Clients")
//         .doc(client.token)
//         .collection("Commande")
//         .doc(commande.token)
//         .delete();
//   }

//   //function to create pannier
//   createPannier(String client, PanierModel pannier) async {
//     final pannierRef = await _db
//         .collection("Client")
//         .doc(client)
//         .collection("Pannier")
//         .add(
//             {
//              'qteProduit': pannier.qteProduit, 'prixTotal': pannier.prixTotal
//             });
//     final newRef = pannierRef.id;
//     {
//       await _db
//           .collection("Client")
//           .doc(client)
//           .collection("Pannier")
//           .doc(newRef)
//           .collection("ProductCollection")
//           .add({
//         "Nom": pannier.produit.last.nom,
//         "Description": pannier.produit.last.description,
//         "Prix": pannier.produit.last.prix,
//         "Like": false,
//         "Image": pannier.produit.last.image,
//         "qteCommande": pannier.produit.last.qteCommande,
//       });
//     }
//   }

//   Future<List<PanierModel>> getAllPannier(String client) async {
//     try {
//       final data = await _db
//           .collection("Client")
//           .doc(client)
//           .collection("Pannier")
//           .get();
//       final paniers =
//           data.docs.map((e) => PanierModel.fromSnapshot(e)).toList();

//       for (final i in paniers) {
//         // Obtenir la liste spécifique des produits de la catégorie à partir de Firebase
//         final products = await _db
//             .collection("Client")
//             .doc(client)
//             .collection("Pannier")
//             .doc(i.firebaseToken)
//             .collection(productCollection)
//             .get();
//         // Ajouter la liste des produits à la liste des produits du client
//         final productListe = products.docs
//             .map((e) => AchatProduitModel.fromSnapshot(e))
//             .toList();
//         i.produit = productListe;
//       }
//       ;

//       return paniers;
//     } catch (e) {
//       return List.empty();
//     }
//   }

//   //function to update pannier
//   updatePannier(client, AchatProduitModel pannier, pannierToken) async {
//     await _db
//         .collection("Client")
//         .doc(client)
//         .collection("Pannier")
//         .doc(pannierToken)
//         .collection("Produits")
//         .add({
//       "Nom": pannier.nom,
//       "Description": pannier.description,
//       "Prix": pannier.prix,
//       "Image": pannier.image,
//       "qteCommande": pannier.qteCommande,
//       "Like": false,
//     });
//   }

//   deleteProductPannier(client, PanierModel panier, produit) async {
//     await _db
//         .collection("Client")
//         .doc(client)
//         .collection("Pannier")
//         .doc(panier.token)
//         .collection(productCollection)
//         .doc(produit)
//         .delete();
//   }

//   deletePannier(client, PanierModel panier) async {
//     await _db
//         .collection("Client")
//         .doc(client)
//         .collection("Pannier")
//         .doc(panier.token)
//         .delete();
//   }

//   //function to like product
//   addToLike(String client, ProduitModel like) async {
//     await _db.collection("Client").doc(client).collection("Like").add({
//       "Nom": like.nom,
//       "Description": like.description,
//       "Prix": like.prix,
//       "Image": like.image,
//       "Like": like.like,
//       "Token": like.token
//     });
//   }

//   //fuction to get liked product

//   Future<List<LikeModel>> getLikedList(String client) async {
//     final data =
//         await _db.collection("Clients").doc(client).collection("Like").get();
//     final likes = data.docs.map((e) => LikeModel.fromSnapshot(e)).toList();
//     return likes;
//   }

//   //function to diselike product
//   deleteLike(String client, LikeModel like) async {
//     await _db
//         .collection("Clients")
//         .doc(client)
//         .collection("Like")
//         .doc(like.token)
//         .delete();
//   }
}
