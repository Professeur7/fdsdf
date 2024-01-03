import 'dart:io';

import 'package:fashion2/firestore.dart';
import 'package:fashion2/models/image_model.dart';
import 'package:fashion2/models/poste.dart';
import 'package:fashion2/models/postevideo.dart';
import 'package:fashion2/models/video_model.dart';
import 'package:fashion2/page/client/pagePublication.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class NewPostPage extends StatefulWidget {
  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  FirebaseManagement _management = Get.put(FirebaseManagement());
  final _description = TextEditingController();
  FirebaseStorage _storage = FirebaseStorage.instance;
  List<Images> listImages = [];
  List<Video> listVideos = [];

  void _importImage() async {
    final pickedFile = await ImagePicker().pickMultiImage();
    for (final f in pickedFile) {
      if (f != []) {
        File file = File(f.path);
        listImages.add(Images(image: await uploadImage(file, f.name) ?? ""));
        //setState(() {});
      }
    }
  }

  void _importVideo() async {
    final pickedFile = await ImagePicker().pickMultipleMedia();
    for (final f in pickedFile) {
      if (f != []) {
        File file = File(f.path);
        listVideos.add(Video(video: await uploadVideo(file, f.name) ?? ""));
      }
    }
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

  Future<String?> uploadVideo(File imageFile, String fileName) async {
    try {
      Reference ref = _storage.ref().child('videos/$fileName');
      UploadTask uploadTask = ref.putFile(imageFile);

      TaskSnapshot taskSnapshot = await uploadTask;

      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      return imageUrl;
    } catch (e) {
      print('Erreur lors du chargement de l\'image : $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    //var getVideo;
    return Scaffold(
      appBar: AppBar(
        title: Text('Nouveau Post'),
        actions: [
          IconButton(
            icon: Icon(Icons.article_outlined),
            onPressed: () {
              // Implémentez ici la logique pour voir les publications
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Publications(),
                ),
              );
            },
          ),
        ],
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
            SizedBox(height: 20),
            // Bouton pour télécharger une vidéo
            ElevatedButton.icon(
              onPressed: _importVideo,
              icon: Icon(Icons.video_call),
              label: Text('Télécharger une vidéo'),
            ),
            SizedBox(height: 20),
            // Bouton pour publier le post
            ElevatedButton(
              onPressed: () {
                if (listImages.isNotEmpty) {
                  _management.postPublication(
                      Poste(
                          date: DateTime.now(),
                          description: _description.text,
                          images: listImages),
                      _management.tailleurs.first.token!);
                } else if (listVideos.isNotEmpty) {
                  _management.postVideoPublication(
                      PosteVideo(
                          date: DateTime.now(),
                          description: _description.text,
                          videos: listVideos),
                      _management.tailleurs.first.token!);
                }
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
