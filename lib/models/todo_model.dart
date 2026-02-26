enum TodoPriority { low, medium, high }

class ToDoModel {
  final int id;
  final String title;
  final String description;
  final TodoPriority priority;
  final DateTime? remindingDate;
  final String? repeatingDays;
  bool isCompleted;

  ToDoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.isCompleted,
    required this.remindingDate,
    required this.repeatingDays,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.index,
      'isCompleted': isCompleted ? 1 : 0,
      'remindingDate': remindingDate.toString(),
      'repeatingDays': repeatingDays,
    };
  }

  static ToDoModel fromMap(Map<String, dynamic> map) {
    return ToDoModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      priority: TodoPriority.values[map['priority']],
      isCompleted: map['isCompleted'] == 1,
      remindingDate: DateTime.tryParse(map['remindingDate']),
      repeatingDays: map['repeatingDays'],
    );
  }

  static String getFormattedDateAsString(DateTime datetime) {
    return "${datetime.day}/${datetime.month}/${datetime.year} ${datetime.hour}:${datetime.minute}";
  }

  DateTime getNextOccurrence(String dayValue) {
    final Map<String, int> weekdayMap = {
      'mon': DateTime.monday,
      'tue': DateTime.tuesday,
      'wedn': DateTime.wednesday,
      'ther': DateTime.thursday,
      'fri': DateTime.friday,
      'sat': DateTime.saturday,
      'sun': DateTime.sunday,
    };

    DateTime now = DateTime.now();
    int? targetWeekday = weekdayMap[dayValue];

    if (targetWeekday == null) return now;

    // The "+ 6) % 7 + 1" logic forces the result to be 1 to 7 days in the future.
    // This avoids returning "today" if today is Monday.
    int daysUntil = (targetWeekday - now.weekday + 6) % 7 + 1;

    // Create the date at midnight to keep it clean
    return DateTime(
      now.year,
      now.month,
      now.day,
    ).add(Duration(days: daysUntil));
  }
}

extension TodoPriorityTranslate on TodoPriority {
  /// English label
  String get en {
    switch (this) {
      case TodoPriority.low:
        return 'Low';
      case TodoPriority.medium:
        return 'Medium';
      case TodoPriority.high:
        return 'High';
    }
  }

  /// Kurdish (Sorani) label
  String get ku {
    switch (this) {
      case TodoPriority.low:
        return 'نزم';
      case TodoPriority.medium:
        return 'مامناوەند';
      case TodoPriority.high:
        return 'بەرز';
    }
  }
}
