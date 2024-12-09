class TodoTest {
  final String id;
  final String title;
  final bool isCompleted;

  TodoTest({
    required this.id,
    required this.title,
    required this.isCompleted,
  });

  factory TodoTest.fromMap(Map<String, dynamic> map, String id) {
    return TodoTest(
      id: id,
      title: map["title"],
      isCompleted: map["isCompleted"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "isCompleted": isCompleted,
    };
  }

  TodoTest copyWith({
    String? id,
    String? title,
    bool? isCompleted,
  }) {
    return TodoTest(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
