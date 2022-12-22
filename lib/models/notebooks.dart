class Notebook {
  final int? id;
  final String name;

  const Notebook({
    this.id,
    required this.name,
  });

  factory Notebook.fromMap(Map<String, dynamic> json) {
    return Notebook(
      id: json['id'],
      name: json['notebook'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'notebook': name,
    };
  }
}
