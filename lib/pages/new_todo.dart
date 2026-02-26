import 'package:flutter/material.dart';
import 'package:todo_app/l10n/app_localizations.dart';
import 'package:todo_app/services/localnotification.dart';
import 'package:todo_app/styles.dart';
import 'package:todo_app/models/formModel.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/services/todoservice.dart';

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
      TodoService.createTodo(todo, context);
      late DateTime? notifyingDate;
      if (todo.remindingDate != null) {
        notifyingDate = todo.remindingDate;
      } else {
        String firstDay = todo.repeatingDays!.split(',')[0];
        notifyingDate = todo.getNextOccurrence(firstDay);
      }
      await scheduleNotification(
        todo.id,
        todo.title,
        todo.description,
        notifyingDate!,
      );
      if (await TodoService.createTodo(todo, context) > 0) {
        formKey.currentState!.reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          t.newTodo,
          style: TextStyle(
            fontWeight: FontWeight.w500,
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
                              t.nameOfTodo,
                              titleController,
                              context,
                              formValidator(t.todoNameReq),
                              prefixIcon: Icons.task,
                              // prefixIcon: Icons.local_activity,
                            ),
                            getFormField(
                              t.descOfTodo,
                              descriptionController,
                              context,
                              formValidator(t.todoDescReq),
                              prefixIcon: Icons.description,
                            ),
                            getDropDown(
                              t.priority,
                              t.priority,
                              TodoPriority.values.map((p) {
                                return DropdownMenuItem(
                                  value: p,
                                  child: Text(
                                    t.localeName == 'en' ? p.en : p.ku,
                                  ),
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
                              t.dateOfNotification,
                              selectedDateController,
                              context,
                              (value) {
                                if (value == '' && _selectedDays.isEmpty) {
                                  return t.dateOrWeekDay;
                                }
                                return null;
                              },
                              style:
                                  getInputStyle(
                                    t.dateOfNotification,
                                    context,
                                  ).copyWith(
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
                              t.timeofNotification,
                              selectedTimeController,
                              context,
                              formValidator(t.timeOfTodoRequired),
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
            primaryButton(t.accept, post, context),
          ],
        ),
      ),
    );
  }
}
