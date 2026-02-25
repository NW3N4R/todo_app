import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:todo_app/custom_widgets/styles.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/services/current_ToDo.dart';
import 'package:todo_app/models/formmodel.dart';
import 'package:todo_app/themes.dart';

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

      // if (await CurrentTodo.createTodo(todo, context) > 0) {
      //   formKey.currentState!.reset();
      // }
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
                          'ناوی ئەرکەکەت',
                          titleController,
                          context,
                          (value) {
                            if (value == null || value.isEmpty) {
                              return 'تکایە ناوی ئەرک بنووسە';
                            }
                            return null;
                          },
                        ),
                        getFormField(
                          'وەسفی ئەرک',
                          'وەسفی ئەرک',
                          descriptionController,
                          context,
                          (value) {
                            if (value == null || value.isEmpty) {
                              return 'تکایە وەسفی ئەرک بنووسە';
                            }
                            return null;
                          },
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
                          (value) {
                            if (value == null) {
                              return 'تکایە پریۆریتێک دیاری بکە';
                            }
                            return null;
                          },
                        ),
                        getFormField(
                          'بەرواری ئاگەدار کردنەوە',
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
                          'کاتی ئاگەدار کردنەوە',
                          selectedTimeController,
                          context,
                          (value) {
                            if (value == null || value.isEmpty) {
                              return 'تکایە کاتی ئاگەدارکردنەوە دیاری بکە';
                            }
                            return null;
                          },
                          readOnly: true,
                          onTap: () async {
                            selectedTimeController.text =
                                await pickTime(context) ?? '';
                          },
                        ),
                        MultiSelectDialogField<String>(
                          initialValue: _selectedDays,
                          selectedItemsTextStyle: TextStyle(
                            color: AppThemes.getPrimaryColor(context),
                            fontWeight: FontWeight.bold,
                          ),

                          selectedColor: AppThemes.getPrimaryColor(
                            context,
                          ).withAlpha(50),
                          chipDisplay: MultiSelectChipDisplay.none(),
                          buttonText: Text('ئاگادارکردنەوە لە ڕۆژەکانی هەفتە'),
                          buttonIcon: Icon(Icons.calendar_month),
                          items: days
                              .map((day) => MultiSelectItem(day, day))
                              .toList(),
                          listType: MultiSelectListType.CHIP,
                          title: Text('ڕۆژەکانی هەفتە'),
                          validator: (value) {
                            if (selectedDateController.text == '' &&
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
