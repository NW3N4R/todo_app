import 'package:flutter/material.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/services/current_ToDo.dart';

mixin SearchModel {
  List<ToDoModel> viewList = [];
  List<ToDoModel> tempList = [];
  var textSearcher = TextEditingController();
  Set<String> selection = {'Active'};
  List<String> specificDays = [];
  DateTime? specificDate;
  Future<List<ToDoModel>> search() async {
    viewList = await CurrentTodo.readTodos();
    String txt = textSearcher.text;

    viewList = viewList.where((x) {
      // if search is empty or title or desc contains search txt then we have a matching there
      bool matchesText =
          txt.isEmpty ||
          x.title.toLowerCase().contains(txt.toLowerCase()) ||
          x.description.toLowerCase().contains(txt.toLowerCase());

      // if any of the filtering result turned this on then we need to return X
      bool matchesStatus = false;
      // Case: Completed
      if (selection.contains('Completed') && x.isCompleted) {
        matchesStatus = true;
      }

      // Case: OverDue
      if (selection.contains('Overdue') &&
          !x.isCompleted &&
          x.remindingDate != null) {
        if (x.remindingDate!.isBefore(DateTime.now())) {
          matchesStatus = true;
        }
      }
      // Case: Active
      if (selection.contains('Active')) {
        // Add !x.isCompleted here to ensure finished repeating tasks don't show up as active
        if (x.repeatingDays != null && !x.isCompleted) {
          matchesStatus = true;
        }

        if (x.remindingDate != null &&
            x.remindingDate!.isAfter(DateTime.now()) &&
            !x.isCompleted) {
          matchesStatus = true;
        }
      }
      return matchesText && matchesStatus;
    }).toList();
    return viewList;
  }
}
