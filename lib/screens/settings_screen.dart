import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
          ),
          body: ListView(
            children: [
              ListTile(
                title: const Text('Dark Mode'),
                trailing: Switch(
                  value: newsProvider.isDarkMode,
                  onChanged: (value) {
                    newsProvider.toggleDarkMode();
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