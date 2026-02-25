import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/models/formModel.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/pages/update.dart';
import 'package:todo_app/services/current_ToDo.dart';
import 'package:todo_app/custom_widgets/shared_appbar.dart';
import 'package:todo_app/custom_widgets/styles.dart';
import 'package:todo_app/themes.dart';

class TodoView extends StatefulWidget {
  const TodoView({super.key});

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> with FormModel {
  List<ToDoModel> fetchedTodos = [];
  Future setupdb() async {
    await CurrentTodo.openDB();
    await CurrentTodo.readTodos();
    setState(() {
      final now = DateTime.now();
      final todayName = DateFormat('EEEE').format(now); // e.g., "Monday"

      fetchedTodos = todos.where((t) {
        var overDue =
            !t.isCompleted &&
            (t.remindingDate != null && t.remindingDate!.isBefore(now));

        var key = widget.key.toString();
        if (key.contains('overDue')) {
          return overDue;
        } else if (key.contains('completed')) {
          return t.isCompleted;
        } else if (key.contains('active')) {
          return !t.isCompleted &&
                  (t.remindingDate != null
                      ? t.remindingDate!.isAfter(now)
                      : false) ||
              ((t.repeatingDays != null && t.repeatingDays!.isNotEmpty) &&
                  matchingDays(t.repeatingDays!).contains(todayName));
        }
        throw Exception('Unknown tab key: $key');
      }).toList();

      // REMOVED: todos = fetchedTodos; <--- This was your bug!
    });
  }

  void search(String text) async {
    if (mounted) {
      setState(() {
        fetchedTodos = [];
      });
      await setupdb();
      setState(() {
        fetchedTodos = fetchedTodos
            .where(
              (t) =>
                  t.title.toLowerCase().contains(text.toLowerCase()) ||
                  t.description.toLowerCase().contains(text.toLowerCase()),
            )
            .toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setupdb();
  }

  double deleteIconSize = 20;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedAppbar.myAppBar(search, context),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(
              Duration(seconds: 1),
            ); // Simulate a delay for refreshing
            setupdb();
          },
          child: ListView.builder(
            itemCount: fetchedTodos.length,
            itemBuilder: (context, index) {
              final todo = fetchedTodos[index];
              return Dismissible(
                direction: DismissDirection.endToStart,
                key: ValueKey(fetchedTodos[index].id), // Unique key per item
                onDismissed: (direction) {
                  setState(() {
                    fetchedTodos.removeAt(index); // remove from list
                  });
                  CurrentTodo.deleteTodo(todo.id, context); // remove from DB
                },
                background: Container(
                  margin: const EdgeInsets.all(8),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: deleteIconSize,
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    // color: cardBackColor(fetchedTodos[index].priority, context),
                    color: AppThemes.getSecondaryBg(context),
                    borderRadius: BorderRadius.circular(8),
                    border: Border(
                      left: BorderSide(
                        color: cardBackColor(
                          fetchedTodos[index].priority,
                          context,
                        ),
                        width: 4,
                      ),
                    ),
                  ),
                  child: InkWell(
                    child: ListTile(
                      title: Text(
                        fetchedTodos[index].title,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      subtitle: Text(
                        fetchedTodos[index].description,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    onLongPress: () {
                      setState(() {
                        fetchedTodos[index].isCompleted =
                            !fetchedTodos[index].isCompleted;
                        CurrentTodo.updateTodo(fetchedTodos[index], context);
                      });
                      setupdb();
                    },
                    onDoubleTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateTodo(fetchedTodos[index]),
                        ),
                      ),
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
