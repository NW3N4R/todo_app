import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:todo_app/custom_widgets/styles.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/services/current_ToDo.dart';
import 'package:todo_app/models/formmodel.dart';

class UpdateTodo extends StatefulWidget {
  final ToDoModel modelToUpdate;
  const UpdateTodo(this.modelToUpdate, {super.key});

  @override
  State<UpdateTodo> createState() => _UpdateTodoState();
}

class _UpdateTodoState extends State<UpdateTodo> with FormModel {
  List<String> _selectedDays = [];

  late DateTime? selectedDate;
  bool everyDate = false;
  late ToDoModel todo;
  @override
  void initState() {
    todo = widget.modelToUpdate;
    titleController.text = todo.title;
    descriptionController.text = todo.description;
    selectedDate = todo.remindingDate;
    priority = todo.priority;
    selectedDateController.text = todo.remindingDate != null
        ? DateFormat('dd-MM-yyyy').format(todo.remindingDate!)
        : '';

    selectedTimeController.text = todo.remindingDate != null
        ? DateFormat('hh:mm a').format(todo.remindingDate!)
        : '';

    _selectedDays = todo.repeatingDays != null
        ? todo.repeatingDays!.split(',').map((day) => day.trim()).toList()
        : [];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.selectWhere((item) {
        return todo.repeatingDays!.split(',').contains(item.label);
      });
    });
    super.initState();
  }

  void post() async {
    if (formKey.currentState!.validate()) {
      DateFormat inputFormat = DateFormat('dd-MM-yyyy');
      DateTime selectedDate = inputFormat.parse(selectedDateController.text);
      // If the form is valid, save the todo
      final todo = ToDoModel(
        id: widget.modelToUpdate.id,
        title: titleController.text,
        description: descriptionController.text,
        priority: priority, // Default priority
        isCompleted: false,
        remindingDate: selectedDate,
        repeatingDays: _selectedDays.join(','),
        // everyDate: everyDate,
      );
      CurrentTodo.updateTodo(todo, context);
      // await scheduleNotification(todo);
      print(_selectedDays.join(','));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'نوێ کردنەوە',
          style: TextStyle(
            fontWeight: FontWeight.w200,
            fontSize: 20.0,
            fontFamily: 'DroidArabicKufi',
          ),
        ),
      ),
      body: SafeArea(
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              flex: 2,
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        getFormField(
                          'ناوی ئەرک',
                          titleController,
                          context,
                          formValidator('تکایە ناوی ئەرک بنووسە'),
                          prefixIcon: Icons.task,
                          // prefixIcon: Icons.local_activity,
                        ),
                        getFormField(
                          'وەسفی ئەرک',
                          descriptionController,
                          context,
                          formValidator('تکایە وەسفی ئەرک بنووسە'),
                          prefixIcon: Icons.description,
                        ),
                        getDropDown(
                          'زەروریەت',
                          'گرنگی ئەرکەکەت',
                          TodoPriority.values.map((p) {
                            return DropdownMenuItem(
                              value: p,
                              child: Text(p.ku),
                            );
                          }).toList(),
                          priority,
                          context,
                          (value) {
                            setState(() {
                              priority = value!;
                            });
                          },
                          prefixIcon: Icons.label_important,
                        ),
                        getFormField(
                          'بەرواری ئاگەدار کردنەوە',
                          selectedDateController,
                          context,
                          (value) {
                            if (value == '' && _selectedDays.isEmpty) {
                              return 'یان بەروار یان ڕۆژی ئاگەدار کردنەوە داواکراوە';
                            }
                            return null;
                          },
                          style: getInputStyle('بەروار', context).copyWith(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  selectedDateController.text = '';
                                });
                              },
                              icon: Icon(Icons.clear),
                            ),
                            prefixIcon: Icon(Icons.access_time_filled),
                          ),
                          readOnly: true,
                          onTap: () async {
                            selectedDateController.text = await pickDate(
                              context,
                            );
                          },
                        ),
                        getFormField(
                          'کاتی ئاگەدار کردنەوە',
                          selectedTimeController,
                          context,
                          formValidator('تکایە کاتی ئاگەدارکردنەوە دیاری بکە'),
                          readOnly: true,
                          onTap: () async {
                            selectedTimeController.text =
                                await pickTime(context) ?? '';
                          },
                          prefixIcon: Icons.access_time_filled_sharp,
                        ),
                        SizedBox(height: 15),
                        daySelector(context, (selectedItems) {
                          setState(() {
                            _selectedDays = selectedItems
                                .map((x) => x.toString())
                                .toList();
                          });
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            primaryButton('وەرگرتن', post, context),
          ],
        ),
      ),
    );
  }
}
