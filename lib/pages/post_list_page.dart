import 'package:aji/pages/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';
import 'add_post_dialog.dart';

class PostListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final provider = watch(postListProvider);
    final controller = watch(navigationProvider).scrollController;
    controller.addListener(
      () {
        final maxScrollExtent = controller.position.maxScrollExtent;
        final currentPosition = controller.position.pixels;
        if (maxScrollExtent > 0 && (maxScrollExtent + 100) <= currentPosition) {
          provider.fetchNextPosts();
        }
      },
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_rounded),
        onPressed: () => AddPostDialog.showDialog(context),
      ),
      body: CustomScrollView(
        controller: controller,
        slivers: [
          SliverAppBar(
            floating: true,
            title: SizedBox(
              height: 40,
              child: Image.asset('images/logo.png', color: AppBarTheme.of(context).foregroundColor),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final posts = provider.postList[index];
              return PostCard(posts: posts);
            }, childCount: provider.postList.length),
          ),
        ],
      ),
    );
  }
}
