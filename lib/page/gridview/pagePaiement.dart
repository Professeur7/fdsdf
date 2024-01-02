import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fashion2/models/habit.dart';
import 'package:fashion2/models/mesClients.dart';
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
  List<MesClients> items = [];
  String? clientName;
  late MesClients clients;
  String? invoiceAmount;
  DateTime? invoiceDate;
  String? selectedValue;

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
    print("object");
    items = _management.mesClients;
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
              children: [
                // TextFormField(
                //   controller: clientNameController,
                //   decoration: InputDecoration(
                //     labelText: 'Nom du client',
                //     prefixIcon: Icon(Icons.person),
                //   ),
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Ce champ est requis';
                //     }
                //     return null;
                //   },
                //   onSaved: (value) {
                //     clientName = value;
                //   },
                // ),
                SizedBox(
                  height: 5,
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    hint: const Row(
                      children: [
                        Icon(
                          Icons.list,
                          size: 16,
                          color: Colors.yellow,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: Text(
                            'Clients',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.yellow,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    items: items
                        .map((MesClients item) => DropdownMenuItem<String>(
                              value: item.telephone,
                              child: Text(
                                "${item.nom!}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                    value: selectedValue,
                    onChanged: (String? value) {
                      setState(() {
                        selectedValue = value;
                        clients = items.firstWhere(
                            (element) => element.telephone == value);
                      });
                    },
                    buttonStyleData: ButtonStyleData(
                      height: 50,
                      width: 160,
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.black26,
                        ),
                        color: Colors.redAccent,
                      ),
                      elevation: 2,
                    ),
                    iconStyleData: const IconStyleData(
                      icon: Icon(
                        Icons.arrow_forward_ios_outlined,
                      ),
                      iconSize: 14,
                      iconEnabledColor: Colors.yellow,
                      iconDisabledColor: Colors.grey,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.redAccent,
                      ),
                      offset: const Offset(-20, 0),
                      scrollbarTheme: ScrollbarThemeData(
                        radius: const Radius.circular(40),
                        thickness: MaterialStateProperty.all<double>(6),
                        thumbVisibility: MaterialStateProperty.all<bool>(true),
                      ),
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                      padding: EdgeInsets.only(left: 14, right: 14),
                    ),
                  ),
                ),
                // TextFormField(
                //   controller: clientNumController,
                //   decoration: InputDecoration(
                //     labelText: 'Numero du Client',
                //     prefixIcon: Icon(Icons.numbers),
                //   ),
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Ce champ est requis';
                //     }
                //     return null;
                //   },
                //   onSaved: (value) {
                //     clientName = value;
                //   },
                // ),
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
                      final payement = Paiement(
                          montantPaye: _amountController.text,
                          client: [clients],
                          habit: [Habit(image: habitImageUrls!)],
                          datePaiement: invoiceDate!);
                      setState(() {
                        _management.PaiementManage(
                            payement, _management.tailleurs.first.token!);
                        invoices.add(payement);
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
