import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/article.dart';

class NewsProvider with ChangeNotifier {
  List<Article> _articles = [];
  List<Article> _savedArticles = [];
  String _selectedCategory = 'general';
  bool _isDarkMode = false;
  static const String API_KEY = 'a3cbe3d1aef04332a6d4cfe900988a1f';

  List<Article> get articles => _articles;
  List<Article> get savedArticles => _savedArticles;
  bool get isDarkMode => _isDarkMode;

  Future<void> resetToHomeFeed() async {
    _selectedCategory = 'general';
    await fetchArticles();
  }

  Future<void> fetchArticles([String? query]) async {
    String url = 'https://newsapi.org/v2/top-headlines?'
        'country=us&category=$_selectedCategory&apiKey=$API_KEY';

    if (query != null && query.isNotEmpty) {
      url = 'https://newsapi.org/v2/everything?q=$query&apiKey=$API_KEY';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _articles = (data['articles'] as List)
          .map((article) => Article.fromJson(article))
          .where((article) =>
      article.title != '[Removed]' &&
          article.description != '[Removed]' &&
          article.title.isNotEmpty &&
          article.description.isNotEmpty &&
          article.urlToImage.isNotEmpty
      )
          .toList();
      notifyListeners();
    }
  }

  void setCategory(String category) {
    _selectedCategory = category;
    fetchArticles();
  }

  Future<void> toggleSavedArticle(Article article) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedArticles = prefs.getStringList('savedArticles') ?? [];

    if (_savedArticles.any((a) => a.url == article.url)) {
      _savedArticles.removeWhere((a) => a.url == article.url);
      savedArticles.removeWhere((a) => json.decode(a)['url'] == article.url);
    } else {
      _savedArticles.add(article);
      savedArticles.add(json.encode(article.toJson()));
    }

    await prefs.setStringList('savedArticles', savedArticles);
    notifyListeners();
  }

  Future<void> loadSavedArticles() async {
    final prefs = await SharedPreferences.getInstance();
    final savedArticles = prefs.getStringList('savedArticles') ?? [];
    _savedArticles = savedArticles
        .map((article) => Article.fromJson(json.decode(article)))
        .toList();
    notifyListeners();
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
