import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'providers/news_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        return MaterialApp(
          title: 'NEWS FLASH',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: const Color(0xFF007BFF),
            brightness: newsProvider.isDarkMode ? Brightness.dark : Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF007BFF),
              primary: const Color(0xFF007BFF),
              secondary: const Color(0xFF73C2FB),
              brightness: newsProvider.isDarkMode ? Brightness.dark : Brightness.light,
            ),
          ),
          home: const SplashScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}