class Book {
  final int id;
  final String title;
  final int stock;
  final int price;

  Book(
      {required this.id,
      required this.title,
      required this.stock,
      required this.price});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      stock: json['stock'],
      price: json['price'],
    );
  }
}
