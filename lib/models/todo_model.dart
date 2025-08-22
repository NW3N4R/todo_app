enum Priority { low, medium, high }

class ToDoModel {
  final String id;
  final String title;
  final String description;
  final Priority priority;
  bool isCompleted;

  ToDoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.index,
      'isCompleted': isCompleted ? 1 : 0, // Convert bool to int for SQLite
    };
  }

  static ToDoModel fromMap(Map<String, dynamic> map) {
    return ToDoModel(
      id: map['id'].toString(),
      title: map['title'],
      description: map['description'],
      priority: Priority.values[map['priority']],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
