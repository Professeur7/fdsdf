import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../screen/home_screen.dart';

void main() {
  runApp(MaterialApp(
    home: AppointmentAndSchedulingPage(),
  ));
}

class AppointmentAndSchedulingPage extends StatefulWidget {
  @override
  _AppointmentAndSchedulingPageState createState() =>
      _AppointmentAndSchedulingPageState();
}

class _AppointmentAndSchedulingPageState
    extends State<AppointmentAndSchedulingPage> {
  late CalendarController _calendarController;
  late List<Event> events;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    events = [
      Event("Client A", DateTime.now().add(Duration(days: 2))),
      Event("Client B", DateTime.now().add(Duration(days: 7))),
      // Ajoutez ici vos rendez-vous existants
    ];
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
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
                builder: (context) => HomeScreen(), // Remplacez PageDefault par votre widget de page par défaut
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
              dataSource: EventDataSource(events),
            ),
            SizedBox(height: 20),
            Text("Rendez-vous du jour :"),
            Column(
              children: events
                  .map((event) => ListTile(
                title: Text(event.clientName),
                subtitle: Text(
                    "Date: ${event.appointmentDate.toLocal()}"),
              ))
                  .toList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Ajoutez ici la logique pour planifier un nouveau rendez-vous
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class Event {
  final String clientName;
  final DateTime appointmentDate;

  Event(this.clientName, this.appointmentDate);
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> source) {
    appointments = source;
  }
}
