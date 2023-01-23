class Note {
  final int? id;
  final int? notebookID;
  final String? notebookName;
  final String title;
  final String content;
  final String date;

  const Note({
    this.id,
    this.notebookID,
    this.notebookName,
    required this.content,
    required this.title,
    required this.date,
  });

  factory Note.fromMap(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      notebookID: json['notebookID'],
      notebookName: json['notebookName'],
      title: json['title'],
      content: json['content'].toString(),
      date: json['date'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'notebookID': notebookID,
      'notebookName': notebookName,
      'title': title,
      'content': content,
      'date': date,
    };
  }
}
