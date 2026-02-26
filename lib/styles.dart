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

InputDecoration getInputStyle(
  String hint,
  BuildContext context, {
  IconData? prefixIcon,
  IconData? suffixIcon,
  VoidCallback? onSuffixTap,
}) {
  return InputDecoration(
    filled: true,
    fillColor: AppThemes.getSecondaryBg(context),

    floatingLabelBehavior: FloatingLabelBehavior.never,
    prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
    suffixIcon: suffixIcon != null
        ? IconButton(onPressed: onSuffixTap, icon: Icon(suffixIcon))
        : null,
    labelStyle: TextStyle(
      fontWeight: FontWeight.w400,
      fontFamily: 'DroidArabicKufi',
      fontSize: 18, // Use the custom font
    ),
    hint: Text(hint),
    errorStyle: TextStyle(
      color: const Color.fromARGB(255, 159, 98, 98),
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
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
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent),
    ),
  );
}

Widget getFormField(
  String label,
  TextEditingController ctor,
  BuildContext context,
  FormFieldValidator validation, {
  String? hint,
  InputDecoration? style,
  bool readOnly = false,
  GestureTapCallback? onTap,
  IconData? prefixIcon,
  IconData? suffixIcon,
  VoidCallback? onPostTap,
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
          style: Theme.of(context).textTheme.bodyMedium,
          decoration:
              style ??
              getInputStyle(
                hint ?? label,
                context,
                suffixIcon: suffixIcon,
                prefixIcon: prefixIcon,
                onSuffixTap: onPostTap,
              ),
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
  ValueChanged onTap, {
  IconData? prefixIcon,
}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        SizedBox(height: 5),
        DropdownButtonFormField(
          items: items,
          decoration: getInputStyle(
            'زەروریەت',
            context,
          ).copyWith(prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null),
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
  return Container(
    margin: EdgeInsets.symmetric(vertical: 12),
    child: ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppThemes.getPrimaryColor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      icon: Icon(icon ?? Icons.check, color: Colors.black),
      label: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontFamily: 'DroidArabicKufi',
          fontSize: 16,
          color: Colors.black,
        ),
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
