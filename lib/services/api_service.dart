import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote_model.dart';

class ApiService {
  static const String _baseUrl = 'https://dummyjson.com/quotes/random';

  Future<QuoteModel> fetchRandomQuote() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl)).timeout(
            const Duration(seconds: 10),
          );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return QuoteModel.fromJson(data);
      } else {
        throw Exception('Gagal mengambil data dari server (Code: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Gagal terhubung ke REST API: $e');
    }
  }
}