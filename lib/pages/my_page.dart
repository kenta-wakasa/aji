import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import 'settings_page.dart';
import 'utils/google_button.dart';
import 'utils/normal_button.dart';

class MyPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final provider = watch(usersProvider);
    final users = provider.users;
    final anonymous = users.anonymous;
    final avatarImage = anonymous ? const AssetImage('images/default_avatar.png') : NetworkImage(users.avatarUrl);
    final textStyle = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'マイページ',
          style: AppBarTheme.of(context).titleTextStyle,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => SettingPage.showPage(context),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(flex: 6),
          CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundImage: avatarImage as ImageProvider,
            radius: 40,
          ),
          const Spacer(flex: 1),
          InkWell(
            onLongPress: anonymous ? null : () => provider.updateName(context),
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
