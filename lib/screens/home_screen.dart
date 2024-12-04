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
              Container(
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
              ),

              // News List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 8),
                  itemCount: newsProvider.articles.length,
                  itemBuilder: (context, index) {
                    final article = newsProvider.articles[index];
                    return NewsCard(article: article);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}