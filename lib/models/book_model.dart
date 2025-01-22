class Book {
  final int id;
  final String title;
  final String price;
  final int stock;
  final String createdAt;
  final String updatedAt;

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
