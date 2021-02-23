import 'package:aji/provider/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'navigation_page.dart';

class MainPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    watch(usersProvider);
    final mainColor = Colors.lightBlue[900];
    // const mainColor = Colors.white;
    return MaterialApp(
      theme: ThemeData(
        primaryColor: mainColor,
        accentColor: mainColor,
        buttonColor: mainColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          iconTheme: IconThemeData(color: mainColor),
          elevation: 0.4,
        ),
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 120,
            color: mainColor,
            fontWeight: FontWeight.bold,
          ),
          headline6: TextStyle(
            fontSize: 16,
            color: mainColor,
            fontWeight: FontWeight.bold,
          ),
          bodyText1: const TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          button: const TextStyle(fontWeight: FontWeight.bold),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: mainColor,
        ),
      ),
      home: NavigationPage(),
    );
  }
}
