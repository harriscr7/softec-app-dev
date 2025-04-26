class Task {
  final String id;
  final String title;
  final String? description;
  final DateTime dueDate;
  final String category;
  final bool isCompleted;
  final String? moodTag;
  final bool isRecurring;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.dueDate,
    required this.category,
    this.isCompleted = false,
    this.moodTag,
    this.isRecurring = false,
    required this.createdAt,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'category': category,
      'isCompleted': isCompleted,
      'moodTag': moodTag,
      'isRecurring': isRecurring,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create from Firestore data
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      category: map['category'],
      isCompleted: map['isCompleted'] ?? false,
      moodTag: map['moodTag'],
      isRecurring: map['isRecurring'] ?? false,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
