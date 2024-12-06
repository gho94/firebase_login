class Todo {
  final String? id;
  final String title;
  final bool isCompleted;

  Todo({
    this.id,
    required this.title,
    required this.isCompleted,
  });

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map["id"],
      title: map["title"],
      isCompleted: map["isCompleted"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "isCompleted": isCompleted,
    };
  }

  Todo copyWith({
    String? id,
    String? title,
    bool? isCompleted,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
