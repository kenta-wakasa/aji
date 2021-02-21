import 'package:aji/page/common_widget/normal_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/providers.dart';
import 'common_widget/google_button.dart';

class MyPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final provider = watch(usersProvider);
    final users = provider.users;
    final anonymous = users.id == null;
    final textStyle = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text('マイページ', style: textStyle.headline6)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(flex: 6),
          CircleAvatar(
            foregroundImage: NetworkImage(users.avatarUrl),
            radius: 40,
          ),
          const Spacer(flex: 1),
          InkWell(
            onLongPress: anonymous ? null : () => provider.changeName(context),
            child: Text(users.name, style: textStyle.bodyText1),
          ),
          const Spacer(flex: 4),
          anonymous
              ? GoogleButton()
              : NormalButton(
                  text: 'サインアウト',
                  onPressed: provider.signOut,
                ),
          const Spacer(flex: 6),
          const SizedBox(width: double.infinity, height: 0)
        ],
      ),
    );
  }
}
