import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/models/todo_model.dart';

mixin FormModel {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController selectedDateController = TextEditingController();
  final TextEditingController selectedTimeController = TextEditingController();
  TodoPriority priority = TodoPriority.low; // Default priority
  final List<String> days = [
    'شەممە',
    'یەک شەممە',
    'دوو شەممە',
    'سێ شەممە',
    'چوار شەممە',
    'پێنج شەممە',
    'هەینی',
  ];
  DateTime? getCompleteDate(String time12h, String date) {
    try {
      print("Combining date and time: $date $time12h");

      // This looks for a date like "2026-02-23" and time like "02:30 PM"
      // and merges them into one DateTime object automatically.
      return DateFormat("dd-MM-yyyy hh:mm a").parse("$date $time12h");
    } catch (e) {
      // Returns null if the format is wrong instead of crashing
      return null;
    }
  }

  List<String> matchingDays(String daysString) {
    List<String> dayList = [];
    for (var day in daysString.split(',')) {
      switch (day) {
        case 'شەممە':
          dayList.add('Saturday');
        case 'یەک شەممە':
          dayList.add('Sunday');
        case 'دوو شەممە':
          dayList.add('Monday');
        case 'سێ شەممە':
          dayList.add('Tuesday');
        case 'چوار شەممە':
          dayList.add('Wednesday');
        case 'پێنج شەممە':
          dayList.add('Thursday');
        case 'هەینی':
          dayList.add('Friday');
      }
    }
    return dayList;
  }
}
