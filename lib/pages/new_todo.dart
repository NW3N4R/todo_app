import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    selectedDateController.text = 'بەرواری ئاگەدارکردنەوە هەڵبژێرە';
    super.initState();
  }

  void post() async {
    if (formKey.currentState!.validate()) {
      DateFormat inputFormat = DateFormat('dd-MM-yyyy');
      DateTime selectedDate = inputFormat.parse(selectedDateController.text);
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
        centerTitle: true,
        title: Text(
          'ئەرکێکی نوێ دروست بکە',
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
                            TextFormField(
                              controller: titleController,
                              decoration: getStyle('ناوی ئەرک', context),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'تکایە ناوی ئەرک بنووسە';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 14),
                            TextFormField(
                              controller: descriptionController,
                              decoration: getStyle('وەسفی ئەرک', context),
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
                              decoration: getStyle('زەروریەت', context),
                              validator: (value) {
                                if (value == null) {
                                  return 'تکایە پریۆریتێک دیاری بکە';
                                }
                                return null;
                              },

                              initialValue: priority, // Default value
                              onChanged: (value) {
                                setState(() {
                                  priority = value!;
                                });
                              },
                            ),
                            SizedBox(height: 14),
                            TextFormField(
                              controller: selectedDateController,
                              readOnly: true,
                              decoration: getStyle('بەروار', context).copyWith(
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedDateController.text =
                                          selectDateHolder;
                                    });
                                  },
                                  icon: Icon(Icons.clear),
                                ),
                              ),
                              onTap: () async {
                                selectedDateController.text = await pickDate(
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
                              controller: selectedTimeController,
                              readOnly: true,
                              decoration: getStyle('کات', context),
                              onTap: () async {
                                selectedTimeController.text =
                                    await pickTime(context) ?? '';
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
                              selectedItemsTextStyle: TextStyle(
                                color: AppThemes.getPrimaryColor(context),
                                fontWeight: FontWeight.bold,
                              ),

                              selectedColor: AppThemes.getPrimaryColor(
                                context,
                              ).withAlpha(50),
                              chipDisplay: MultiSelectChipDisplay.none(),
                              buttonText: Text(
                                'ئاگادارکردنەوە لە ڕۆژەکانی هەفتە',
                              ),
                              buttonIcon: Icon(Icons.calendar_month),
                              items: days
                                  .map((day) => MultiSelectItem(day, day))
                                  .toList(),
                              listType: MultiSelectListType.CHIP,
                              title: Text('ڕۆژەکانی هەفتە'),
                              validator: (value) {
                                if (selectedDateController.text ==
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
                              confirmText: Text(
                                'وەرگرتن',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              cancelText: Text(
                                'پاشگەزبونەوە',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondary, // Dynamic Secondary
                                ),
                              ),
                              decoration: getContainerStyleAsInput(context),
                            ),
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
