import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/themes.dart';

Future<String> pickDate(BuildContext context) async {
  String selectDateHolder = 'بەرواری ئاگەدارکردنەوە هەڵبژێرە';
  final pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(2030),
  );
  if (pickedDate == null) return selectDateHolder;
  final DateTime dateTime = DateTime(
    pickedDate.year,
    pickedDate.month,
    pickedDate.day,
  );

  return DateFormat('dd-MM-yyyy').format(dateTime);
}

Future<String?> pickTime(BuildContext context) async {
  String? selectTimeHolder;
  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );
  if (pickedTime == null) return selectTimeHolder;
  final DateTime time = DateTime(
    2026,
    1,
    1,
    pickedTime.hour,
    pickedTime.minute,
  );
  int hour12 = time.hour % 12 == 0 ? 12 : time.hour % 12;
  final String period = pickedTime.period == DayPeriod.am ? 'AM' : 'PM';
  return '$hour12:${time.minute} $period';
}

InputDecoration getStyle(String labelText, BuildContext context) {
  return InputDecoration(
    labelText: labelText,
    filled: false,
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    labelStyle: TextStyle(
      fontWeight: FontWeight.w400,
      fontFamily: 'DroidArabicKufi',
      fontSize: 16, // Use the custom font
    ),
    errorStyle: TextStyle(color: Colors.black54),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(8.0),
      ), // Border radius for enabled state
      borderSide: BorderSide(
        color: AppThemes.getPrimaryColor(context).withAlpha(200),
      ), // Border color for enabled state
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(8.0),
      ), // Border radius for enabled state
      borderSide: BorderSide(
        color: Color.fromARGB(105, 255, 126, 126),
      ), // Border color for enabled state
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ), // Border radius for focused state
      borderSide: BorderSide(
        color: Color.fromARGB(155, 45, 186, 118),
      ), // Border color for focused state
    ),
  );
}

BoxDecoration getContainerStyleAsInput(BuildContext context) {
  return BoxDecoration(
    color: AppThemes.getPrimaryColor(context).withAlpha(50),
    borderRadius: BorderRadius.circular(8.0),
    border: Border.all(color: AppThemes.getPrimaryColor(context)),
  );
}

Widget primaryButton(
  String text,
  VoidCallback onPressed,
  BuildContext context, {
  IconData? icon,
}) {
  return ElevatedButton.icon(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: AppThemes.getPrimaryColor(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    ),
    icon: Icon(icon ?? Icons.check, color: Colors.white),
    label: Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontFamily: 'DroidArabicKufi',
        fontSize: 16,
        color: Colors.white,
      ),
    ),
  );
}

Color cardBackColor(TodoPriority priority, BuildContext context) {
  bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
  List<Color> colors = isDarkMode
      ? AppColors.primaryDarkColors
      : AppColors.primaryLightColors;
  switch (priority) {
    case TodoPriority.low:
      return colors[2];
    case TodoPriority.medium:
      return colors[1];
    case TodoPriority.high:
      return colors[0];
  }
}
