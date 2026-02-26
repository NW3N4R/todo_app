import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:todo_app/l10n/app_localizations.dart';
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
    DropdownItem(label: 'شەممە', value: 'sat'),
    DropdownItem(label: 'یەک شەممە', value: 'sun'),
    DropdownItem(label: 'دوو شەممە', value: 'mon'),
    DropdownItem(label: 'سێ شەممە', value: 'tue'),
    DropdownItem(label: 'چوار شەممە', value: 'wedn'),
    DropdownItem(label: 'پێنج شەممە', value: 'ther'),
    DropdownItem(label: 'هەینی', value: 'fri'),
  ];
  List<DropdownItem<String>> daysEn = [
    DropdownItem(label: 'Saturday', value: 'sat'),
    DropdownItem(label: 'Sunday', value: 'sun'),
    DropdownItem(label: 'Monday', value: 'mon'),
    DropdownItem(label: 'Tuesday', value: 'tue'),
    DropdownItem(label: 'Wednesday', value: 'wedn'),
    DropdownItem(label: 'Thersday', value: 'ther'),
    DropdownItem(label: 'Friday', value: 'fri'),
  ];
  DateTime? getCompleteDate(String time12h, String date) {
    try {
      return DateFormat("dd-MM-yyyy hh:mm a").parse("$date $time12h");
    } catch (e) {
      // Returns null if the format is wrong instead of crashing
      return null;
    }
  }

  MultiDropdown daySelector(BuildContext context, OnSelectionChanged onChange) {
    final t = AppLocalizations.of(context)!;

    return MultiDropdown(
      items: t.localeName == "ar" ? days : daysEn,
      controller: controller,
      dropdownDecoration: DropdownDecoration(
        backgroundColor: AppThemes.getSecondaryBg(context),
      ),
      onSelectionChange: onChange,
      fieldDecoration: FieldDecoration(
        hintText: t.daysOfWeek,
        labelText: t.daysOfWeek,
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
