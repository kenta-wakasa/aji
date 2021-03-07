import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';

class SettingPage extends ConsumerWidget {
  const SettingPage._();

  static void showPage(BuildContext context) {
    Navigator.of(context).push<void>(MaterialPageRoute(builder: (_) => const SettingPage._()));
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _themeProvider = watch(themeProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('設定', style: AppBarTheme.of(context).titleTextStyle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            ListTile(
              leading: const Text('テーマモード'),
              trailing: DropdownButton<ThemeMode>(
                value: _themeProvider.mode,
                icon: const Icon(Icons.arrow_drop_down_rounded),
                iconSize: 24,
                elevation: 16,
                onChanged: _themeProvider.updateThemeMode,
                items: <ThemeMode>[
                  ThemeMode.system,
                  ThemeMode.light,
                  ThemeMode.dark,
                ].map<DropdownMenuItem<ThemeMode>>(
                  (ThemeMode mode) {
                    return DropdownMenuItem<ThemeMode>(
                      value: mode,
                      child: Text(_themeProvider.themeModeToString(mode)),
                    );
                  },
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
