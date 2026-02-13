import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/models/banner.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:path/path.dart' as p;

List<ToDoModel> todos = [];

class CurrentTodo {
  static final String _dbName = 'todo.db';
  static final String _tableName = 'todos';
  static Database? _db;

  static Future<void> openDB() async {
    try {
      final databasePath = await getDatabasesPath();
      final path = p.join(databasePath, _dbName);
      _db = await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            everyDate INTEGER,
            priority INTEGER,
            isCompleted INTEGER,
            repeatingDays Text
          )
        ''');
        },
      );
    } catch (error) {
      throw Exception('Failed to open database: $error');
    }
  }

  static Future<int> createTodo(ToDoModel todo, BuildContext context) async {
    try {
      int st = await _db!.insert(
        _tableName,
        todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      if (st > 0) {
        if (context.mounted) {
          banner.showbanner(
            context: context,
            message: 'Todo Saved Successfuly!',
            severity: Severity.info,
          );
        }
      }
      return st;
    } catch (error) {
      if (context.mounted) {
        banner.showbanner(
          context: context,
          message: 'Failed to save todo: $error',
          severity: Severity.error,
        );
      }
      return -1;
    }
  }

  static Future<List<ToDoModel>> readTodos() async {
    if (_db == null) {
      throw Exception('Database not initialized. Call openDB() first.');
    }

    final List<Map<String, dynamic>> maps = await _db!.query(_tableName);
    todos = maps.map((map) => ToDoModel.fromMap(map)).toList();
    return todos.reversed
        .toList(); // Reverse the list to show the most recent first
  }

  static Future<bool> updateTodo(ToDoModel todo, BuildContext context) async {
    if (_db == null) {
      throw Exception('Database not initialized. Call openDB() first.');
    }
    try {
      await _db!.update(
        _tableName,
        todo.toMap(), // Update the fields of the ToDo item
        where: 'id = ?', // Match the row with the given ID
        whereArgs: [todo.id], // Pass the actual ID of the ToDo item
      );
      var index = todos.indexWhere((t) => t.id == todo.id);
      if (index == -1) {
        if (context.mounted) {
          banner.showbanner(
            context: context,
            message: 'Todo not found for update.',
            severity: Severity.error,
          );
        }
        return false; // Return false if the todo was not found
      }
      todos.removeAt(index);
      todos.insert(index, todo);
      if (context.mounted) {
        banner.showbanner(
          context: context,
          message: 'Todo Updated Successfully!',
          severity: Severity.info,
        );
      }
      return true;
    } catch (error) {
      return false; // Return false if there was an error
    }
  }

  static Future<bool> deleteTodo(int id, BuildContext context) async {
    if (_db == null) {
      throw Exception('Database not initialized. Call openDB() first.');
    }
    try {
      await _db!.delete(_tableName, where: 'id = ?', whereArgs: [id]);
      var index = todos.indexWhere((todo) => todo.id == id.toString());
      if (index != -1) {
        todos.removeAt(index); // Remove the todo from the list
      }
      if (context.mounted) {
        banner.showbanner(
          context: context,
          message: 'Todo Deleted Successfully!',
          severity: Severity.info,
        );
      }
      return true; // Return true if the deletion was successful
    } catch (error) {
      return false; // Return false if there was an error
    }
  }
}
