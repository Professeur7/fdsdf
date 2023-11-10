import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion2/firestore.dart';
import 'package:fashion2/models/image_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:uuid/uuid.dart';

import '../../screen/home_screen.dart';

class PageModels extends StatefulWidget {
  @override
  _PageModelsState createState() => _PageModelsState();
}

class _PageModelsState extends State<PageModels> {
  List<GalleryButton> galleryButtons = [];
  final FirebaseStorage _storage = FirebaseStorage.instance;
  //FirebaseManagement _management = FirebaseManagement();
  @override
  void initState() {
    super.initState();
    // Chargez les boutons de galerie existants depuis Firebase Storage lors de l'initialisation.
    _loadGalleryButtons();
  }

  Future<void> _loadGalleryButtons() async {
    // Ici, vous pouvez récupérer les boutons de galerie depuis Firebase Storage.
    // Par exemple, vous pouvez les stocker dans un dossier spécifique.
    // Mettez à jour la liste galleryButtons avec les boutons récupérés.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF09126C),
        title: Text('Vos modèles'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: galleryButtons.map((button) {
          return _buildGalleryButton(button);
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addGalleryButton();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildGalleryButton(GalleryButton button) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GalleryPage(button)),
          );
        },
        child: Center(
          child: Text(button.title),
        ),
      ),
    );
  }

  void _addGalleryButton() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String galleryTitle = "";

        return AlertDialog(
          title: Text('Ajouter une galerie'),
          content: TextField(
            onChanged: (value) {
              galleryTitle = value;
            },
            decoration: InputDecoration(labelText: 'Titre de la galerie'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Ajouter'),
              onPressed: () {
                _createGalleryButton(galleryTitle);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _createGalleryButton(String title) async {
    // Créez un nouvel bouton de galerie et ajoutez-le à Firebase Storage.
    GalleryButton galleryButton = GalleryButton(title: title);
    await galleryButton.save();
    setState(() {
      galleryButtons.add(galleryButton);
    });
  }
}

class GalleryButton {
  final String title;
  final String id;
  GalleryButton({required this.title, String? id}) : id = id ?? Uuid().v4();

  CollectionReference get photosCollection {
    return FirebaseFirestore.instance
        .collection('galleryButtons')
        .doc(id)
        .collection('photos');
  }

  Future<void> save() async {
    final data = {'title': title};
    await FirebaseFirestore.instance
        .collection('galleryButtons')
        .doc(id)
        .set(data);
  }

  Future<void> addPhoto(String imageUrl) async {
    await photosCollection.add({'url': imageUrl});
  }

  Future<List<String>> getPhotos() async {
    final querySnapshot = await photosCollection.get();
    return querySnapshot.docs.map((doc) => doc['url'] as String).toList();
  }

  Future<void> deletePhoto(String photoId) async {
    await photosCollection.doc(photoId).delete();
  }
}

class CameraPreviewPage extends StatefulWidget {
  final CameraController controller;
  final Function(String) onPictureTaken;

  CameraPreviewPage({required this.controller, required this.onPictureTaken});

  @override
  _CameraPreviewPageState createState() => _CameraPreviewPageState();
}

class _CameraPreviewPageState extends State<CameraPreviewPage> {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    widget.controller.startImageStream((image) {
      widget.controller.stopImageStream();
      _takePicture(image as XFile);
    });
  }

  //FirebaseManagement _management = FirebaseManagement();

  void _takePicture(XFile image) async {
    File imageFile = File(image.path);
    final uuid = Uuid();
    final uniqueId = uuid.v4();
    final storageRef = _storage.ref().child('images/$uniqueId.jpg');

    try {
      await storageRef.putFile(imageFile);
      final imageUrl = await storageRef.getDownloadURL();
      //_management.addImageToAlbums(Images(image: imageUrl), _management.tailleurs.first.token!, modelToken)
      widget.onPictureTaken(imageUrl);
    } catch (e) {
      print('Erreur lors du téléchargement de l\'image : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Caméra'),
      ),
      body: Center(
        child: CameraPreview(widget.controller),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.controller.takePicture();
        },
        child: Icon(Icons.camera_alt_outlined),
      ),
    );
  }
}

class GalleryPage extends StatefulWidget {
  final GalleryButton galleryButton;

  GalleryPage(this.galleryButton);

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  late CameraController _controller;
  List<String> galleryPhotos = [];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadGalleryPhotos();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _controller = CameraController(cameras[0], ResolutionPreset.medium);
      await _controller.initialize();
    }
  }

  Future<void> _loadGalleryPhotos() async {
    final photos = await widget.galleryButton.getPhotos();
    setState(() {
      galleryPhotos = photos;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _takePicture(String imageUrl) {
    setState(() {
      galleryPhotos.add(imageUrl);
    });
  }

  void _importImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        galleryPhotos.add(pickedFile.path);
      });
    }
  }

  void _viewImage(String imageUrl) {
    // Ouvrez une page pour afficher l'image en plein écran ou avec des fonctionnalités d'édition.
    // Vous pouvez utiliser des packages tels que photo_view ou autres pour afficher l'image en plein écran.
  }

  void _deleteImage(int index) {
    setState(() {
      galleryPhotos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.galleryButton.title),
        backgroundColor: const Color(0xFF09126C),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    HomeScreen(), // Remplacez PageDefault par votre widget de page par défaut
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.camera_alt_outlined),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CameraPreviewPage(
                  controller: _controller,
                  onPictureTaken: _takePicture,
                );
              }));
            },
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Définissez le nombre de photos par ligne ici
          childAspectRatio: 1.0,
          mainAxisSpacing: 4.0, // Espacement vertical entre les photos
          crossAxisSpacing: 4.0, // Espacement horizontal entre les photos
        ),
        itemCount: galleryPhotos.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _viewImage(galleryPhotos[index]);
            },
            onLongPress: () {
              _deleteImage(index);
            },
            child: Image.network(
              galleryPhotos[index],
              fit: BoxFit.cover,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _importImage();
        },
        child: Icon(Icons.file_upload),
      ),
    );
  }
}
