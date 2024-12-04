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
            title: const Text(
              'Settings',
              style: TextStyle(
                fontFamily: 'Merriweather',
              ),
            ),
          ),
          body: Column(
            children: [
              // Settings List
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      title: const Text(
                        'Dark Mode',
                        style: TextStyle(
                          fontFamily: 'Merriweather',
                        ),
                      ),
                      trailing: Switch(
                        value: newsProvider.isDarkMode,
                        onChanged: (value) {
                          newsProvider.toggleDarkMode();
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Company Info at bottom
              const Divider(height: 1),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: const Column(
                  children: [
                    Text(
                      'News Flash',
                      style: TextStyle(
                        fontFamily: 'Merriweather',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        fontFamily: 'Merriweather',
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '© 2024 VGSM Wijerathna (K2421736). All rights reserved.',
                      style: TextStyle(
                        fontFamily: 'Merriweather',
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}