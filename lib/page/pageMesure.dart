import 'package:fashion2/models/habit.dart';
import 'package:fashion2/models/image_model.dart';
import 'package:fashion2/models/mesClients.dart';
import 'package:fashion2/models/mesure.dart';
import 'package:fashion2/models/models.dart';
import 'package:fashion2/page/client.dart';
import 'package:fashion2/page/gridview/pageClient.dart';
import 'package:fashion2/page/mesureEnregistrer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../firestore.dart';

class MesuresPage extends StatefulWidget {
  Mesures? mesure;
  MesuresPage({this.mesure});
  @override
  _MesuresPageState createState() => _MesuresPageState();
}

class _MesuresPageState extends State<MesuresPage> {
  File? selectedImage1;
  File? selectedImage2;

  TextEditingController descriptionController1 = TextEditingController();
  TextEditingController descriptionController2 = TextEditingController();
  TextEditingController valeurController = TextEditingController();
  TextEditingController clientNameController = TextEditingController();
  TextEditingController prixController = TextEditingController();
  TextEditingController avanceController = TextEditingController();
  TextEditingController resteController = TextEditingController();
  FirebaseManagement _management = Get.put(FirebaseManagement());

  final tourPoitrine = TextEditingController(),
      TourTaille = TextEditingController(),
      TourDos = TextEditingController(),
      TourHanche = TextEditingController(),
      LongueurManches = TextEditingController(),
      LargeurEpaules = TextEditingController(),
      LongueurJambes = TextEditingController(),
      HauteurEntrejambe = TextEditingController(),
      LongueurOurlet = TextEditingController(),
      TourBras = TextEditingController(),
      TourPoignet = TextEditingController(),
      HauteurTotale = TextEditingController(),
      TourCou = TextEditingController();

  FirebaseStorage storage = FirebaseStorage.instance;

  String? modelImageUrl;
  String? habitImageUrls;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.mesure != null) {
      widget.mesure!.habit.length != 0
          ? descriptionController1.text =
              widget.mesure!.habit.first.descriptionHabit!
          : "";
      widget.mesure!.models.length != 0
          ? descriptionController2.text =
              widget.mesure!.models.first.description!
          : "";
      widget.mesure!.client.length != 0
          ? clientNameController.text = widget.mesure!.client.first.nom!
          : "";
      widget.mesure!.models.length != 0
          ? prixController.text = widget.mesure!.models.first.prix
          : "";
      widget.mesure!.avance != null
          ? avanceController.text = widget.mesure!.avance!
          : "";
      widget.mesure!.reste != null
          ? resteController.text = widget.mesure!.reste!
          : "";
      widget.mesure!.hauteurEntrejambe != null
          ? HauteurEntrejambe.text = widget.mesure!.hauteurEntrejambe!
          : "";
      widget.mesure!.hauteurTotale != null
          ? HauteurTotale.text = widget.mesure!.hauteurTotale!
          : "";
      widget.mesure!.largeursEpaules != null
          ? LargeurEpaules.text = widget.mesure!.largeursEpaules!
          : "";
      widget.mesure!.longueurJambes != null
          ? LongueurJambes.text = widget.mesure!.longueurJambes!
          : "";
      widget.mesure!.longueurManches != null
          ? LongueurManches.text = widget.mesure!.longueurManches!
          : "";
      widget.mesure!.longueurOurlet != null
          ? LongueurOurlet.text = widget.mesure!.longueurOurlet!
          : "";
      widget.mesure!.tourBras != null
          ? TourBras.text = widget.mesure!.tourBras!
          : "";
      widget.mesure!.tourCou != null
          ? TourCou.text = widget.mesure!.tourCou!
          : "";
      widget.mesure!.tourDos != null
          ? TourDos.text = widget.mesure!.tourDos!
          : "";
      widget.mesure!.tourHanche != null
          ? TourHanche.text = widget.mesure!.tourHanche!
          : "";
      widget.mesure!.tourPoignet != null
          ? TourPoignet.text = widget.mesure!.tourPoignet!
          : "";
      widget.mesure!.tourPoitrine != null
          ? tourPoitrine.text = widget.mesure!.tourPoitrine!
          : "";
      widget.mesure!.tourTaille != null
          ? TourTaille.text = widget.mesure!.tourTaille!
          : "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prise de Mesures'),
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
                builder: (context) => CustomerInformationPage(),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
            onPressed: () {
              final model = Models(
                  prix: prixController.text,
                  description: descriptionController2.text,
                  images: [Images(image: modelImageUrl!)]);
              final habit = Habit(
                  image: habitImageUrls!,
                  descriptionHabit: descriptionController1.text);
              final mess = Mesures(
                client: [
                  MesClients(
                    nom: clientNameController.text,
                  )
                ],
                models: [model],
                habit: [habit],
                avance: avanceController.text,
                reste: resteController.text,
                tourPoitrine: tourPoitrine.text,
                tourBras: TourBras.text,
                tourCou: TourCou.text,
                tourDos: TourDos.text,
                tourTaille: TourTaille.text,
                tourPoignet: TourPoignet.text,
                tourHanche: TourHanche.text,
                longueurJambes: LongueurJambes.text,
                longueurManches: LongueurManches.text,
                longueurOurlet: LongueurOurlet.text,
                largeursEpaules: LargeurEpaules.text,
              );
              // //Mesures(tailleurs: tailleurs, client: client, models: Models(nom: , prix: prix, description: ,images: Images), habit: habit, prixG: prixG)
              _management.CreerMesures(
                  mess, _management.tailleurs.first.token!);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Prix',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Container(
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: TextFormField(
                              controller: prixController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(fontSize: 16),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Avance',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Container(
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: TextFormField(
                              controller: avanceController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(fontSize: 16),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Reste',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Container(
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: TextFormField(
                              controller: resteController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(fontSize: 16),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: clientNameController,
                  decoration: InputDecoration(
                    labelText: 'Nom du client',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    labelStyle: TextStyle(color: Colors.blue),
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text('Habit',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 16),
                          GestureDetector(
                            onTap: () {
                              pickImage((image) async {
                                habitImageUrls =
                                    await uploadImage(image!, "habit");
                                setState(() {
                                  selectedImage1 = image;
                                });
                              });
                            },
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.grey,
                              ),
                              child: selectedImage1 != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child: Image.file(
                                        selectedImage1!,
                                        width: 150,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : widget.mesure != null
                                      ? widget.mesure!.habit.length == 0
                                          ? Icon(
                                              Icons.add_a_photo,
                                              size: 70,
                                              color: Colors.white,
                                            )
                                          : Image.network(
                                              widget.mesure!.habit.first.image)
                                      : Icon(
                                          Icons.add_a_photo,
                                          size: 70,
                                          color: Colors.white,
                                        ),
                            ),
                          ),
                          SizedBox(height: 16),
                          // TextFormField(
                          //   controller: descriptionController1,
                          //   decoration: InputDecoration(
                          //       labelText: 'Description de la mesure (Habit)'),
                          // ),
                          TextFormField(
                            controller: descriptionController1,
                            decoration: InputDecoration(
                              labelText: 'Description habit',
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              labelStyle: TextStyle(color: Colors.blue),
                            ),
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        children: [
                          Text('Modèle',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 16),
                          GestureDetector(
                            onTap: () {
                              pickImage((image) async {
                                modelImageUrl =
                                    await uploadImage(image!, "model");
                                setState(() {
                                  selectedImage2 = image;
                                });
                              });
                            },
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.grey,
                              ),
                              child: selectedImage2 != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child: Image.file(
                                        selectedImage2!,
                                        width: 150,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Icon(
                                      Icons.add_a_photo,
                                      size: 70,
                                      color: Colors.white,
                                    ),
                            ),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: descriptionController2,
                            decoration: InputDecoration(
                              labelText: 'Description du model',
                              border: OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              labelStyle: TextStyle(color: Colors.blue),
                            ),
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ],
                ),
                // TextFormField(
                //   controller: tourPoitrine,
                //   decoration:
                //       InputDecoration(labelText: 'tour Poitrine (optionnel)'),
                // ),
                TextFormField(
                  controller: tourPoitrine,
                  decoration: InputDecoration(
                    labelText: 'TP: Tour Poitrine',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    labelStyle: TextStyle(color: Colors.blue),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: TourBras,
                  decoration: InputDecoration(
                    labelText: 'TM: Tour Manche',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    labelStyle: TextStyle(color: Colors.blue),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: TourCou,
                  decoration: InputDecoration(
                    labelText: 'C: Cuisse',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    labelStyle: TextStyle(color: Colors.blue),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: TourDos,
                  decoration: InputDecoration(
                    labelText: 'LB: Longueurs Boubou',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    labelStyle: TextStyle(color: Colors.blue),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: TourHanche,
                  decoration: InputDecoration(
                    labelText: 'E: Epaules ',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    labelStyle: TextStyle(color: Colors.blue),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: TourPoignet,
                  decoration: InputDecoration(
                    labelText: 'F: Fesse ',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    labelStyle: TextStyle(color: Colors.blue),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: TourTaille,
                  decoration: InputDecoration(
                    labelText: 'T: Taille',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    labelStyle: TextStyle(color: Colors.blue),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: LongueurJambes,
                  decoration: InputDecoration(
                    labelText: 'LJ: Longueur  jupe ',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    labelStyle: TextStyle(color: Colors.blue),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: LongueurManches,
                  decoration: InputDecoration(
                    labelText: 'LP: Longueur patalon',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    labelStyle: TextStyle(color: Colors.blue),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: LongueurOurlet,
                  decoration: InputDecoration(
                    labelText: 'P: Poitrine',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    labelStyle: TextStyle(color: Colors.blue),
                  ),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: LargeurEpaules,
                  decoration: InputDecoration(
                    labelText: 'C: Cou ',
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    labelStyle: TextStyle(color: Colors.blue),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final model = Models(
                        prix: prixController.text,
                        description: descriptionController2.text,
                        images: [Images(image: modelImageUrl!)]);
                    final habit = Habit(
                        image: habitImageUrls!,
                        descriptionHabit: descriptionController1.text);
                    final mess = Mesures(
                      client: [
                        MesClients(
                          nom: clientNameController.text,
                        )
                      ],
                      models: [model],
                      habit: [habit],
                      avance: avanceController.text,
                      reste: resteController.text,
                      tourPoitrine: tourPoitrine.text,
                      tourBras: TourBras.text,
                      tourCou: TourCou.text,
                      tourDos: TourDos.text,
                      tourTaille: TourTaille.text,
                      tourPoignet: TourPoignet.text,
                      tourHanche: TourHanche.text,
                      longueurJambes: LongueurJambes.text,
                      longueurManches: LongueurManches.text,
                      longueurOurlet: LongueurOurlet.text,
                      largeursEpaules: LargeurEpaules.text,
                    );
                    // //Mesures(tailleurs: tailleurs, client: client, models: Models(nom: , prix: prix, description: ,images: Images), habit: habit, prixG: prixG)
                    _management.CreerMesures(
                        mess, _management.tailleurs.first.token!);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomerInformationPage()),
                    );
                  },
                  child: Text(
                    'Enregistrer avec les images',
                    style: TextStyle(color: Color(0xFF09126C)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void pickImage(Function(File?) onImagePicked) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      onImagePicked(File(pickedFile.path));
    }
  }
}



// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
//
// import '../screen/home_screen.dart';
// import 'mesureEnregistrer.dart';
//
// class MesuresPage extends StatefulWidget {
//   @override
//   _MesuresPageState createState() => _MesuresPageState();
// }
//
// class _MesuresPageState extends State<MesuresPage> {
//   List<Mesure> mesures = [];
//   TextEditingController valeurController = TextEditingController();
//   String? selectedTypeDeMesure;
//   File? selectedImage1;
//   File? selectedImage2;
//   final _formKey = GlobalKey<FormState>();
//
//   List<String> typesDeMesure = [
//     'Tour de poitrine',
//     'Tour de taille',
//     'Tour de dos',
//     'Tour de hanche',
//     'Longueur des manches',
//     'Largeur des épaules',
//     'Longueur des jambes',
//     'Hauteur entrejambe',
//     'Longueur d\'ourlet',
//     'Tour de bras',
//     'Tour de poignet',
//     'Hauteur totale',
//     'Tour de cou',
//   ];
//
//   List<Pair<File?, String>> imagesWithDescriptions = [];
//   TextEditingController descriptionController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF3b5999),
//         title: Text('Prise de Mesures'),
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back_ios_new,
//             color: Colors.grey,
//           ),
//           onPressed: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => HomeScreen(),
//               ),
//             );
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.save,
//               color: Colors.white,
//             ),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => MesuresEnregistreesListPage(mesures: mesures, clients: [],),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 Text('Habit', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                 SizedBox(height: 16),
//                 Container(
//                   width: 150,
//                   height: 150,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.rectangle,
//                     color: Colors.grey,
//                   ),
//                   child: selectedImage1 != null
//                       ? ClipRRect(
//                     borderRadius: BorderRadius.circular(0),
//                     child: Image.file(
//                       selectedImage1!,
//                       width: 150,
//                       height: 150,
//                       fit: BoxFit.cover,
//                     ),
//                   )
//                       : Icon(
//                     Icons.add_a_photo,
//                     size: 70,
//                     color: Colors.white,
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 TextFormField(
//                   controller: descriptionController,
//                   decoration: InputDecoration(labelText: 'Description de la mesure (Habit)'),
//                 ),
//                 SizedBox(height: 16),
//                 Text('Modèle', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                 SizedBox(height: 16),
//                 Container(
//                   width: 150,
//                   height: 150,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.rectangle,
//                     color: Colors.grey,
//                   ),
//                   child: selectedImage2 != null
//                       ? ClipRRect(
//                     borderRadius: BorderRadius.circular(0),
//                     child: Image.file(
//                       selectedImage2!,
//                       width: 150,
//                       height: 150,
//                       fit: BoxFit.cover,
//                     ),
//                   )
//                       : Icon(
//                     Icons.add_a_photo,
//                     size: 70,
//                     color: Colors.white,
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 TextFormField(
//                   controller: descriptionController,
//                   decoration: InputDecoration(labelText: 'Description de la mesure (Modèle)'),
//                 ),
//                 SizedBox(height: 16),
//                 DropdownButtonFormField<String>(
//                   value: selectedTypeDeMesure,
//                   items: typesDeMesure.map((type) {
//                     return DropdownMenuItem<String>(
//                       value: type,
//                       child: Text(type),
//                     );
//                   }).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       selectedTypeDeMesure = value;
//                     });
//                   },
//                   validator: (value) {
//                     if (value == null) {
//                       return 'Veuillez sélectionner un type de mesure';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: valeurController,
//                   decoration: InputDecoration(labelText: 'Valeur de la mesure'),
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return 'Veuillez saisir une valeur';
//                     }
//                     return null;
//                   },
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {
//                       mesures.add(Mesure(
//                         type: selectedTypeDeMesure!,
//                         valeur: valeurController.text,
//                       ));
//                       valeurController.clear();
//                       selectedTypeDeMesure = null;
//                       setState(() {});
//                     }
//                   },
//                   child: Text('Enregistrer la mesure'),
//                 ),
//                 if (mesures.isNotEmpty)
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: mesures.map((mesure) {
//                       return Card(
//                         margin: EdgeInsets.symmetric(vertical: 8.0),
//                         elevation: 2.0,
//                         child: ListTile(
//                           title: Text('Type de Mesure: ${mesure.type}'),
//                           subtitle: Text('Valeur de la Mesure: ${mesure.valeur}'),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 if (imagesWithDescriptions.isNotEmpty)
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: imagesWithDescriptions.map((pair) {
//                       return Card(
//                         margin: EdgeInsets.symmetric(vertical: 8.0),
//                         elevation: 2.0,
//                         child: ListTile(
//                           title: Text('Description: ${pair.second}'),
//                           subtitle: Image.file(pair.first!),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ElevatedButton(
//                   onPressed: () {
//                     if (selectedImage1 != null && selectedImage2 != null) {
//                       // Ajoutez ici la logique pour associer les images avec les mesures
//                       // par exemple, envoyez les images et les mesures à votre base de données
//                     }
//                   },
//                   child: Text('Enregistrer avec les images'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class Mesure {
//   final String type;
//   final String valeur;
//
//   Mesure({required this.type, required this.valeur});
// }
//
// class Pair<T, U> {
//   final T first;
//   final U second;
//
//   Pair(this.first, this.second);
// }
