import 'package:flutter/material.dart';
import 'package:todo_app/l10n/app_localizations.dart';
import 'package:todo_app/models/formModel.dart';
import 'package:todo_app/models/searchmodel.dart';
import 'package:todo_app/pages/update.dart';
import 'package:todo_app/services/todoservice.dart';
import 'package:todo_app/styles.dart';
import 'package:todo_app/themes.dart';

class TodoView extends StatefulWidget {
  const TodoView({super.key});

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> with FormModel, SearchModel {
  void load() async {
    await search();
    setState(() {});
  }

  @override
  void initState() {
    load();
    super.initState();
  }

  void showSearchSheet() {
    final t = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppThemes.getPrimaryBg(
        context,
      ), // Allows the sheet to expand higher if needed
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SafeArea(
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
                return Container(
                  padding: EdgeInsets.all(16),
                  // 50% of screen height
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        getFormField(
                          t.search,
                          textSearcher,
                          context,
                          (vale) => null,
                        ),

                        SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: SegmentedButton(
                            style: SegmentedButton.styleFrom(
                              side: BorderSide.none, // Keep borders hidden
                              // This removes the rounded corners
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                            segments: [
                              ButtonSegment(
                                value: 'Active',
                                label: Text(
                                  t.active,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                              ButtonSegment(
                                value: 'Overdue',
                                label: Text(
                                  t.overDue,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                              ButtonSegment(
                                value: 'Completed',
                                label: Text(
                                  t.completed,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ],
                            multiSelectionEnabled: true,
                            selected: selection,
                            onSelectionChanged: (newSelection) {
                              setModalState(() {
                                selection = newSelection;
                              });
                              search();
                              setState(() {});
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () async {
                                await search();
                                setState(() {});
                                // Navigator.pop(context);
                              },
                              child: Text(
                                t.search,
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(
                                      color: AppThemes.getPrimaryColor(context),
                                    ),
                              ),
                            ),
                            SizedBox(width: 20),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                t.cancel,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: Text(t.myTodos, style: Theme.of(context).textTheme.bodyMedium),
        actions: [
          IconButton(
            onPressed: showSearchSheet,
            icon: Icon(Icons.search, color: AppThemes.getPrimaryColor(context)),
          ),
        ],
      ),
      body: SafeArea(
        child: (viewList.isEmpty)
            ? Center(child: Text(t.noDataFound))
            : RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(
                    Duration(seconds: 1),
                  ); // Simulate a delay for refreshing
                  await search();
                },
                child: ListView.builder(
                  itemCount: viewList.length,
                  itemBuilder: (context, index) {
                    final todo = viewList[index];
                    return Dismissible(
                      direction: DismissDirection.endToStart,
                      key: ValueKey(viewList[index].id), // Unique key per item
                      onDismissed: (direction) {
                        setState(() {
                          viewList.removeAt(index); // remove from list
                        });
                        TodoService.deleteTodo(
                          todo.id,
                          context,
                        ); // remove from DB
                      },
                      background: Container(
                        margin: const EdgeInsets.all(8),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        alignment: t.localeName == 'en'
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Icon(Icons.delete, color: Colors.red),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          // color: cardBackColor(fetchedTodos[index].priority, context),
                          color: AppThemes.getSecondaryBg(context),
                          borderRadius: BorderRadius.circular(8),
                          border: Border(
                            left: BorderSide(
                              color: cardBackColor(
                                viewList[index].priority,
                                context,
                              ),
                              width: 4,
                            ),
                          ),
                        ),
                        child: InkWell(
                          child: ListTile(
                            title: Text(
                              viewList[index].title,
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w400,
                                color: AppThemes.isDarkMode(context)
                                    ? AppThemes.getPrimaryColor(context)
                                    : Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              viewList[index].description,
                              style: TextStyle(fontSize: 22),
                            ),
                          ),
                          onLongPress: () {
                            setState(() {
                              viewList[index].isCompleted =
                                  !viewList[index].isCompleted;
                              TodoService.updateTodo(viewList[index], context);
                            });
                            load();
                          },
                          onDoubleTap: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    UpdateTodo(viewList[index]),
                              ),
                            ),
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
