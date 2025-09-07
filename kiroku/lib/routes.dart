import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import 'screens/anime_detail_screen.dart';
import 'models/anime.dart';

class AppRoutes {
  static const home = '/';
  static const animeDetail = '/animeDetail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const MainScreen());

      case animeDetail:
        final args = settings.arguments;
        if (args is Anime) {
          return MaterialPageRoute(
            builder: (_) => AnimeDetailScreen(anime: args),
          );
        } else {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(
                child: Text(
                  "Anime not provided",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          );
        }

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("Page not found")),
          ),
        );
    }
  }
}