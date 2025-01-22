import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/publisher_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
}

class PublisherService {
  static Future<List<Publisher>> fetchPublisher() async {
    final response =
        await http.get(Uri.parse('${dotenv.env['API_URL']}/publishers'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> data = responseData['data'];
      return data.map((json) => Publisher.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load publishers");
    }
  }
}
