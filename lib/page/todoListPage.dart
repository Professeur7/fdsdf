import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion2/firestore.dart';
import 'package:fashion2/models/soustaches.dart';
import 'package:fashion2/models/tache.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class ToDoListPage extends StatefulWidget {
  @override
  _ToDoListPageState createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  FirebaseManagement _management = Get.put(FirebaseManagement());
  List<Taches> tasks = [];
  function() async {
    tasks = _management.tailleurs.first.taches!;
    // tasks = await _management.getTaches(_management.tailleurs.first.token!);
  }

  void main() {
    initializeDateFormatting(); // Initialise la localisation pour les formats de date
    // ... Votre code d'initialisation de l'application
  }

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    function();
  }

  @override
  Widget build(BuildContext context) {
    function();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF09126C),
        title: Text('To-Do List'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pop(
                context); // Revenir à la liste des demandes de commande
          },
        ),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(tasks[index].token!),
            onDismissed: (direction) {
              // Supprimez la tâche de la liste lorsque l'utilisateur la fait glisser
              setState(() {
                tasks.removeAt(index);
              });
            },
            background: Container(
              color: Colors.red,
              child: Icon(Icons.delete, color: Colors.white),
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20.0),
            ),
            child: ListTile(
              title: Text(tasks[index].nom),
              onTap: () {
                navigateToTaskDetails(tasks[index]);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF09126C),
        onPressed: () {
          showTaskForm();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void showTaskForm() {
    showDialog(
      context: context,
      builder: (context) {
        String taskName = '';
        return AlertDialog(
          title: Text('Ajouter une tâche'),
          content: TextFormField(
            onChanged: (value) {
              taskName = value;
            },
            decoration: InputDecoration(labelText: 'Nom de la tâche'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                addTask(taskName);
                Navigator.of(context).pop();
              },
              child: Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  void addTask(String taskName) {
    setState(() {
      Taches newTask = Taches(nom: taskName);
      _management.createTache(newTask, _management.tailleurs.first.token!);
      tasks.add(newTask);
    });
  }

  void navigateToTaskDetails(Taches task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailsPage(task: task),
      ),
    );
  }
}

class TaskDetailsPage extends StatefulWidget {
  final Taches task;

  TaskDetailsPage({required this.task});

  @override
  _TaskDetailsPageState createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

// Contrôleurs pour les champs
  final subTaskController1 = TextEditingController();
  final subTaskController2 = TextEditingController();
  final subTaskController3 = TextEditingController();
  TextEditingController subTaskController = TextEditingController();
  FirebaseManagement _management = Get.put(FirebaseManagement());
  // Méthode pour afficher le sélecteur de date
  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        // Mettre à jour le contrôleur avec la date sélectionnée
        subTaskController1.text = selectedDate!.toString();
      });
    }
  }

// Méthode pour afficher le sélecteur d'heure
  void _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
        // Mettre à jour le contrôleur avec l'heure sélectionnée
        subTaskController2.text = selectedTime!.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task.nom),
      ),
      body: Column(
        children: [
          widget.task.sousTaches == null
              ? Container()
              : Expanded(
                  child: ListView.builder(
                    itemCount: widget.task.sousTaches?.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.task.sousTaches![index].description),
                            Text(
                              'Date: ${DateFormat('EEEE, d MMMM y', 'fr').format(widget.task.sousTaches![index].date.toDate())}',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            Text(
                              'Heure début: ${DateFormat('HH:mm', 'fr').format((widget.task.sousTaches![index].debut as Timestamp).toDate())}',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            Text(
                              'Heure fin: ${DateFormat('HH:mm', 'fr').format((widget.task.sousTaches![index].fin as Timestamp).toDate())}',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        trailing: Checkbox(
                          value: widget.task.sousTaches![index].valide,
                          onChanged: (value) {
                            setState(() {
                              widget.task.sousTaches![index].valide = value!;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                FloatingActionButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Ajouter une sous-tâche'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: subTaskController,
                                decoration: InputDecoration(
                                  labelText: 'Description',
                                ),
                              ),
                              TextField(
                                controller: subTaskController1,
                                readOnly:
                                    true, // Rendre le champ de texte en lecture seule
                                onTap: () {
                                  _selectDate(
                                      context); // Afficher le sélecteur de date au clic
                                },
                                decoration: InputDecoration(
                                  labelText: 'Date',
                                ),
                              ),
                              SizedBox(
                                  height: 16), // Espacement entre les champs
                              TextField(
                                controller: subTaskController2,
                                readOnly:
                                    true, // Rendre le champ de texte en lecture seule
                                onTap: () {
                                  _selectTime(
                                      context); // Afficher le sélecteur d'heure au clic
                                },
                                decoration: InputDecoration(
                                  labelText: 'Heure debut',
                                ),
                              ),
                              SizedBox(
                                  height: 16), // Espacement entre les champs
                              TextField(
                                controller: subTaskController3,
                                readOnly:
                                    true, // Rendre le champ de texte en lecture seule
                                onTap: () {
                                  _selectTime(
                                      context); // Afficher le sélecteur d'heure au clic
                                },
                                decoration: InputDecoration(
                                  labelText: 'Heure fin',
                                ),
                              ),
                              // Autres champs pour debut, fin, valide, etc.
                              // Utilisez les widgets appropriés pour ces champs
                            ],
                          ),
                          actions: [
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    if (selectedDate != null &&
                                        selectedTime != null) {
                                      // Utiliser les valeurs sélectionnées
                                      // ...
                                      final s = SousTaches(
                                        date: Timestamp.fromDate(selectedDate!),
                                        debut: selectedTime!.toString(),
                                        fin: selectedTime!.toString(),
                                        valide: false,
                                        description: subTaskController.text,
                                      );
                                      setState(() {
                                        _management.createSousTache(
                                            s,
                                            _management.tailleurs.first.token!,
                                            widget.task.token!);
                                        widget.task.sousTaches!.add(s);
                                      });
                                    }

                                    subTaskController.text = '';
                                    Navigator.of(context)
                                        .pop(); // Fermer le dialogue après ajout
                                  },
                                  child: Text('Enregistrer'),
                                ),
                                SizedBox(
                                    width: 8), // Espacement entre les boutons
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Fermer le dialogue sans enregistrer
                                  },
                                  child: Text('Annuler'),
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.end,
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Icon(Icons.add),
                  tooltip: 'Ajouter une sous-tâche',
                ),
              ],
              // children: [
              //   Expanded(
              //     child: TextField(
              //       controller: subTaskController,
              //       decoration:
              //           InputDecoration(labelText: 'Ajouter une sous-tâche'),
              //     ),
              //   ),
              //   IconButton(
              //     icon: Icon(Icons.add),
              //     onPressed: () {
              //       final s = SousTaches(
              //           debut: DateTime.now(),
              //           fin: DateTime.now(),
              //           valide: false,
              //           description: subTaskController.text);
              //       _management.createSousTache(s, widget.task.token!,
              //           _management.tailleurs.first.token!);
              //       widget.task.sousTaches!.add(s);
              //       subTaskController.text = "";
              //     },
              //   ),
              // ],
            ),
          ),
        ],
      ),
    );
  }
}
