import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: ToDoListPage(),
  ));
}

class ToDoListPage extends StatefulWidget {
  @override
  _ToDoListPageState createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  List<Task> tasks = [];

  @override
  Widget build(BuildContext context) {
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
            Navigator.pop(context); // Revenir à la liste des demandes de commande
          },
        ),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(tasks[index].name),
            onTap: () {
              navigateToTaskDetails(tasks[index]);
            },
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
          actions: <Widget>[
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
      Task newTask = Task(taskName);
      tasks.add(newTask);
    });
  }

  void navigateToTaskDetails(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailsPage(task: task),
      ),
    );
  }
}

class Task {
  String name;
  List<SubTask> subTasks;

  Task(this.name, {this.subTasks = const []});
}

class SubTask {
  String name;
  bool isCompleted;

  SubTask(this.name, {this.isCompleted = false});
}

class TaskDetailsPage extends StatefulWidget {
  final Task task;

  TaskDetailsPage({required this.task});

  @override
  _TaskDetailsPageState createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  TextEditingController subTaskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task.name),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: widget.task.subTasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(widget.task.subTasks[index].name),
                  trailing: Checkbox(
                    value: widget.task.subTasks[index].isCompleted,
                    onChanged: (value) {
                      setState(() {
                        widget.task.subTasks[index].isCompleted = value!;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: subTaskController,
                    decoration: InputDecoration(labelText: 'Ajouter une sous-tâche'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    addSubTask();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void addSubTask() {
    String subTaskName = subTaskController.text;
    if (subTaskName.isNotEmpty) {
      setState(() {
        widget.task.subTasks.add(SubTask(subTaskName));
        subTaskController.clear();
      });
    }
  }
}
