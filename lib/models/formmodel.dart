import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/themes.dart';

mixin FormModel {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController selectedDateController = TextEditingController();
  final TextEditingController selectedTimeController = TextEditingController();
  final MultiSelectController<String> controller = MultiSelectController();
  TodoPriority priority = TodoPriority.low; // Default priority

  FormFieldValidator<dynamic> formValidator(String message) {
    return (value) {
      if (value == null || value.isEmpty) {
        return message;
      }
      return null;
    };
  }

  List<DropdownItem<String>> days = [
    DropdownItem(label: 'شەممە', value: 'شەممە'),
    DropdownItem(label: 'یەک شەممە', value: 'یەک شەممە'),
    DropdownItem(label: 'دوو شەممە', value: 'دوو شەممە'),
    DropdownItem(label: 'سێ شەممە', value: 'سێ شەممە'),
    DropdownItem(label: 'چوار شەممە', value: 'چوار شەممە'),
    DropdownItem(label: 'پێنج شەممە', value: 'پێنج شەممە'),
    DropdownItem(label: 'هەینی', value: 'هەینی'),
  ];

  DateTime? getCompleteDate(String time12h, String date) {
    try {
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

  MultiDropdown daySelector(BuildContext context, OnSelectionChanged onChange) {
    return MultiDropdown(
      items: days,
      controller: controller,
      dropdownDecoration: DropdownDecoration(
        backgroundColor: AppThemes.getSecondaryBg(context),
      ),
      onSelectionChange: onChange,
      fieldDecoration: FieldDecoration(
        hintText: 'ڕۆژەکانی هەفتە',
        labelText: 'ڕۆژەکانی هەفتە',
        labelStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontFamily: 'DroidArabicKufi',
          fontSize: 18,
        ),
        backgroundColor: AppThemes.getSecondaryBg(context),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
      ),
      chipDecoration: ChipDecoration(
        backgroundColor: Colors.transparent,
        maxDisplayCount: 0,

        wrap: false,
      ),
    );
  }
}
