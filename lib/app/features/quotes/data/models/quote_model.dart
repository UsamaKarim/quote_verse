import 'package:quote_verse/app/features/quotes/domain/entities/quote.dart';

class QuoteModel {
  const QuoteModel({
    required this.id,
    required this.text,
    required this.author,
    this.isFavorite = false,
  });
  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      id: json['id'] as String,
      text: json['text'] as String,
      author: json['author'] as String,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  factory QuoteModel.fromEntity(Quote quote) {
    return QuoteModel(
      id: quote.id,
      text: quote.text,
      author: quote.author,
      isFavorite: quote.isFavorite,
    );
  }

  final String id;
  final String text;
  final String author;
  final bool isFavorite;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'author': author,
      'isFavorite': isFavorite,
    };
  }

  Quote toEntity() {
    return Quote(
      id: id,
      text: text,
      author: author,
      isFavorite: isFavorite,
    );
  }

  QuoteModel copyWith({
    String? id,
    String? text,
    String? author,
    bool? isFavorite,
  }) {
    return QuoteModel(
      id: id ?? this.id,
      text: text ?? this.text,
      author: author ?? this.author,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
