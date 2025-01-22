import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/book_add_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
}

class BookDeleteService {
  static Future<void> deleteBook(int bookId) async {
    final response = await http.delete(
      Uri.parse('${dotenv.env['API_URL']}/books/$bookId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete book');
    }
  }
}

class BookAddService {
  static Future<List<Book>> fetchBooks() async {
    final response =
        await http.get(Uri.parse('${dotenv.env['API_URL']}/books'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }

  static Future<void> createBook(int bookId, int total) async {
    final response = await http.post(
      Uri.parse('${dotenv.env['API_URL']}/books'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'book_id': bookId,
        'total': total,
      }),
    );

    final respon = json.decode(response.body);

    if (respon['success'] == false) {
      throw Exception('Failed to create books');
    }
  }
}
