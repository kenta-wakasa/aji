import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/providers/providers.dart';

class AddPostDialog extends ConsumerWidget {
  const AddPostDialog._();
  static Future<void> showDialog(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => const AddPostDialog._(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _postProvider = watch(postsProvider);
    final file = _postProvider.imageFile;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '投稿',
          style: AppBarTheme.of(context).titleTextStyle,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.send_rounded),
            onPressed: file != null
                ? () async {
                    await _postProvider.addPosts();
                    Navigator.of(context).pop();
                  }
                : null,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: _postProvider.addImage,
              child: file != null ? Image.file(file) : const Placeholder(),
            ),
            TextField(
              textAlign: TextAlign.center,
              onChanged: (value) {
                _postProvider.title = value;
              },
              decoration: const InputDecoration(
                hintText: 'タイトルをつける',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
