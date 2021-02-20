import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/providers.dart';
import 'change_name_dialog.dart';
import 'common_widget/google_button.dart';

class MyPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _authProvider = watch(authProvider);
    final users = _authProvider.users;
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
              onLongPress: users.id == null
                  ? null
                  : () async {
                      final res = await ChangeNameDialog.showDialog(
                        context,
                        users.name,
                      );
                      if (res?.isNotEmpty ?? false) {
                        await _authProvider.updateName(res);
                      }
                    },
              child: Text(
                users.name,
                style: theme.textTheme.bodyText1,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await _authProvider.signOut();
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
