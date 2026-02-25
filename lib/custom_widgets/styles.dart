import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/themes.dart';

Future<String> pickDate(BuildContext context) async {
  final pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(2030),
  );
  if (pickedDate == null) return '';
  final DateTime dateTime = DateTime(
    pickedDate.year,
    pickedDate.month,
    pickedDate.day,
  );

  return DateFormat('dd-MM-yyyy').format(dateTime);
}

Future<String?> pickTime(BuildContext context) async {
  final TimeOfDay? pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );
  if (pickedTime == null) return '';
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

InputDecoration getInputStyle(String hint, BuildContext context) {
  return InputDecoration(
    filled: true,
    fillColor: AppThemes.getSecondaryBg(context),
    floatingLabelBehavior: FloatingLabelBehavior.never,
    labelStyle: TextStyle(
      fontWeight: FontWeight.w400,
      fontFamily: 'DroidArabicKufi',
      fontSize: 18, // Use the custom font
    ),
    hint: Text(hint),
    errorStyle: TextStyle(color: Colors.black54),
    enabledBorder: OutlineInputBorder(
      // Border radius for enabled state
      borderSide: BorderSide(
        color: Colors.transparent,
      ), // Border color for enabled state
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.transparent,
      ), // Border color for enabled state
    ),
    focusedBorder: OutlineInputBorder(
      // Border radius for focused state
      borderSide: BorderSide(
        color: Colors.transparent,
      ), // Border color for focused state
    ),
  );
}

Widget getFormField(
  String label,
  String hint,
  TextEditingController ctor,
  BuildContext context,
  FormFieldValidator validation, {
  InputDecoration? style,
  bool readOnly = false,
  GestureTapCallback? onTap,
}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        SizedBox(height: 5),
        TextFormField(
          readOnly: readOnly,
          controller: ctor,
          onTap: onTap,
          decoration: style ?? getInputStyle(hint, context),
          validator: validation,
        ),
      ],
    ),
  );
}

Widget getDropDown(
  String label,
  String hint,
  List<DropdownMenuItem<Object>> items,
  Object initialValue,
  BuildContext context,
  ValueChanged onTap,
  FormFieldValidator validation,
) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        SizedBox(height: 5),
        DropdownButtonFormField(
          items: items,
          decoration: getInputStyle('زەروریەت', context),
          validator: validation,
          initialValue: initialValue, // Default value
          onChanged: onTap,
        ),
      ],
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
  switch (priority) {
    case TodoPriority.low:
      return AppThemes.getBlue(context);
    case TodoPriority.medium:
      return AppThemes.getGreen(context);
    case TodoPriority.high:
      return AppThemes.getOrange(context);
  }
}
