import 'package:flutter/foundation.dart';

class Article {
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String source;

  Article({
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.source,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    try {
      return Article(
        title: json['title']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
        url: json['url']?.toString() ?? '',
        urlToImage: json['urlToImage']?.toString() ?? '',
        publishedAt: json['publishedAt']?.toString() ?? '',
        source: json['source'] is Map
            ? json['source']['name']?.toString() ?? ''
            : json['source']?.toString() ?? '',
      );
    } catch (e) {
      debugPrint('Error parsing article: $e');
      return Article(
        title: '',
        description: '',
        url: '',
        urlToImage: '',
        publishedAt: '',
        source: '',
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      'source': source,
    };
  }

  @override
  String toString() {
    return 'Article{title: $title, url: $url, source: $source}';
  }
}