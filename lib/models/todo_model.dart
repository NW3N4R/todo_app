enum TodoPriority { low, medium, high }

class ToDoModel {
  final int id;
  final String title;
  final String description;
  final TodoPriority priority;
  final DateTime repeatDate;
  bool everyDate = false;
  bool isCompleted;

  ToDoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.isCompleted,
    required this.repeatDate,
    required this.everyDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.index,
      'isCompleted': isCompleted ? 1 : 0,
      'repeatDate': repeatDate.toString(),
      'everyDate': everyDate ? 1 : 0,
    };
  }

  static ToDoModel fromMap(Map<String, dynamic> map) {
    return ToDoModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      priority: TodoPriority.values[map['priority']],
      isCompleted: map['isCompleted'] == 1,
      repeatDate: DateTime.parse(map['repeatDate']),
      everyDate: map['everyDate'] == 1,
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
