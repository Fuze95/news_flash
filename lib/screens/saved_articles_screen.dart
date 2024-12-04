import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import '../widgets/news_card.dart';

class SavedArticlesScreen extends StatelessWidget {
  const SavedArticlesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Saved Articles'),
          ),
          body: ListView.builder(
            itemCount: newsProvider.savedArticles.length,
            itemBuilder: (context, index) {
              return NewsCard(article: newsProvider.savedArticles[index]);
            },
          ),
        );
      },
    );
  }
}