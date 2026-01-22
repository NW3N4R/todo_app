import 'package:flutter/material.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/services/current_ToDo.dart';

class UpdateTodo extends StatefulWidget {
  final ToDoModel modelToUpdate;
  const UpdateTodo(this.modelToUpdate, {super.key});

  @override
  State<UpdateTodo> createState() => _UpdateTodoState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final TextEditingController _titleController = TextEditingController();
final TextEditingController _descriptionController = TextEditingController();
TodoPriority _priority = TodoPriority.low; // Default priority

class _UpdateTodoState extends State<UpdateTodo> {
  late DateTime? selectedDate;
  bool everyDate = false;
  late ToDoModel todo;
  @override
  void initState() {
    todo = widget.modelToUpdate;
    _titleController.text = todo.title;
    _descriptionController.text = todo.description;
    selectedDate = todo.repeatDate;
    everyDate = todo.everyDate;
    _priority = todo.priority;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<DateTime?> pickDate() async {
      final pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );
      setState(() {
        if (pickedDate != null) {
          selectedDate = pickedDate;
        } else {
          selectedDate = null;
        }
      });
      return pickedDate;
    }

    return Scaffold(
      appBar: AppBar(title: Text(todo.title)),
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
                      decoration: getStyle('Title'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 14),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: getStyle('Description'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 14),
                    DropdownButtonFormField(
                      items: TodoPriority.values.map((p) {
                        return DropdownMenuItem(value: p, child: Text(p.name));
                      }).toList(),
                      decoration: getStyle('Priority'),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a priority';
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
                    Text('Repeating Date', textAlign: TextAlign.start),
                    TextButton(
                      onPressed: () => pickDate(),
                      child: Text(
                        selectedDate.toString(),
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    CheckboxListTile(
                      title: const Text('Repeat Every Selected Day'),
                      controlAffinity: ListTileControlAffinity.leading,
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
                      final model = ToDoModel(
                        id: todo.id,
                        title: _titleController.text,
                        description: _descriptionController.text,
                        priority: _priority, // Default priority
                        isCompleted: todo.isCompleted,
                        repeatDate: selectedDate!,
                        everyDate: everyDate,
                      );
                      if (await CurrentTodo.updateTodo(model, context)) {
                        _formKey.currentState!.reset();
                      }
                    }
                  },
                  icon: Icon(Icons.done, color: Colors.white, size: 30),
                  label: Text(
                    'Update Todo',
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
