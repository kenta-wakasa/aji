import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import 'add_post_dialog.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 40,
          child: Image.asset(
            'images/logo.png',
            color: AppBarTheme.of(context).foregroundColor,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_rounded),
        onPressed: () => AddPostDialog.showDialog(context),
      ),
    );
  }
}
