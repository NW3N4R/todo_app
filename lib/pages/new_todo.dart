import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:todo_app/localnotification.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/services/current_ToDo.dart';

class NewTodo extends StatefulWidget {
  const NewTodo({super.key});

  @override
  State<NewTodo> createState() => _NewTodoState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final TextEditingController _titleController = TextEditingController();
final TextEditingController _descriptionController = TextEditingController();
final TextEditingController _selectedDateController = TextEditingController();
final TextEditingController _selectedTimeController = TextEditingController();
TodoPriority _priority = TodoPriority.low; // Default priority
final String selectTimeHolder = 'کاتی ئاگەدارکردنەوە هەڵبژێرە';
final String selectDateHolder = 'بەرواری ئاگەدارکردنەوە هەڵبژێرە';

class _NewTodoState extends State<NewTodo> {
  bool everyDate = false;
  @override
  void initState() {
    _selectedDateController.text = 'بەرواری ئاگەدارکردنەوە هەڵبژێرە';
    super.initState();
  }

  List<String> _selectedDays = [];
  final List<String> _days = [
    'شەممە',
    'یەک شەممە',
    'دوو شەممە',
    'سێ شەممە',
    'چوار شەممە',
    'پێنج شەممە',
    'هەینی شەممە',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        title: const Text(
          'ئەرکێکی نوێ دروست بکە',
          style: TextStyle(
            color: Color.fromARGB(255, 45, 186, 118),
            fontWeight: FontWeight.w800,
            fontSize: 24.0,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              flex: 2,
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.withValues(alpha: 0.29),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: _titleController,
                              decoration: getStyle('ناوی ئەرک'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'تکایە ناوی ئەرک بنووسە';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 14),
                            TextFormField(
                              controller: _descriptionController,
                              decoration: getStyle('وەسفی ئەرک'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'تکایە وەسفی ئەرک بنووسە';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 14),
                            DropdownButtonFormField(
                              items: TodoPriority.values.map((p) {
                                return DropdownMenuItem(
                                  value: p,
                                  child: Text(p.ku),
                                );
                              }).toList(),
                              decoration: getStyle('زەروریەت'),
                              validator: (value) {
                                if (value == null) {
                                  return 'تکایە پریۆریتێک دیاری بکە';
                                }
                                return null;
                              },

                              initialValue: _priority, // Default value
                              onChanged: (value) {
                                setState(() {
                                  _priority = value!;
                                });
                              },
                            ),
                            SizedBox(height: 14),
                            TextFormField(
                              controller: _selectedDateController,
                              readOnly: true,
                              decoration: getStyle('بەروار').copyWith(
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedDateController.text =
                                          selectDateHolder;
                                    });
                                  },
                                  icon: Icon(Icons.clear),
                                ),
                              ),
                              onTap: () async {
                                _selectedDateController.text = await pickDate(
                                  context,
                                );
                              },
                              validator: (value) {
                                if (value == selectDateHolder &&
                                    _selectedDays.isEmpty) {
                                  return 'یان بەروار یان ڕۆژی ئاگەدار کردنەوە داواکراوە';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 14),
                            TextFormField(
                              controller: _selectedTimeController,
                              readOnly: true,
                              decoration: getStyle('کات'),
                              onTap: () async {
                                _selectedTimeController.text = await pickTime(
                                  context,
                                );
                              },
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value == selectTimeHolder) {
                                  return 'تکایە کاتی ئاگەدارکردنەوە دیاری بکە';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 14),
                            MultiSelectDialogField<String>(
                              dialogHeight: 350,
                              chipDisplay: MultiSelectChipDisplay.none(),
                              buttonText: Text(
                                'ئاگادارکردنەوە لە ڕۆژەکانی هەفتە',
                              ),
                              buttonIcon: Icon(Icons.calendar_month),
                              items: _days
                                  .map((day) => MultiSelectItem(day, day))
                                  .toList(),
                              listType: MultiSelectListType.CHIP,
                              title: Text('ڕۆژەکانی هەفتە'),
                              validator: (value) {
                                if (_selectedDateController.text ==
                                        selectDateHolder &&
                                    _selectedDays.isEmpty) {
                                  return 'یان بەروار یان ڕۆژی ئاگەدار کردنەوە داواکراوە';
                                }

                                return null;
                              },
                              onConfirm: (values) {
                                _selectedDays = values;
                                // print("Selected: $_selectedDays");
                              },
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Color.fromARGB(105, 45, 186, 118),
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.greenAccent.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextButton.icon(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    DateFormat inputFormat = DateFormat('dd-MM-yyyy');
                    DateTime selectedDate = inputFormat.parse(
                      _selectedDateController.text,
                    );

                    // If the form is valid, save the todo
                    final todo = ToDoModel(
                      id: DateTime.now().microsecond,
                      title: _titleController.text,
                      description: _descriptionController.text,
                      priority: _priority, // Default priority
                      isCompleted: false,
                      remindingDate: selectedDate,
                      repeatingDays: _selectedDays.join(','),
                      // everyDate: everyDate,
                    );
                    CurrentTodo.createTodo(todo, context);
                    // await scheduleNotification(todo);

                    if (await CurrentTodo.createTodo(todo, context) > 0) {
                      _formKey.currentState!.reset();
                    }
                  }
                },
                icon: Icon(Icons.done, color: Colors.white, size: 30),
                label: Text(
                  'وەرگرتن',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<String> pickDate(BuildContext context) async {
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

Future<String> pickTime(BuildContext context) async {
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
  final String period = pickedTime.period == DayPeriod.am ? 'AM' : 'PM';
  return '${time.hour}:${time.minute} $period';
}

InputDecoration getStyle(String labelText) {
  return InputDecoration(
    labelText: labelText,
    filled: true,
    fillColor: Colors.white,
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    labelStyle: TextStyle(
      color: Colors.black, // Foreground color for the label
      fontWeight: FontWeight.w400,
      fontFamily: 'DroidArabicKufi', // Use the custom font
    ),
    errorStyle: TextStyle(color: Colors.black54),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(8.0),
      ), // Border radius for enabled state
      borderSide: BorderSide(
        color: Color.fromARGB(105, 45, 186, 118),
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
