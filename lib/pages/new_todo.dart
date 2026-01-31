import 'package:flutter/material.dart';
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
TodoPriority _priority = TodoPriority.low; // Default priority

class _NewTodoState extends State<NewTodo> {
  DateTime? selectedDate;
  bool everyDate = false;
  @override
  Widget build(BuildContext context) {
    Future<DateTime?> pickDate() async {
      final pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2030),
      );
      if (pickedDate == null) return null;

      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time == null) return null;
      final DateTime dateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        time.hour,
        time.minute,
      );
      setState(() {
        selectedDate = dateTime;
      });
      return dateTime;
    }

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
        child: Form(
          key: _formKey,
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
                        return DropdownMenuItem(value: p, child: Text(p.ku));
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
                    Text('بەرواری ئەنجام دان', textAlign: TextAlign.start),
                    TextButton(
                      onPressed: () => pickDate(),
                      child: Text(
                        selectedDate != null
                            ? ToDoModel.getFormattedDateAsString(selectedDate!)
                            : 'بەروار هەڵبژێرە',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    CheckboxListTile(
                      title: const Text('دووبارەکردنەوە'),
                      controlAffinity: ListTileControlAffinity.trailing,
                      value: everyDate,
                      onChanged: (value) {
                        setState(() {
                          everyDate = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: Colors.greenAccent.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextButton.icon(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, save the todo
                      final todo = ToDoModel(
                        id: DateTime.now().microsecond,
                        title: _titleController.text,
                        description: _descriptionController.text,
                        priority: _priority, // Default priority
                        isCompleted: false,
                        repeatDate: selectedDate!,
                        everyDate: everyDate,
                      );

                      await scheduleNotification(todo);

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
      ),
    );
  }
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

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(8.0),
      ), // Border radius for enabled state
      borderSide: BorderSide(
        color: Color.fromARGB(105, 45, 186, 118),
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
