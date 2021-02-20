import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'navigation_page.dart';

class MainPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.lightBlue[900],
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontSize: 120,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          headline6: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          bodyText1: TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          button: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      home: NavigationPage(),
    );
  }
}
