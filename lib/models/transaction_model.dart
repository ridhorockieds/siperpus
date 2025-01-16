class Transaction {
  int id;
  int bookId;
  int publisherId;
  int total;
  String createdAt;
  String updatedAt;
  Book book;
  Publisher publisher;

  Transaction({
    required this.id,
    required this.bookId,
    required this.publisherId,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
    required this.book,
    required this.publisher,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      bookId: json['book_id'],
      publisherId: json['publisher_id'],
      total: json['total'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      book: Book.fromJson(json['book']),
      publisher: Publisher.fromJson(json['publisher']),
    );
  }
}

class Book {
  int id;
  String title;
  int price;
  int stock;
  String createdAt;
  String updatedAt;

  Book({
    required this.id,
    required this.title,
    required this.price,
    required this.stock,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      price: json['price'],
      stock: json['stock'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class Publisher {
  int id;
  String name;
  String address;
  String phone;
  String createdAt;
  String updatedAt;

  Publisher({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Publisher.fromJson(Map<String, dynamic> json) {
    return Publisher(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
