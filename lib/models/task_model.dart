class TaskModel {
  final String? id;
  final String title;
  final String description;
  final String category;
  final String priority;
  final DateTime dueDate;
  final bool isCompleted;

  TaskModel({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.dueDate,
    this.isCompleted = false,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id']?.toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'Umum',
      priority: json['priority'] ?? 'Medium',
      dueDate: DateTime.parse(json['due_date']),
      isCompleted: json['is_completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'title': title,
      'description': description,
      'category': category,
      'priority': priority,
      'due_date': dueDate.toIso8601String(),
      'is_completed': isCompleted,
    };
    if (id != null) {
      data['id'] = id;
    }
    return data;
  }
}