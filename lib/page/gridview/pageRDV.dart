import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    // events = [
    //   Event("Client A", DateTime.now().add(Duration(days: 2)), DateTime.now(),
    //       DateTime.now(), "Motif 1"),
    //   Event("Client B", DateTime.now().add(Duration(days: 7)), DateTime.now(),
    //       DateTime.now(), "Motif 2"),
    //   // Ajoutez ici vos rendez-vous existants avec les détails corrects
    // ];
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
                  leading: CircleAvatar(
                    // Afficher l'image du client ici
                    // Exemple : AssetImage('assets/images/client_image.jpg')
                    // Remplacez AssetImage par la méthode que vous utilisez pour charger l'image
                    // Utilisez event.clientImage pour obtenir l'image du client associée à l'événement
                    backgroundImage: AssetImage('assets/images/about.png'),
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
                TextFormField(
                  controller: _clientNameController,
                  decoration: InputDecoration(labelText: 'Nom du client'),
                ),
                SizedBox(height: 10),
                // TextFormField(
                //   controller: _dateController,
                //   decoration: InputDecoration(labelText: 'Date du rendez-vous'),
                //   keyboardType: TextInputType.datetime,
                // )
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
