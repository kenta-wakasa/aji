import 'package:aji/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/pages/navigation_page.dart';
import '/providers/providers.dart';

class MainPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    watch(usersProvider);
    final _themeProvider = watch(themeProvider);
    return MaterialApp(
      themeMode: _themeProvider.mode,
      theme: _themeProvider.themeDataLight,
      darkTheme: _themeProvider.themeDataDark,
      home: NavigationPage(),
    );
  }
}
