import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import '../widgets/news_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search news...',
            hintStyle: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(
                Icons.search,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
              onPressed: () {
                if (_searchController.text.isNotEmpty) {
                  context.read<NewsProvider>().fetchArticles(_searchController.text);
                }
              },
            ),
          ),
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          cursorColor: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      body: Consumer<NewsProvider>(
        builder: (context, newsProvider, child) {
          return ListView.builder(
            itemCount: newsProvider.articles.length,
            itemBuilder: (context, index) {
              return NewsCard(article: newsProvider.articles[index]);
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}