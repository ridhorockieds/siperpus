class Book {
  final int id;
  final String title;

  Book({required this.id, required this.title});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
    );
  }
}

class Publisher {
  final int id;
  final String name;

  Publisher({required this.id, required this.name});

  factory Publisher.fromJson(Map<String, dynamic> json) {
    return Publisher(
      id: json['id'],
      name: json['name'],
    );
  }
}
