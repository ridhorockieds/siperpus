import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/transaction_add_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
}

class TransactionDeleteService {
  static Future<void> deleteTransaction(int transactionId) async {
    final response = await http.delete(
      Uri.parse('${dotenv.env['API_URL']}/transactions/$transactionId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete transaction');
    }
  }
}

class TransactionAddService {
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

  static Future<List<Publisher>> fetchPublishers() async {
    final response =
        await http.get(Uri.parse('${dotenv.env['API_URL']}/publishers'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => Publisher.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load publishers');
    }
  }

  static Future<void> createTransaction(
      int bookId, int publisherId, int total) async {
    final response = await http.post(
      Uri.parse('${dotenv.env['API_URL']}/transactions'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'book_id': bookId,
        'publisher_id': publisherId,
        'total': total,
      }),
    );

    final respon = json.decode(response.body);

    if (respon['success'] == false) {
      throw Exception('Failed to create transaction');
    }
  }
}
