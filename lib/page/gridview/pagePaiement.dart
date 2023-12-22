import 'dart:io';

import 'package:fashion2/models/paiement.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../firestore.dart';
import '../../screen/home_screen.dart';

class InvoiceAndAccountingPage extends StatefulWidget {
  @override
  _InvoiceAndAccountingPageState createState() =>
      _InvoiceAndAccountingPageState();
}

class _InvoiceAndAccountingPageState extends State<InvoiceAndAccountingPage> {
  File? selectedImage;

  TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  TextEditingController clientNameController = TextEditingController();
  TextEditingController clientNumController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  List<Paiement> invoices = []; // Mettre à jour le type de liste

  String? clientName;
  String? invoiceAmount;
  DateTime? invoiceDate;

  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseManagement _management = Get.put(FirebaseManagement());

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
    invoices = _management.tailleurs.first.paiement!;
  }

  @override
  Widget build(BuildContext context) {
    invoices = _management.tailleurs.first.paiement!;
    return Scaffold(
      appBar: AppBar(
        title: Text("Facturation et Comptabilité"),
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
                builder: (context) => HomeScreen(), // Votre widget par défaut
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.history,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InvoiceHistoryPage(invoices),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: clientNameController,
                  decoration: InputDecoration(
                    labelText: 'Nom du client',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ce champ est requis';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    clientName = value;
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  controller: clientNumController,
                  decoration: InputDecoration(
                    labelText: 'Numero du Client',
                    prefixIcon: Icon(Icons.numbers),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ce champ est requis';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    clientName = value;
                  },
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text('Habit',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          SizedBox(height: 16),
                          GestureDetector(
                            onTap: () {
                              pickImage((image) async {
                                habitImageUrls =
                                    await uploadImage(image!, "habit");
                                setState(() {
                                  selectedImage = image;
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
                              child: selectedImage != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child: Image.file(
                                        selectedImage!,
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
                            controller: descriptionController,
                            decoration: InputDecoration(
                                labelText: 'Description de la mesure (Habit)'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: 'Montant de la facture',
                    prefixIcon: Icon(Icons.monetization_on),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ce champ est requis';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    invoiceAmount = value;
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(DateTime.now().year - 5),
                      lastDate: DateTime(DateTime.now().year + 5),
                    );
                    if (pickedDate != null && pickedDate != invoiceDate) {
                      setState(() {
                        invoiceDate = pickedDate;
                      });
                    }
                  },
                  child: Text(invoiceDate != null
                      ? 'Date sélectionnée: ${DateFormat.yMd().format(invoiceDate!)}'
                      : 'Sélectionner la date'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // final invoice = Paiement(montantPaye: _amountController.text, client: clientNameController.text, habit: habit, datePaiement: dateController.DateTime.now);
                      setState(() {
                        // invoices.add(invoice);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Facture créée avec succès!'),
                      ));
                    }
                  },
                  child: Text("Créer la facture"),
                ),
                SizedBox(height: 20),
                Text(
                  'Liste des factures :',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: invoices.map((invoice) {
                    return ListTile(
                      title: Text(
                        '${invoice.client} - ${invoice.montantPaye} \$ - ${DateFormat.yMd().format(invoice.datePaiement)}',
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue, // Choisissez la couleur souhaitée
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            // Ajoutez ici la logique pour créer la facture
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Facture créée avec succès!'),
            ));
          }
        },
        child: Icon(Icons.add),
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

class InvoiceHistoryPage extends StatelessWidget {
  final List<Paiement> invoices;

  const InvoiceHistoryPage(this.invoices);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historique des Factures'),
        backgroundColor: const Color(0xFF09126C),
      ),
      body: ListView.builder(
        itemCount: invoices.length,
        itemBuilder: (context, index) {
          final invoice = invoices[index];
          return ListTile(
            // title: Text(Paiement(montantPaye: , client: client, habit: habit, datePaiement: datePaiement).first),
            subtitle: Text(
              'Date : ${DateFormat.yMd().format(invoice.datePaiement)}, Mois : ${DateFormat.yMMM().format(invoice.datePaiement)}',
            ),
          );
        },
      ),
    );
  }
}
