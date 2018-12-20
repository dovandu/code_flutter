// Xây dựng app TodoList bằng Flutter với Restful API

``` yaml
name: myapp
description: A new Flutter project.

dependencies:
  flutter:
    sdk: flutter
  query_params: "^0.5.0"

  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^0.1.0
  transparent_image: "^0.1.0"
  cached_network_image: "^0.4.1"

dev_dependencies:
  flutter_test:
    sdk: flutter


```

```dart
// models/task.dart
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:query_params/query_params.dart';
import 'package:myapp/global.dart';

class Task {
  int id;
  String name;
  bool finished;
  int todoId;
  //Constructor
  Task({
    this.id,
    this.name,
    this.finished,
    this.todoId
  });
  //Do the same as Todo
  factory Task.fromJson(Map<String, dynamic> json) {
    Task newTask = Task(
        id: json['id'],
        name: json['name'],
        finished: json['isfinished'],
        todoId: json['todoid']
    );
    return newTask;
  }
  //clone a Task, or "copy constructor"
  factory Task.fromTask(Task anotherTask) {
    return Task(
        id: anotherTask.id,
        name: anotherTask.name,
        finished: anotherTask.finished,
        todoId: anotherTask.todoId
    );
  }
}
//Controllers = "functions relating to Task"
Future<List<Task>> fetchTasks(http.Client client, int todoId) async {
  final response = await client.get('$URL_TASKS_BY_TODOID$todoId');
  if (response.statusCode == 200) {
    Map<String, dynamic> mapResponse = json.decode(response.body);
    if (mapResponse["result"] == "ok") {
      final tasks = mapResponse["data"].cast<Map<String, dynamic>>();
      return tasks.map<Task>((json){
        return Task.fromJson(json);
      }).toList();
    } else {
      return [];
    }
  } else {
    throw Exception('Failed to load Task');
  }
}
//Fetch Task by Id
Future<Task> fetchTaskById(http.Client client, int id) async {
  final String url = '$URL_TASKS/$id';
  final response = await client.get(url);
  if (response.statusCode == 200) {
    Map<String, dynamic> mapResponse = json.decode(response.body);
    if (mapResponse["result"] == "ok") {
      Map<String, dynamic> mapTask = mapResponse["data"];
      return Task.fromJson(mapTask);
    } else {
      return Task();
    }
  } else {
    throw Exception('Failed to get detail task with Id = {id}');
  }
}
//Update a task
Future<Task> updateATask(http.Client client,  Map<String, dynamic> params) async {
  final response = await client.put('$URL_TASKS/${params["id"]}', body: params);
  if (response.statusCode == 200) {
    final responseBody = await json.decode(response.body);
    return Task.fromJson(responseBody);
  } else {
    throw Exception('Failed to update a Task. Error: ${response.toString()}');
  }
}
//Delete a Task
Future<Task> deleteATask(http.Client client, int id) async {
  final String url = '$URL_TASKS/$id';
  final response = await client.delete(url);
  if (response.statusCode == 200) {final responseBody = await json.decode(response.body);
  return Task.fromJson(responseBody);

  } else {
    throw Exception('Failed to delete a Task');
  }
}


// models/todo.dart

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/global.dart';
class Todo {
  int id;
  String name;
  String dueDate;
  String description;
  //Constructor
  Todo({
    this.id,
    this.name,
    this.dueDate,
    this.description
  });
  //This is a static method
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json["id"],
      name: json["name"],
      dueDate: json["duedate"],
      description: json["description"]
    );
  }
}
//Fetch data from Restful API
Future<List<Todo>> fetchTodos(http.Client client) async {
  //How to make these URLs in a .dart file ?
  final response = await client.get(URL_TODOS);
  if(response.statusCode == 200) {
    Map<String, dynamic> mapResponse = json.decode(response.body);
    if(mapResponse["result"] == "ok") {
      final todos = mapResponse["data"].cast<Map<String, dynamic>>();
      final listOfTodos = await todos.map<Todo>((json) {
        return Todo.fromJson(json);
      }).toList();
      return listOfTodos;
    } else {
      return [];
    }
  } else {
    throw Exception('Failed to load Todo from the Internet');
  }
}

// main.dart

import 'package:flutter/material.dart';
import 'TodoScreen.dart';
//Define "root widget"
void main() => runApp(MyApp());//one-line function

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //build function returns a "Widget"
    final materialApp = MaterialApp(
      title: '',
      home: TodoScreen(),
    );
    return materialApp;
  }
}

// global.dart

const SERVER_NAME = "192.168.1.34";//your server's ip address
const URL_TODOS = "http://$SERVER_NAME:3000/todos";
const URL_TASKS = 'http://$SERVER_NAME:3000/tasks';
const URL_TASKS_BY_TODOID = 'http://$SERVER_NAME:3000/tasks/todoid/';


// TodoScreen.dart

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'models/todo.dart';
import 'TaskScreen.dart';

class TodoList extends StatelessWidget {
  final List<Todo> todos;
  //constructor
  TodoList({Key key, this.todos}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
      itemBuilder: (context, index){
      return GestureDetector(
        child: Container(
          padding: EdgeInsets.all(10.0),
          color: index % 2 ==0 ? Colors.greenAccent : Colors.cyan,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(todos[index].name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
              new Text('Date: ${todos[index].dueDate}', style: TextStyle(fontSize: 16.0),)
            ],
          ),
        ),
        onTap: () {
          //Navigate to task screen
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => TaskScreen(todoId: todos[index].id))
          );
        },
      );
    },
      itemCount: todos.length,
    );
  }
}

class TodoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TodoScreenState();
  }
}
class _TodoScreenState extends State<TodoScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Fetch Todos from Restful Api"),
      ),
      body: FutureBuilder(
          future: fetchTodos(http.Client()),
          builder: (context, snapshot) {
            if(snapshot.hasError) {
              print(snapshot.error);
            }
            return snapshot.hasData ? TodoList(todos: snapshot.data):Center(child: CircularProgressIndicator());
          }),
    );
  }
}

// TaskScreen.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'models/task.dart';
import 'DetailTaskScreen.dart';

class TaskScreen extends StatefulWidget {
  final int todoId;
  //constructor
  TaskScreen({this.todoId}):super();
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TaskScreenState();
  }
}
class _TaskScreenState extends State<TaskScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("List of tasks"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              //Press this button to navigate to detail Task
            },
          )
        ],
      ),
      body: FutureBuilder(
          future: fetchTasks(http.Client(), widget.todoId),
          builder: (context, snapshot){
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? TaskList(tasks: snapshot.data)
                : Center(child: CircularProgressIndicator());
          }),
    );
  }
}
class TaskList extends StatelessWidget {
  final List<Task> tasks;
  TaskList({Key key, this.tasks}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Container(
              padding: EdgeInsets.all(10.0),
              color: index % 2 == 0 ? Colors.deepOrangeAccent : Colors.amber,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment:CrossAxisAlignment.start,
                children: <Widget>[
                  Text(this.tasks[index].name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                  new Text('Finished: ${tasks[index].finished==true?"Yes":"No"}', style: TextStyle(fontSize: 16.0))
                ],
              ),
            ),
            onTap: () {
              int selectedId = tasks[index].id;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => new DetailTaskScreen(id: selectedId))
              );
            } ,
          );
        },
      itemCount: this.tasks.length,
    );
  }
}

// DetailTaskScreen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'models/task.dart';

class DetailTaskScreen extends StatefulWidget {
  final int id;
  DetailTaskScreen({this.id}) : super();
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DetailTaskScreenState();
  }
}
class _DetailTaskScreenState extends State<DetailTaskScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail task"),
      ),
      body: FutureBuilder(
          future: fetchTaskById(http.Client(), widget.id),
          builder:(context, snapshot){
            if (snapshot.hasError) print(snapshot.error);
            if (snapshot.hasData) {
              return DetailTask(task: snapshot.data);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }
      ),
    );
  }
}

class DetailTask extends StatefulWidget {
  final Task task;
  DetailTask({Key key, this.task}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DetailTaskState();
  }
}
class _DetailTaskState extends State<DetailTask> {
  Task task = new Task();
  bool isLoadedTask = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(isLoadedTask == false) {
      setState(() {
        this.task = Task.fromTask(widget.task);
        this.isLoadedTask = true;
      });
    }
    final TextField _txtTaskName = new TextField(
      decoration: InputDecoration(
        hintText: "Enter task's name",
        contentPadding: EdgeInsets.all(10.0),
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black))
      ),
      autocorrect: false,
      controller: TextEditingController(text: this.task.name),
      textAlign: TextAlign.left,
      onChanged: (text) {
        setState(() {
          this.task.name = text;
        });
      },
    );
    final Text _txtFinished = Text("Finished:", style: TextStyle(fontSize: 16.0));
    final Checkbox _cbFinished = Checkbox(
        value: this.task.finished,
        onChanged: (bool value) {
          setState(() {
            this.task.finished = value;
          });
        }
    );
    final _btnSave = RaisedButton(
        child: Text("Save"),
        color: Theme.of(context).accentColor,
        elevation: 4.0,
        onPressed: () async {
          //Update an existing task ?
          Map<String, dynamic> params = Map<String, dynamic>();
          params["id"] = this.task.id.toString();
          params["name"] = this.task.name;
          params["isfinished"] = this.task.finished ? "1" : "0";
          params["todoid"] = this.task.todoId.toString();
          await updateATask(http.Client(), params);
          Navigator.pop(context);
        }
    );
    final _btnDelete = RaisedButton(
      child: Text("Delete"),
      color: Colors.redAccent,
      elevation: 4.0,
      onPressed: () async {
        //Delete a Task
        //await deleteATask(http.Client(), this.task.id);
        //Navigator.pop(context);
        //Show "Confirmation dialog"
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Confirmation"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text("Are you sure you want to delete this ?")
                  ],
                ),
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('Yes'),
                  onPressed: () async {
                    await deleteATask(http.Client(), this.task.id);
                    await Navigator.pop(context);//Quit Dialog
                    Navigator.pop(context);//Quit to previous screen
                  },
                ),
                new FlatButton(
                  child: new Text('No'),
                  onPressed: () async {
                    Navigator.pop(context);//Quit to previous screen
                  },
                ),
              ],
            );
          }
        );
      },
    );
    final _column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        _txtTaskName,
        Container(
          padding: EdgeInsets.only(left: 10.0, right: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _txtFinished,
              _cbFinished
            ],
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(child: _btnSave),
            Expanded(child: _btnDelete)
          ],
        )
      ],
    );
    return Container(
      margin: EdgeInsets.all(10.0),
      child: _column,
    );
  }
}
```
