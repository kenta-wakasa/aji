import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import 'add_post_dialog.dart';

class PostListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final provider = watch(postListProvider);
    final controller = ScrollController();
    controller.addListener(
      () {
        final maxScrollExtent = controller.position.maxScrollExtent;
        final currentPosition = controller.position.pixels;
        if (maxScrollExtent > 0 && (maxScrollExtent + 100) <= currentPosition) {
          provider.fetchNextPosts();
        }
      },
    );
    print(provider.postList.length);
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
      body: ListView.builder(
        controller: controller,
        itemCount: provider.postList.length,
        itemBuilder: (context, index) {
          final post = provider.postList[index];
          return ListTile(title: Image.network(post.url));
        },
      ),
    );
  }
}
