import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/providers.dart';
import 'change_name_dialog.dart';
import 'common_widget/google_button.dart';

class MyPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final provider = watch(authProvider);
    final userName = provider.auth.currentUser.displayName ?? 'ゲスト';
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'マイページ',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            InkWell(
              onLongPress: provider.auth.currentUser.isAnonymous
                  ? null
                  : () async {
                      final res = await ChangeNameDialog.showDialog(
                        context,
                        userName,
                      );
                      if (res != null || res.isEmpty) {
                        await provider.changeName(res);
                      }
                    },
              child: Text(
                userName,
                style: theme.textTheme.bodyText1,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await provider.signOut();
              },
              child: const Text('サインアウト'),
            ),
            GoogleButton(),
          ],
        ),
      ),
    );
  }
}
