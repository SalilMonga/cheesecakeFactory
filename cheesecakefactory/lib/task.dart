class Task {
  final int? id;
  final String text;

  Task({this.id, required this.text});

  factory Task.fromMap(Map<String, dynamic> json) => Task(
        id: json['id'],
        text: json['text'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
    };
  }
}
