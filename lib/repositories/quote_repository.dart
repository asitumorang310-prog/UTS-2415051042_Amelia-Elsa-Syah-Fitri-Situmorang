import '../models/quote_model.dart';
import '../services/api_service.dart';

class QuoteRepository {
  final ApiService _apiService = ApiService();

  Future<QuoteModel> getRandomQuote() async {
    return await _apiService.fetchRandomQuote();
  }
}