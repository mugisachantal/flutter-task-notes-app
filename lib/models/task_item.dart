class TaskItem {
  final int? id;
  final String title;
  final String priority; // e.g., Low, Medium, High
  final String description;
  final bool isCompleted;

  const TaskItem({
    this.id,
    required this.title,
    required this.priority,
    required this.description,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'priority': priority,
      'description': description,
      'isCompleted': isCompleted,
    };
  }

  factory TaskItem.fromJson(Map<String, dynamic> json) {
    final rawCompleted = json['isCompleted'];
    bool completed;
    if (rawCompleted is int) {
      completed = rawCompleted == 1;
    } else if (rawCompleted is bool) {
      completed = rawCompleted;
    } else if (rawCompleted is String) {
      completed = rawCompleted.toLowerCase() == 'true' || rawCompleted == '1';
    } else {
      completed = false;
    }

    return TaskItem(
      id: json['id'] as int?,
      title: (json['title'] as String?)?.trim() ?? '',
      priority: (json['priority'] as String?)?.trim() ?? 'Low',
      description: (json['description'] as String?)?.trim() ?? '',
      isCompleted: completed,
    );
  }
}
