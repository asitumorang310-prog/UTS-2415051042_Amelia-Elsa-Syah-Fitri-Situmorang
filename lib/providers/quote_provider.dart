import 'package:flutter/material.dart';
import '../models/quote_model.dart';
import '../repositories/quote_repository.dart';

enum QuoteStatus { initial, loading, loaded, error }

class QuoteProvider extends ChangeNotifier {
  final QuoteRepository _repository = QuoteRepository();

  QuoteStatus _status = QuoteStatus.initial;
  QuoteModel? _quote;
  String _errorMessage = '';

  QuoteStatus get status => _status;
  QuoteModel? get quote => _quote;
  String get errorMessage => _errorMessage;

  Future<void> fetchQuote() async {
    _status = QuoteStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      _quote = await _repository.getRandomQuote();
      _status = QuoteStatus.loaded;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _status = QuoteStatus.error;
    }
    notifyListeners();
  }
}