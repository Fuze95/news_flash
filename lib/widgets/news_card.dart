import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/article.dart';
import '../providers/news_provider.dart';
import '../screens/article_detail_screen.dart';

class NewsCard extends StatelessWidget {
  final Article article;

  const NewsCard({Key? key, required this.article}) : super(key: key);

  Future<void> _shareArticle() async {
    try {
      await Share.share(
        '${article.title}\n\nRead more: ${article.url}',
        subject: article.title,
      );
    } catch (e) {
      debugPrint('Error sharing article: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 4,
      child: InkWell(
        onTap: () {
          if (article.url.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArticleDetailScreen(
                  url: article.url,
                  title: article.title,
                ),
              ),
            );
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(context),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle(context),
                  const SizedBox(height: 8),
                  _buildDescription(context),
                  const SizedBox(height: 12),
                  _buildFooter(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    if (article.urlToImage.isEmpty) {
      return _buildPlaceholder();
    }

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
      child: Stack(
        children: [
          Image.network(
            article.urlToImage,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return _buildImageLoading(loadingProgress);
            },
            errorBuilder: (context, error, stackTrace) {
              debugPrint('Error loading image: $error');
              return _buildPlaceholder();
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              height: 60,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageLoading(ImageChunkEvent loadingProgress) {
    return Container(
      height: 200,
      color: Colors.grey[200],
      child: Center(
        child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
              loadingProgress.expectedTotalBytes!
              : null,
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 200,
      color: Colors.grey[300],
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 40,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      article.title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        // Title will automatically use correct dark/light color from theme
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDescription(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Text(
      article.description,
      style: TextStyle(
        fontSize: 14,
        // Use theme-appropriate colors for dark/light mode
        color: isDark ? Colors.grey[300] : Colors.black87,
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            article.source,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[400]
                  : Colors.grey[600],
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.share_outlined,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: _shareArticle,
            ),
            _buildBookmarkButton(context),
          ],
        ),
      ],
    );
  }

  Widget _buildBookmarkButton(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        final isSaved = newsProvider.savedArticles
            .any((a) => a.url == article.url);
        return IconButton(
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Icon(
              isSaved ? Icons.bookmark : Icons.bookmark_border_outlined,
              key: ValueKey<bool>(isSaved),
              color: Theme.of(context).primaryColor,
            ),
          ),
          onPressed: () {
            newsProvider.toggleSavedArticle(article);
          },
        );
      },
    );
  }
}