import 'package:flutter/material.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/pages/update.dart';
import 'package:todo_app/services/current_ToDo.dart';
import 'package:todo_app/custom_widgets/shared_appbar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void setupdb() async {
    await CurrentTodo.openDB();
    final fetchedTodos = await CurrentTodo.readTodos();
    setState(() {
      final now = DateTime.now();
      // todos = fetchedTodos.where((t) {
      //   if (widget.key == const ValueKey('completed')) {
      //     return t.isCompleted;
      //   }

      //   if (widget.key == const ValueKey('overDue') && !t.isCompleted) {
      //     return !t.isCompleted && t.repeatDate.isBefore(now);
      //   }

      //   // default: active / upcoming
      //   return !t.isCompleted && t.repeatDate.isAfter(now);
      // }).toList();
      todos = fetchedTodos;
    });
  }

  Color getColor(TodoPriority priority) {
    switch (priority) {
      case TodoPriority.low:
        return const Color.fromARGB(255, 86, 211, 220);
      case TodoPriority.medium:
        return const Color.fromARGB(255, 255, 194, 97);
      case TodoPriority.high:
        return const Color.fromARGB(255, 255, 130, 110);
    }
  }

  void search(String text) async {
    final fetchedTodos = await CurrentTodo.readTodos();

    setState(() {
      todos = fetchedTodos
          .where(
            (t) =>
                (t.isCompleted == (widget.key == ValueKey('completed')) &&
                t.title.toLowerCase().startsWith(text.toLowerCase())),
          )
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    setupdb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SharedAppbar.myAppBar(search, context),
      body: SafeArea(
        child: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            return Dismissible(
              direction: DismissDirection.endToStart,
              key: ValueKey(todo.id), // Unique key per item
              onDismissed: (direction) {
                setState(() {
                  todos.removeAt(index); // remove from list
                });
                CurrentTodo.deleteTodo(todo.id, context); // remove from DB
              },
              background: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.centerRight,
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.delete, color: Colors.white),
              ),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: getColor(todos[index].priority),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  child: ListTile(
                    title: Text(
                      todos[index].title,
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      todos[index].description,
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    trailing: Icon(
                      todos[index].isCompleted ? Icons.done : Icons.circle,
                      color: todos[index].isCompleted
                          ? Colors.white
                          : Colors.transparent,
                    ),
                  ),
                  onLongPress: () {
                    setState(() {
                      todos[index].isCompleted = !todos[index].isCompleted;
                      CurrentTodo.updateTodo(todos[index], context);
                    });
                    setupdb();
                  },
                  onDoubleTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateTodo(todos[index]),
                      ),
                    ),
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
