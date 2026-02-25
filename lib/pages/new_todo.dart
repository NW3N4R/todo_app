import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:todo_app/custom_widgets/styles.dart';
import 'package:todo_app/models/formModel.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/services/current_ToDo.dart';
import 'package:todo_app/themes.dart';

class NewTodo extends StatefulWidget {
  const NewTodo({super.key});

  @override
  State<NewTodo> createState() => _NewTodoState();
}

class _NewTodoState extends State<NewTodo> with FormModel {
  List<String> _selectedDays = [];
  bool everyDate = false;
  @override
  void initState() {
    super.initState();
  }

  void post() async {
    if (formKey.currentState!.validate()) {
      // If the form is valid, save the todo
      final todo = ToDoModel(
        id: DateTime.now().microsecond,
        title: titleController.text,
        description: descriptionController.text,
        priority: priority, // Default priority
        isCompleted: false,
        remindingDate: getCompleteDate(
          selectedTimeController.text,
          selectedDateController.text,
        ),
        repeatingDays: _selectedDays.join(','),
        // everyDate: everyDate,
      );
      CurrentTodo.createTodo(todo, context);
      // await scheduleNotification(todo);
      if (await CurrentTodo.createTodo(todo, context) > 0) {
        formKey.currentState!.reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          'ئەرکێکی نوێ',
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
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                              formValidator(
                                'تکایە کاتی ئاگەدارکردنەوە دیاری بکە',
                              ),
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
                    ],
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
