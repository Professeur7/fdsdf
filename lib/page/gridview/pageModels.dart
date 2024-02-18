import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:fashion2/firestore.dart';
import 'package:fashion2/models/albums.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:progress_dialog_fork/progress_dialog_fork.dart';

import 'package:uuid/uuid.dart';

import '../../screen/home_screen.dart';

class PageModels extends StatefulWidget {
  @override
  _PageModelsState createState() => _PageModelsState();
}

class _PageModelsState extends State<PageModels> {
  List<GalleryButton> galleryButtons = [];
  final FirebaseStorage _storage = FirebaseStorage.instance;

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
        children: c.tailleurs.first.albums!.map((button) {
          return _buildGalleryButton(
              GalleryButton(title: button.nom, id: button.token), button.token);
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF09126C),
        onPressed: () {
          _addGalleryButton();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildGalleryButton(GalleryButton button, token) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GalleryPage(
                      galleryButton: button,
                      galerieToken: token,
                    )),
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

final FirebaseManagement c = Get.put(FirebaseManagement());

class GalleryButton {
  String title;
  String? id;
  GalleryButton({required this.title, this.id});

  // CollectionReference get photosCollection {
  //   return FirebaseFirestore.instance
  //       .collection('galleryButtons')
  //       .doc(id)
  //       .collection('photos');
  // }

  Future<void> save() async {
    c.creerAlbums(Albums(nom: title), c.tailleurs.first.token!);
  }

  Future<void> addPhoto(String imageUrl, String albumsToken) async {
    c.addImageToAlbums(imageUrl, c.tailleurs.first.token!, albumsToken);
    //await photosCollection.add({'url': imageUrl});
  }

  Future<List<String>> getPhotos(String albumsToken) async {
    //final querySnapshot = await photosCollection.get();
    List<String> image = [];
    if (c.tailleurs.first.albums!.isNotEmpty) {
      for (final cs in c.tailleurs.first.albums!) {
        if (cs.token == albumsToken) {
          if (cs.images != null) {
            cs.images!.isNotEmpty
                ? cs.images!.forEach((element) {
                    image.add(element.image);
                  })
                : [];
          }
        }
      }
    }
    return image;
  }

  // Future<void> deletePhoto(String photoId) async {
  //   await photosCollection.doc(photoId).delete();
  // }
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

  // void _takePicture(XFile image) async {
  //   File imageFile = File(image.path);
  //   final uuid = Uuid();
  //   final uniqueId = uuid.v4();
  //   final storageRef = _storage.ref().child('images/$uniqueId.jpg');

  //   try {
  //     await storageRef.putFile(imageFile);
  //     final imageUrl = await storageRef.getDownloadURL();
  //     //_management.addImageToAlbums(Images(image: imageUrl), _management.tailleurs.first.token!, modelToken)
  //     widget.onPictureTaken(imageUrl);
  //   } catch (e) {
  //     print('Erreur lors du téléchargement de l\'image : $e');
  //   }
  // }

  void _takePicture(XFile image) async {
    File imageFile = File(image.path);
    final uuid = Uuid();
    final uniqueId = uuid.v4();
    final storageRef = _storage.ref().child('images/$uniqueId.jpg');

    try {
      await storageRef.putFile(imageFile);

      // Fetch the download URL after successful upload
      final imageUrl = await storageRef.getDownloadURL();

      // Pass the download URL to the callback function
      widget.onPictureTaken(imageUrl);
    } catch (e) {
      print('Erreur lors du téléchargement de l\'image : $e');
    }
  }
//   void _onImageCaptured(CameraImage cameraImage) async {
//   try {
//     // Handle the CameraImage object accordingly, e.g., converting to a File
//     // You may need to use image processing libraries or convert to a format that suits your needs
//     // For example, you can use the image package to process the CameraImage.

//     // Example: Convert CameraImage to File
//     File imageFile = await convertCameraImageToFile(cameraImage);

//     // Now, you can perform operations on the imageFile or upload it to Firebase Storage.
//     // Ensure to handle exceptions appropriately during image processing or uploading.

//   } catch (e) {
//     print('Error processing/capturing image: $e');
//   }
// }

// Future<File> convertCameraImageToFile(CameraImage cameraImage) async {
//   try {
//     final Completer<File> completer = Completer<File>();

//     // Convert the CameraImage to a format suitable for Flutter's Image widget
//     final Image image = Image.memory(Uint8List.fromList(cameraImage.planes[0].bytes),
//         width: cameraImage.width.toDouble(), height: cameraImage.height.toDouble());

//     // Create a ByteData buffer to store the image data
//     final ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);

//     if (byteData != null) {
//       // Extract the bytes from the ByteData buffer
//       final Uint8List pngBytes = byteData.buffer.asUint8List();

//       // Save the bytes to a File
//       final File imageFile = File('path_to_save/image.png');
//       await imageFile.writeAsBytes(pngBytes);

//       completer.complete(imageFile);
//     } else {
//       completer.completeError('Error converting CameraImage to ByteData');
//     }

//     return completer.future;
//   } catch (e) {
//     print('Error converting CameraImage to File: $e');
//     rethrow; // Re-throw the exception for better error handling
//   }
// }

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
  final GalleryButton? galleryButton;
  String galerieToken;
  GalleryPage({this.galleryButton, required this.galerieToken});

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  late CameraController _controller;
  List<String> galleryPhotos = [];
  FirebaseStorage storage = FirebaseStorage.instance;
  late ProgressDialog pr;

  @override
  void initState() {
    super.initState();
    pr = ProgressDialog(context);
    pr.style(
      message: 'Chargement...',
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      messageTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
      ),
    );
    _initializeCamera();
    _loadGalleryPhotos(widget.galerieToken);
  }

  // @override
  // void initState() {
  //   super.initState();

  // }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      _controller = CameraController(cameras[0], ResolutionPreset.medium);
      await _controller.initialize();
    }
  }

  Future<void> _loadGalleryPhotos(String albumsToken) async {
    final photos = await widget.galleryButton!.getPhotos(albumsToken);
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
    try {
      pr.show(); // Affiche le ProgressDialog pendant le chargement

      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        File file = File(pickedFile.path);
        String? imageUrl = await uploadImage(file, pickedFile.name);

        // Masque le ProgressDialog après l'importation de l'image
        pr.hide();

        c.addImageToAlbums(
            imageUrl, c.tailleurs.first.token!, widget.galerieToken);
      } else {
        // Masque le ProgressDialog en cas d'erreur ou d'annulation
        pr.hide();
      }
    } catch (e) {
      print('Erreur lors de l\'importation de l\'image : $e');
      // Masque le ProgressDialog en cas d'erreur
      pr.hide();
    }
  }

  Future<String?> uploadImage(File imageFile, String fileName) async {
    try {
      Reference ref = storage.ref().child('images/$fileName');
      UploadTask uploadTask = ref.putFile(imageFile);

      TaskSnapshot taskSnapshot = await uploadTask;

      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      return imageUrl;
    } catch (e) {
      print('Erreur lors du chargement de l\'image : $e');
      return null;
    }
  }

  void _viewImage(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _buildImageGallery(imageUrl),
      ),
    );
  }

  Widget _buildImageGallery(String imageUrl) {
    return Scaffold(
      body: PhotoViewGallery.builder(
        itemCount: 1,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(imageUrl),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
        scrollPhysics: BouncingScrollPhysics(),
        backgroundDecoration: BoxDecoration(
          color: Colors.black,
        ),
        pageController: PageController(),
      ),
    );
  }

  void _deleteImage(int index) {
    setState(() {
      galleryPhotos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    ProgressDialog pr;
    _loadGalleryPhotos(widget.galerieToken);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.galleryButton!.title),
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
        backgroundColor: const Color(0xFF09126C),
        onPressed: () {
          _importImage();
        },
        child: Icon(Icons.file_upload),
      ),
    );
  }
}
