import 'dart:io';

import 'package:fashion2/firestore.dart';
import 'package:fashion2/models/image_model.dart';
import 'package:fashion2/models/poste.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multiple_images_picker/multiple_images_picker.dart';
import 'package:video_player/video_player.dart';

class NewPostPage extends StatefulWidget {
  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  List<Asset> images = <Asset>[];
  FirebaseManagement _management = Get.put(FirebaseManagement());
  final _description = TextEditingController();
  FirebaseStorage _storage = FirebaseStorage.instance;
  List<Images> listImages = [];
  // Future<void> loadAssets() async {
  //   List<Asset> resultList = <Asset>[];
  //   try {
  //     var MultiImagePicker;
  //     resultList = await MultiImagePicker.pickImages(
  //       maxImages: 10,
  //       enableCamera: true,
  //       selectedAssets: images,
  //       cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
  //       materialOptions: MaterialOptions(
  //         actionBarColor: "#abcdef",
  //         actionBarTitle: "Sélectionner des médias",
  //         allViewTitle: "Tous les médias",
  //         useDetailsView: false,
  //         selectCircleStrokeColor: "#000000",
  //       ),
  //     );
  //   } on Exception catch (e) {
  //     // Gérer les exceptions liées à la sélection d'images ici
  //     print(e);
  //   }

  //   if (!mounted) return;

  //   setState(() {
  //     images = resultList;
  //   });
  // }

  void _importImage() async {
    final pickedFile = await ImagePicker().pickMultiImage();
    for (final f in pickedFile) {
      if (f != []) {
        File file = File(f.path);
        listImages.add(Images(image: await uploadImage(file, f.name) ?? ""));
        //setState(() {});
      }
    }

    //_management.postPublication(Poste(description: description), _management.tailleurs.first.token!);
  }

  Future<String?> uploadImage(File imageFile, String fileName) async {
    try {
      Reference ref = _storage.ref().child('images/$fileName');
      UploadTask uploadTask = ref.putFile(imageFile);

      TaskSnapshot taskSnapshot = await uploadTask;

      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      return imageUrl;
    } catch (e) {
      print('Erreur lors du chargement de l\'image : $e');
      return null;
    }
  }

  // Future<void> getVideo() async {
  //   final pickedFile = await ImagePicker().getVideo(source: ImageSource.gallery);
  //
  //   if (pickedFile != null) {
  //     setState(() {
  //       video = pickedFile;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var getVideo;
    return Scaffold(
      appBar: AppBar(
        title: Text('Nouveau Post'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Zone de saisie pour le texte du post
            TextFormField(
              controller: _description,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Que voulez-vous partager ?',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            // Bouton pour télécharger des images
            ElevatedButton.icon(
              onPressed: _importImage,
              icon: Icon(Icons.photo_camera),
              label: Text('Télécharger des photos'),
            ),
            SizedBox(height: 10),
            // Affichage des images sélectionnées
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                children: List.generate(images.length, (index) {
                  return AssetThumb(
                    asset: images[index],
                    width: 300,
                    height: 300,
                  );
                }),
              ),
            ),
            SizedBox(height: 20),
            // Bouton pour télécharger une vidéo
            ElevatedButton.icon(
              onPressed: getVideo,
              icon: Icon(Icons.video_call),
              label: Text('Télécharger une vidéo'),
            ),
            // SizedBox(height: 10),
            // // Affichage de la vidéo sélectionnée
            // if (video != null)
            //   Container(
            //     height: 200,
            //     width: 200,
            //     child: VideoPlayer(video! as VideoPlayerController),
            //   ),
            SizedBox(height: 20),
            // Bouton pour publier le post
            ElevatedButton(
              onPressed: () {
                _management.postPublication(
                    Poste(description: _description.text, images: listImages),
                    _management.tailleurs.first.token!);
                Navigator.pop(context);
              },
              child: Text('Publier'),
            ),
          ],
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter_share/flutter_share.dart';
// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server.dart';
//
// import '../../screen/home_screen.dart';
//
//
// class MarketingAndPromotionPage extends StatelessWidget {
//   void shareOnSocialMedia() async {
//     await FlutterShare.share(
//       title: 'Partagez sur les médias sociaux',
//       text: 'Découvrez notre atelier de couture !',
//       linkUrl: 'https://votre-site-web.com',
//     );
//   }
//
//   void sendMarketingEmail() async {
//     final smtpServer = gmail('votre-email@gmail.com', 'votre-mot-de-passe');
//
//     final message = Message()
//       ..from = Address('votre-email@gmail.com', 'Votre Nom')
//       ..recipients.add('destinataire@example.com')
//       ..subject = 'Sujet de l\'e-mail'
//       ..text = 'Contenu de l\'e-mail';
//
//     try {
//       final sendReport = await send(message, smtpServer);
//       if (sendReport != null) {
//         print('Message envoyé avec succès');
//       } else {
//         print('Erreur d\'envoi');
//       }
//     } catch (e) {
//       print('Erreur d\'envoi : $e');
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Marketing et Promotion"),
//         backgroundColor: const Color(0xFF09126C),
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back_ios_new,
//             color: Colors.grey,
//           ),
//           onPressed: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => HomeScreen(), // Remplacez PageDefault par votre widget de page par défaut
//               ),
//             );
//           },
//         ),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: shareOnSocialMedia,
//               child: Text("Partager sur les médias sociaux"),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: sendMarketingEmail,
//               child: Text("Envoyer un e-mail marketing"),
//             ),
//             // Vous pouvez ajouter ici d'autres fonctionnalités pour la gestion de site web et de boutique en ligne.
//           ],
//         ),
//       ),
//     );
//   }
// }
