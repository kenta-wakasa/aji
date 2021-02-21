import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/providers.dart';

class AddPostDialog extends ConsumerWidget {
  const AddPostDialog._();
  static Future<void> showDialog(BuildContext context) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => const AddPostDialog._(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _postProvider = watch(postsProvider);
    final file = _postProvider.imageFile;
    return Scaffold(
      appBar: AppBar(
        title: Text('投稿', style: Theme.of(context).textTheme.headline6),
        actions: [
          IconButton(
            icon: const Icon(Icons.send_rounded),
            onPressed: _postProvider.addPosts,
          ),
        ],
      ),
      body: Center(
        child: InkWell(
          onTap: _postProvider.addImage,
          child: SizedBox(
            width: 200,
            height: 200,
            child: file != null ? Image.file(file) : const Placeholder(),
          ),
        ),
      ),
    );
  }
}
