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
  static const String _darkModeKey = 'isDarkMode';
  String? _error;
  bool _isLoading = false;
  static const String API_KEY = 'a3cbe3d1aef04332a6d4cfe900988a1f';

  List<Article> get articles => _articles;
  List<Article> get savedArticles => _savedArticles;
  bool get isDarkMode => _isDarkMode;
  String? get error => _error;
  bool get isLoading => _isLoading;

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> resetToHomeFeed() async {
    try {
      _selectedCategory = 'general';
      await fetchArticles();
    } catch (e) {
      //debugPrint('Error resetting home feed: $e');
      _setError('Failed to reset home feed: $e');
    }
  }

  Future<void> fetchArticles([String? query]) async {
    try {
      _setError(null);
      _setLoading(true);

      String url = 'https://newsapi.org/v2/top-headlines?'
          'country=us&category=$_selectedCategory&apiKey=$API_KEY';

      if (query != null && query.isNotEmpty) {
        url = 'https://newsapi.org/v2/everything?q=$query&apiKey=$API_KEY';
      }

      //debugPrint('Fetching articles from: $url');

      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Connection timeout. Please check your internet connection.');
        },
      );

      //debugPrint('API Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'error') {
          throw Exception(data['message'] ?? 'Unknown API error');
        }

        if (!data.containsKey('articles')) {
          throw Exception('Invalid API response format: missing articles');
        }

        _articles = (data['articles'] as List)
            .map((article) => Article.fromJson(article))
            .where((article) =>
        article.title != '[Removed]' &&
            article.description != '[Removed]' &&
            article.title.isNotEmpty &&
            article.description.isNotEmpty &&
            article.urlToImage.isNotEmpty)
            .toList();

        if (_articles.isEmpty) {
          _setError('No articles found matching your criteria');
        }

      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key. Please check your configuration.');
      } else if (response.statusCode == 429) {
        throw Exception('API rate limit exceeded. Please try again later.');
      } else {
        throw Exception('Failed to load news: Status ${response.statusCode}');
      }
    } catch (e) {
      //debugPrint('Error fetching articles: $e');
      _setError(e.toString());
      _articles = [];
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> setCategory(String category) async {
    try {
      _selectedCategory = category;
      await fetchArticles();
    } catch (e) {
      //debugPrint('Error setting category: $e');
      _setError('Failed to set category: $e');
    }
  }

  Future<void> toggleSavedArticle(Article article) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> savedArticles = prefs.getStringList('savedArticles') ?? [];

      if (_savedArticles.any((a) => a.url == article.url)) {
        _savedArticles.removeWhere((a) => a.url == article.url);
        savedArticles.removeWhere((a) {
          try {
            Map<String, dynamic> savedArticle = json.decode(a);
            return savedArticle['url'] == article.url;
          } catch (e) {
            //debugPrint('Error parsing saved article during removal: $e');
            return false;
          }
        });
      } else {
        _savedArticles.add(article);
        savedArticles.add(json.encode(article.toJson()));
      }

      await prefs.setStringList('savedArticles', savedArticles);
      notifyListeners();
    } catch (e) {
      //debugPrint('Error toggling saved article: $e');
      _setError('Failed to save article: $e');
    }
  }

  Future<void> loadSavedArticles() async {
    try {
      _setLoading(true);
      final prefs = await SharedPreferences.getInstance();
      final savedArticles = prefs.getStringList('savedArticles') ?? [];

      _savedArticles = savedArticles.map((articleString) {
        try {
          Map<String, dynamic> json = jsonDecode(articleString);
          return Article.fromJson(json);
        } catch (e) {
          //debugPrint('Error parsing saved article: $e');
          return null;
        }
      }).whereType<Article>().toList();

      if (_savedArticles.isEmpty && savedArticles.isNotEmpty) {
        _setError('Failed to load some saved articles. They might be in an incompatible format.');
        await prefs.setStringList('savedArticles', []);
      }

      notifyListeners();
    } catch (e) {
      //debugPrint('Error loading saved articles: $e');
      _setError('Failed to load saved articles: $e');
      _savedArticles = [];
    } finally {
      _setLoading(false);
    }
  }
//DarkMode save
  Future<void> toggleDarkMode() async {
    try {
      _isDarkMode = !_isDarkMode;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_darkModeKey, _isDarkMode);
      notifyListeners();
    } catch (e) {
      //debugPrint('Error saving dark mode setting: $e');
      _isDarkMode = !_isDarkMode;
      notifyListeners();
    }
  }

  void clearError() {
    _setError(null);
  }

  Future<void> _loadDarkModeSetting() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool(_darkModeKey) ?? false;
      notifyListeners();
    } catch (e) {
      //debugPrint('Error loading dark mode setting: $e');
    }
  }

  // Initialize saved articles and DarkMode when the provider is created
  NewsProvider() {
    loadSavedArticles();
    _loadDarkModeSetting();
  }
}