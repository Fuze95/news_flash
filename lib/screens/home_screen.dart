import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import '../widgets/news_card.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final List<String> categories = [
    'business',
    'entertainment',
    'science',
    'sports',
    'technology'
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'News Flash',
              style: TextStyle(
                fontFamily: 'Merriweather',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: Column(
            children: [
              _buildCategoriesBar(context, newsProvider),
              // News List with Error Handling
              Expanded(
                child: _buildNewsList(context, newsProvider),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoriesBar(BuildContext context, NewsProvider newsProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(
                left: index == 0 ? 16 : 8,
                right: index == categories.length - 1 ? 16 : 0,
              ),
              child: ActionChip(
                backgroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                label: Text(
                  categories[index].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                onPressed: () {
                  newsProvider.setCategory(categories[index]);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNewsList(BuildContext context, NewsProvider newsProvider) {
    if (newsProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (newsProvider.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              const SizedBox(height: 16),
              Text(
                'Error Loading News',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                newsProvider.error!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[300]
                      : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  newsProvider.fetchArticles();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    if (newsProvider.articles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.newspaper,
              size: 60,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No articles found',
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[300]
                    : Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => newsProvider.fetchArticles(),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8),
        itemCount: newsProvider.articles.length,
        itemBuilder: (context, index) {
          final article = newsProvider.articles[index];
          return NewsCard(article: article);
        },
      ),
    );
  }
}