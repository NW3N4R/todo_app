enum Priority { low, medium, high }

class ToDoModel {
  final String id;
  final String title;
  final String description;
  final Priority priority;
  final String repeatDate;
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
      id: map['id'].toString(),
      title: map['title'],
      description: map['description'],
      priority: Priority.values[map['priority']],
      isCompleted: map['isCompleted'] == 1,
      repeatDate: map['repeatDate'],
      everyDate: map['everyDate'] == 1,
    );
  }
}
