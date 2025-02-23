class Task {
  int? id;
  String text;

  Task({this.id, required this.text});

  // Convert a Task object into a Map object for database insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
    };
  }

  // Convert a Map object into a Task object (for reading data from the database)
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      text: map['text'],
    );
  }
}
