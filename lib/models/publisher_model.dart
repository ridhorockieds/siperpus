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

  // Factory constructor untuk parsing JSON
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
