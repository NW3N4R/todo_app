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
      remindingDate: DateTime.parse(map['remindingDate']),
      repeatingDays: map['repeatingDays'],
    );
  }

  static String getFormattedDateAsString(DateTime datetime) {
    return "${datetime.day}/${datetime.month}/${datetime.year} ${datetime.hour}:${datetime.minute}";
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
