import 'package:flutter/material.dart';
import 'package:sahayak/presentation/pages/splash/splash_page.dart';
import 'package:sahayak/presentation/pages/chat/chat_page.dart';
import 'package:sahayak/presentation/pages/home/home_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/chat':
        return MaterialPageRoute(builder: (_) => const ChatPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
