import 'package:flutter/material.dart';
import 'package:notexia/src/app/config/routes/app_routes.dart';
import 'package:notexia/src/app/presentation/pages/main_layout.dart';

class AppRouter {
  static const String initialRoute = AppRoutes.home;

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
      case AppRoutes.editor:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const MainLayout(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
