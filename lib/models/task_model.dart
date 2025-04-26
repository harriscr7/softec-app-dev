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

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    String? category,
    bool? isCompleted,
    String? moodTag,
    bool? isRecurring,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      moodTag: moodTag ?? this.moodTag,
      isRecurring: isRecurring ?? this.isRecurring,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
