import 'package:flutter/material.dart';

import 'package:momo_pills/views/error_page.dart';
import 'package:momo_pills/views/home_view.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeScreen());

      default:
        return MaterialPageRoute(builder: (_) => const ErrorScreen());
    }
  }

}