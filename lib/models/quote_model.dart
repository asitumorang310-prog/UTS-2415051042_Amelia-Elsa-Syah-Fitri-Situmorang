class QuoteModel {
  final int id;
  final String quote;
  final String author;

  QuoteModel({
    required this.id,
    required this.quote,
    required this.author,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      id: json['id'] ?? 0,
      quote: json['quote'] ?? json['body'] ?? '',
      author: json['author'] ?? 'Anonim',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quote': quote,
      'author': author,
    };
  }
}