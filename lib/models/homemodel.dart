import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/services/todoservice.dart';

mixin HomeModel {
  List<ToDoModel> allTodos = [];
  Future load() async {
    allTodos = await TodoService.readTodos();
  }

  double remainingTodos() {
    if (allTodos.isEmpty) return 0.0;
    return activeTodos() / allTodos.length;
  }

  int activeTodos() {
    return allTodos.where((x) {
      bool matchesStatus = false;
      if (x.repeatingDays != null && !x.isCompleted) {
        matchesStatus = true;
      }

      if (x.remindingDate != null &&
          x.remindingDate!.isAfter(DateTime.now()) &&
          !x.isCompleted) {
        matchesStatus = true;
      }
      return matchesStatus;
    }).length;
  }

  int completedTodos() {
    return allTodos.where((x) => x.isCompleted).length;
  }

  int overDueTodos() {
    return allTodos.where((x) {
      if (!x.isCompleted && x.remindingDate != null) {
        if (x.remindingDate!.isBefore(DateTime.now())) {
          return true;
        }
      }
      return false;
    }).length;
  }

  List<ToDoModel> todosOfThisWeek() {
    final now = DateTime.now();

    final startOfToday = DateTime(now.year, now.month, now.day);

    // Sat=0 ... Fri=6
    final int todayIndex = now.weekday % 7;
    final int daysUntilFriday = 6 - todayIndex;

    final endOfThisWeek = startOfToday.add(
      Duration(days: daysUntilFriday, hours: 23, minutes: 59, seconds: 59),
    );
    List<ToDoModel> tempList = [];
    for (var x in allTodos) {
      if (tempList.length == 3) break;
      bool isScheduled = false;
      bool isDateInWeek = false;

      // Repeating days
      if (x.repeatingDays != null && x.repeatingDays!.isNotEmpty) {
        final selectedDays = x.repeatingDays!.split(',');
        isScheduled = selectedDays.any((sd) {
          final dayIndex = _daysToEn.indexOf(sd.trim());
          if (dayIndex == -1) return false;
          return dayIndex >= todayIndex;
        });
      }

      // Specific date
      if (x.remindingDate != null) {
        isDateInWeek =
            !x.remindingDate!.isBefore(startOfToday) &&
            !x.remindingDate!.isAfter(endOfThisWeek);
      }

      if (isScheduled || isDateInWeek) {
        tempList.add(x);
      }
    }
    return tempList;
  }

  final List<String> _daysToEn = [
    'شەممە',
    'یەک شەممە',
    'دوو شەممە',
    'سێ شەممە',
    'چوار شەممە',
    'پێنج شەممە',
    'هەینی',
  ];
  int getRemainingDaysInWeek() {
    DateTime now = DateTime.now();

    // DateTime.weekday: Mon=1, Tue=2, Wed=3, Thu=4, Fri=5, Sat=6, Sun=7
    // We want: Sat=0, Sun=1, Mon=2, Tue=3, Wed=4, Thu=5, Fri=6
    // More elegant way to shift:
    // (currentWeekday + 1) % 7 gives Sat=0, Sun=1, etc.
    int indexFromSaturday = (now.weekday + 1) % 7;

    // Remaining days (7 total days minus the index of today)
    // If today is Saturday (0), 7 - 0 = 7 days remaining (including today)
    // If you want "days left after today", subtract 1.
    return 6 - indexFromSaturday;
  }
}
