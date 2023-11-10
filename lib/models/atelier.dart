import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion2/models/image_model.dart';

class Atelier {
  String? token;
  String nom;
  String lieu;
  String? slogan;
  Images? logo;
  var imageUrl;

  Atelier({
    required this.nom,
    required this.lieu,
    this.slogan,
    this.logo,
    this.token,
    this.imageUrl,
  });

  factory Atelier.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> data) {
    final file = data.data();
    final imageLogo = file!["logo"];

    Images? logo; // Déclarez logo comme une variable Images nullable

    if (imageLogo != null) {
      // Si imageLogo n'est pas null, créez une instance d'Images à partir des données
      logo = Images.fromSnapshot(imageLogo);
    } else {
      logo = null; // Si imageLogo est null, affectez null à logo
    }

    return Atelier(
      token: data.id,
      nom: file["nom"],
      lieu: file["lieu"],
      slogan: file["slogan"],
      imageUrl: file["image"],
      logo: logo, // Utilisez la variable logo que vous avez déclarée ci-dessus
    );
  }
}
