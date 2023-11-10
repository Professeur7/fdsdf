// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// import '../models/taches.dart';
// import 'package:fashion2/models/tailleurs.dart';
//
// import '../screen/home_screen.dart';
//
// class TodoListPage extends StatefulWidget {
//   @override
//   _TodoListPageState createState() => _TodoListPageState();
// }
//
// class _TodoListPageState extends State<TodoListPage> {
//   final TextEditingController _taskController = TextEditingController();
//   bool _valide = false;
//   DateTime _selectedDate = DateTime.now();
//
//   List<Taches> _tasks = [];
//
//   void _showNotification(String title, String body) {
//     // Implémentez la logique pour afficher une notification locale
//   }
//
//   void _editTask(Taches task) {
//     // Ouvrez un formulaire d'édition pour la tâche
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Édition de la tâche'),
//           content: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Description'),
//                 Text(task.description ?? 'Sans description'),
//                 SizedBox(height: 16),
//                 Text('Valide'),
//                 Checkbox(
//                   value: _valide,
//                   onChanged: (value) {
//                     setState(() {
//                       _valide = value ?? false;
//                     });
//                   },
//                 ),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Enregistrer'),
//               onPressed: () {
//                 // Mettez à jour la tâche avec les nouvelles valeurs
//                 setState(() {
//                   // Mettez à jour la tâche ici
//                 });
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _deleteTask(Taches task) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Supprimer la tâche'),
//           content: Text('Êtes-vous sûr de vouloir supprimer cette tâche ?'),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Annuler'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('Supprimer'),
//               onPressed: () {
//                 // Supprimez la tâche de la liste
//                 _tasks.remove(task);
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _showTaskDetails(Taches task) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(task.description ?? 'Sans description'),
//           content: Text('Valide: ${task.valide ?? "Non"}'),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Fermer'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _addTask() {
//     // Ouvrez un formulaire pour ajouter une tâche
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Ajouter une tâche'),
//           content: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Description'),
//                 TextField(
//                   controller: _taskController,
//                 ),
//                 SizedBox(height: 16),
//                 Text('Valide'),
//                 Checkbox(
//                   value: _valide,
//                   onChanged: (value) {
//                     setState(() {
//                       _valide = value ?? false;
//                     });
//                   },
//                 ),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Annuler'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('Ajouter'),
//               onPressed: () {
//                 final newTask = Taches(
//                   dateDebut: _selectedDate,
//                   dateFin: _selectedDate,
//                   description: _taskController.text,
//                   valide: _valide ? 'Oui' : 'Non',
//                 );
//                 setState(() {
//                   _tasks.add(newTask);
//                 });
//                 _showNotification('Nouvelle tâche', newTask.description ?? '');
//                 _taskController.clear();
//                 _valide = false;
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF09126C),
//         title: Text('ToDo List'),
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back_ios_new,
//             color: Colors.grey,
//           ),
//           onPressed: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => HomeScreen(), // Remplacez PageDefault par votre widget de page par défaut
//               ),
//             );
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.alarm),
//             onPressed: () {
//               // Implémentez la logique pour gérer les alarmes
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: _tasks.length,
//               itemBuilder: (context, index) {
//                 final task = _tasks[index];
//                 return ListTile(
//                   title: Row(
//                     children: [
//                       Checkbox(
//                         value: task.valide == 'Oui',
//                         onChanged: (isChecked) {
//                           setState(() {
//                             // Mettez à jour la tâche comme validée ou non
//                             //task.valide = isChecked ? 'Oui' : 'Non';
//                           });
//                         },
//                       ),
//                       Text(task.description ?? 'Sans description'),
//                     ],
//                   ),
//                   onTap: () {
//                     _showTaskDetails(task);
//                   },
//                   onLongPress: () {
//                     _editTask(task);
//                   },
//                   trailing: IconButton(
//                     icon: Icon(Icons.delete),
//                     onPressed: () {
//                       _deleteTask(task);
//                     },
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _addTask,
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
