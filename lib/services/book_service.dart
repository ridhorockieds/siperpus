import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/book_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
}

class BookService {
  static Future<List<Book>> fetchBook() async {
    final response =
        await http.get(Uri.parse('${dotenv.env['API_URL']}/books'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> data = responseData['data'];
      return data.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load books");
    }
  }
}
