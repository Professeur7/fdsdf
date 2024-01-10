import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fashion2/models/mesClients.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../firestore.dart';
import '../../models/rendez_vous.dart';
import '../../screen/home_screen.dart';

class AppointmentAndSchedulingPage extends StatefulWidget {
  @override
  _AppointmentAndSchedulingPageState createState() =>
      _AppointmentAndSchedulingPageState();
}

class _AppointmentAndSchedulingPageState
    extends State<AppointmentAndSchedulingPage> {
  TextEditingController _clientNameController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _objectController = TextEditingController();
  late CalendarController _calendarController;
  //late List<Event> events;
  FirebaseManagement _management = Get.put(FirebaseManagement());
  // Dans votre classe _AppointmentAndSchedulingPageState :
  late MesClients clients;

  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  List<MesClients> items = [];
  String? selectedValue;

  Future<void> _pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _imageFile = File(pickedImage.path);
      }
    });
  }

  @override
  void dispose() {
    _calendarController.dispose();
    _clientNameController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _objectController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    items = _management.mesClients;
  }

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (pickedDate != null && pickedDate != _dateController.text) {
      setState(() {
        _dateController.text = pickedDate.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gestion des Rendez-vous et de la Planification"),
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SfCalendar(
              view: CalendarView.month,
              controller: _calendarController,
              dataSource: EventDataSource(_management.rdv),
            ),
            SizedBox(height: 20),
            Text("Rendez-vous du jour :"),
            ListView.builder(
              shrinkWrap:
                  true, // Ajuster la hauteur de la liste en fonction du contenu
              physics:
                  NeverScrollableScrollPhysics(), // Empêcher le défilement de la liste pour être scrollée indépendamment
              itemCount: _management.rdv.length,
              itemBuilder: (context, index) {
                final event = _management.rdv[index];
                return ListTile(
                  leading: _imageFile != null
                      ? CircleAvatar(
                          radius: 50,
                          backgroundImage: FileImage(
                              _imageFile!) // Utiliser une image par défaut
                          )
                      : CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage(
                              'assets/images/about.png') // Utiliser une image par défaut
                          ),
                  title: Text(event.client),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date du RDV : ${event.date.toLocal()}'),
                      Text('Heure du RDV : ${event.date.hour}'),
                      Text('Motif : ${event.motif}'),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF09126C),
        onPressed: () {
          _showAddAppointmentDialog(context);
          // Ajoutez ici la logique pour planifier un nouveau rendez-vous
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddAppointmentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nouveau Rendez-vous'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // TextFormField(
                //   controller: _clientNameController,
                //   decoration: InputDecoration(labelText: 'Nom du client'),
                // ),
                DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    hint: const Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 16,
                          color: Colors.yellow,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: Text(
                            'Liste clients',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
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
                      width: 400,
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.black26,
                        ),
                        color: Colors.grey,
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
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _pickImage();
                  },
                  child: Text('Sélectionner une image'),
                ),
                SizedBox(height: 20),
                _imageFile != null
                    ? Image.file(
                        File(_imageFile!.path),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    : SizedBox.shrink(),
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: 'Date du rendez-vous',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () {
                        _selectDate(context);
                      },
                    ),
                  ),
                  keyboardType: TextInputType.datetime,
                  readOnly:
                      true, // Rend le champ texte en lecture seule pour empêcher la saisie directe
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _timeController,
                  decoration:
                      InputDecoration(labelText: 'Heure du rendez-vous'),
                  keyboardType: TextInputType.datetime,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _objectController,
                  decoration:
                      InputDecoration(labelText: 'Objet du rendez-vous'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Logique pour annuler la création du rendez-vous
              },
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                // Appel à votre fonction de création de RDV
                setState(() {
                  RDV newRDV = RDV(
                      client: _clientNameController.text,
                      date: DateTime.parse(_dateController.text),
                      motif: _objectController.text);

                  _management.creerRDV(
                      newRDV, _management.tailleurs.first.token!);
                  // Ajout du nouveau rendez-vous à la liste
                });
                //Navigator.of(context).pop();
              },
              child: Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }
}

// class Event {
//   final String clientName;
//   final DateTime appointmentDate;
//   final DateTime dateRDV;
//   final DateTime heureRDV;
//   final String motif;
//   // Ajoutez cette ligne pour inclure la date du RDV

//   Event(this.clientName, this.appointmentDate, this.dateRDV, this.heureRDV,
//       this.motif);
// }

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<RDV> source) {
    appointments = source;
  }
}
