class TaskDB {
  final int? id;
  final String text;

  TaskDB({this.id, required this.text});

  factory TaskDB.fromMap(Map<String, dynamic> json) => TaskDB(
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
