import 'package:flutter/material.dart';
import 'package:sl_app/ui/login_screen.dart';

void main() {
  runApp(const MyApp());
}
final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    home: login_screen(navigatorKey),
      navigatorKey: navigatorKey,
    );
  }
}

