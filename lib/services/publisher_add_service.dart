import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/publisher_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
}

class PublisherDeleteService {
  static Future<void> deletePublisher(int publisherId) async {
    final response = await http.delete(
      Uri.parse('${dotenv.env['API_URL']}/publishers/$publisherId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete publisher');
    }
  }
}

class PublisherAddService {
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

  static Future<void> createPublisher(int publisherId, int total) async {
    final response = await http.post(
      Uri.parse('${dotenv.env['API_URL']}/publishers'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'publisher_id': publisherId,
        'total': total,
      }),
    );

    final respon = json.decode(response.body);

    if (respon['success'] == false) {
      throw Exception('Failed to create publishers');
    }
  }
}
